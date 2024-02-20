locals {
    talos-cp1 = {
      "num_cpus" = "4"
      "memory"   = "16192"
      "disksize" = 100
      vlan       = "12"
    }

    talos-cp2 = {
      "num_cpus" = "4"
      "memory"   = "16192"
      "disksize" = 100
      vlan       = "12"
    }

    talos-cp3 = {
      "num_cpus" = "4"
      "memory"   = "16192"
      "disksize" = 100
      vlan       = "12"
    }


    talos-work1 = {
      "num_cpus" = "4"
      "memory"   = "16192"
      "disksize" = 125
      vlan       = "12"
    }

    talos-work2 = {
      "num_cpus" = "4"
      "memory"   = "16192"
      "disksize" = 125
      vlan       = "12"
    }

    talos-work3 = {
      "num_cpus" = "4"
      "memory"   = "16192"
      "disksize" = 125
      vlan       = "12"

    }

}


#    vault01 = {
#       vmid           = 1736
#       type           = "x86-64-v2-AES"
#       sockets        = 1
#       cores          = 4
#       memory         = 8192
#       disk_size      = 50
#       template_name  = "ubuntu-2204-efi"
#       pve_host       = "pve01"
#       os_type        = "ubuntu"
#       cicustom       = "./cloud-init-ubuntu.yaml"
#       disk_type      = "scsi"
#       storage        = "STORAGE"
#       bootdisk       = "scsi0"
#       network_model  = "virtio"
#       network_bridge = "vmbr500"
#       ip_address     = "10.50.0.15/24"
#       gateway        = "10.50.0.1"
#       network_tag    = 50
#       onboot         = true
#       template       = 9999
#     }



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







# resource "proxmox_virtual_environment_vm" "talos_images" {

#   for_each = local.talos_images


#   description = "Managed by Terraform"
#   tags        = ["terraform", "talos"]

#   name = each.key

#   iso         = "local:iso/metal-amd64.iso"
#   target_node = "hp1"

#    bios            = var.pve_vm_bios
#    machine         = var.pve_vm_machine
#    tablet_device   = var.tablet_device


#   vmid        = "${001}${num + 1}"
#   qemu_os     = "l26" # Linux kernel type
#   scsihw      = "virtio-scsi-pci"
#   memory {
#     dedicated = each.value.memory
#   }

#   cpu {
#     sockets = "1"
#     cores   = each.value.cores
#     type    = "x86-64-v2-AES"
#     flags   = ["+aes", "+spec-ctrl", "+ssbd"]
#   }

#   sockets     = 1
#   network {
#     model  = "virtio"
#     tag    = each.value.vlan
#     bridge = "vmbr1"
#   }

#   disk {
#     type    = "virtio"
#     size    = each.value.disksize
#     storage = var.boot_disk_storage_pool
#   }

# }