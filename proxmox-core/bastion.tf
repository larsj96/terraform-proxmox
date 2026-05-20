resource "proxmox_virtual_environment_vm" "bastion01" {
  vm_id         = 9010
  name          = "bastion01"
  description   = "Linux jump host managed by Terraform"
  node_name     = var.target_node_name
  tags          = ["terraform", "ubuntu", "bastion"]
  on_boot       = true
  started       = true
  scsi_hardware = "virtio-scsi-single"

  cpu {
    cores = 4
    type  = "x86-64-v2-AES"
  }

  memory {
    dedicated = 32768
  }

  agent {
    enabled = true
  }

  operating_system {
    type = "l26"
  }

  network_device {
    bridge  = var.vm_bridge
    vlan_id = 14
  }

  disk {
    datastore_id = var.target_storage
    file_id      = proxmox_virtual_environment_download_file.ubuntu_noble_cloud_image.id
    interface    = "scsi0"
    size         = 200
    iothread     = true
    discard      = "on"
  }

  initialization {
    datastore_id = var.target_storage

    dns {
      servers = var.vm_dns_servers
    }

    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }

    user_account {
      username = var.vm_username
      keys     = [var.workstation_ssh_public_key]
    }
  }

  lifecycle {
    ignore_changes = [
      disk[0].file_id,
      node_name,
    ]
  }
}
