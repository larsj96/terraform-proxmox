# resource "proxmox_virtual_environment_vm" "vm" {
#   for_each = local.linux_vms
#   name     = each.key
#   # description = "Managed by Terraform"
#   # tags        = ["terraform", "ubuntu"]

#   node_name       = each.value.pve_host
#   vm_id           = each.value.vmid
#   bios            = var.pve_vm_bios
#   machine         = var.pve_vm_machine
#   tablet_device   = var.tablet_device
#   keyboard_layout = "no"
#   agent {
#     # read 'Qemu guest agent' section, change to true only when ready
#     enabled = true
#   }

#   memory {
#     dedicated = each.value.memory
#   }

#   cpu {
#     sockets = each.value.sockets
#     cores   = each.value.cores
#     type    = "x86-64-v2-AES"
#     flags   = ["+aes", "+spec-ctrl", "+ssbd"]
#   }
#   # startup {
#   #   order      = "3"
#   #   up_delay   = "60"
#   #   down_delay = "60"
#   # }

#   efi_disk {
#     datastore_id = var.vm_datastore
#     file_format  = "raw"
#   }

#   clone {
#     datastore_id = var.vm_datastore
#     vm_id        = each.value.template
#   }

#   disk {
#     datastore_id = var.vm_datastore
#     file_format  = "raw"
#     # file_id      = proxmox_virtual_environment_file.ubuntu_cloud_image.id
#     interface = each.value.bootdisk
#     size      = each.value.disk_size
#     ssd       = true
#   }

#   serial_device {} # The Debian cloud image expects a serial port to be present


#   initialization {
#     datastore_id = var.vm_datastore
#     # interface    = "scsi1"
#     ip_config {
#       ipv4 {
#         address = each.value.ip_address
#         gateway = each.value.gateway
#       }
#     }

#     user_account {
#       keys     = [var.ssh_key]
#       password = random_password.ubuntu_vm_password.result
#       username = "devops"
#     }

#     # user_data_file_id = proxmox_virtual_environment_file.cloud_config.id
#     vendor_data_file_id = proxmox_virtual_environment_file.vendor_config.id
#   }

#   network_device {
#     bridge  = each.value.network_bridge
#     vlan_id = each.value.network_tag
#   }

#   operating_system {
#     type = "l26"
#   }

#   tpm_state {
#     datastore_id = var.vm_datastore
#     version      = "v2.0"
#   }

# }


# resource "proxmox_virtual_environment_file" "cloud_config" {
#   content_type = "snippets"
#   datastore_id = "local"
#   node_name    = "pve01"
#   source_raw {
#     data = <<EOF
# #cloud-config
# #fjasjasdas
# chpasswd:
#   expire: False
# users:
#   - default
#   - name: devops
#     groups: sudo
#     shell: /bin/bash
#     ssh-authorized-keys:
#       - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCYcEX+zLVBq4R+WhCCHqAAnhzyYMzTgfiGAb0bMz0WeYXR1As2+RzdZ3zkC9TGjFJj3jvGhKgcF7xyZxpakOkQXigkox2kQFBlpq4vmek+/Zf9TFiNBTHgp+IpI4oL9xmdbfyfZqo/JMHOX8fYjpR+y6enzKa3pxHk59Nbjb0DXODpwAHqjf52cTR1abCdr6mMSOvLtAqBbRJEF1vwJ2evXjzabpG/mOH23YgZwiKx1t+kSyNaxFLp9zCsiXmGPGXjCiPXjiFO64ANZ2m+lrDhAsjSAQjptxJFLU3ZzP2fyASXugGpCV55kBn0v+s+hukD96LE/L6nFex6idO6MSL1hQx+w/8tU4Gc6VJ9UNMpcaDqMbJo3hQYF5CDw9u6R9S5hnLpX3KGn71bkUsSLG+aULJG8McQpFDvBaFCcbUx6k+DA2Y97I2OO+PRet8TtHM8cigRb8+Y1F/cm39FwCWptYKny9f6T+Tj5UMDVotd2cSqEy+ol8zIk3pZphF4mrM= lindelien@linbast.hoeg.li
#     sudo: ALL=(ALL) NOPASSWD:ALL
# EOF

#     file_name = "cloud-config.yaml"
#   }



#   source_raw {
#     data = <<EOF
# #cloud-config
# packages:
#   - qemu-guest-agent
# runcmd:
#   - systemctl enable --now qemu-guest-agent
# EOF

#     file_name = "cloud-config.yaml"
#   }
# }

# cloud_init_modules:
#   - migrator
#   - seed_random
#   - bootcmd
#   - write_files
#   - growpart
#   - resizefs
#   - disk_setup
#   - mounts
#   - ca_certs
#   - rsyslog
#   - users_groups
#   - ssh

# users:
#   - default
#   - name: devops
#     groups: sudo
#     shell: /bin/bash
#     ssh-authorized-keys:
#       - ${trimspace(tls_private_key.ubuntu_vm_key.public_key_openssh)}
#     sudo: ALL=(ALL) NOPASSWD:ALL




# resource "proxmox_virtual_environment_file" "ubuntu_cloud_image" {
#   content_type = "iso"
#   datastore_id = "local"
#   node_name    = "pve01"

#   source_file {
#     path = "https://cloud.debian.org/images/cloud/bookworm/latest/debian-12-generic-amd64.qcow2"
#   }
# }


