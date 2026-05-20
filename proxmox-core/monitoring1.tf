resource "proxmox_virtual_environment_vm" "monitoring1" {
  vm_id         = 9040
  name          = "monitoring1"
  description   = "Central monitoring stack host managed by Terraform"
  node_name     = var.target_node_name
  tags          = ["terraform", "ubuntu", "monitoring", "docker"]
  on_boot       = true
  started       = true
  scsi_hardware = "virtio-scsi-single"

  cpu {
    cores = 8
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
    vlan_id = 12
  }

  disk {
    datastore_id = var.target_storage
    file_id      = proxmox_virtual_environment_download_file.ubuntu_noble_cloud_image.id
    interface    = "scsi0"
    size         = 500
    iothread     = true
    discard      = "on"
  }

  initialization {
    datastore_id      = var.target_storage
    user_data_file_id = proxmox_virtual_environment_file.noble_base_cloud_config.id

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
      keys     = local.default_ssh_public_keys
    }
  }

  lifecycle {
    ignore_changes = [
      disk[0].file_id,
      node_name,
    ]
  }
}
