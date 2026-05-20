locals {
  use_dhcp = lower(var.vm_ipv4_address) == "dhcp"
}

resource "proxmox_virtual_environment_download_file" "ubuntu_noble_cloud_image" {
  content_type = "iso"
  datastore_id = var.image_storage
  node_name    = var.target_node_name
  url          = var.ubuntu_cloud_image_url
}

resource "proxmox_virtual_environment_vm" "ubuntu_test" {
  vm_id         = var.vm_id
  name          = var.vm_name
  description   = var.vm_description
  node_name     = var.target_node_name
  tags          = var.vm_tags
  on_boot       = false
  started       = true
  scsi_hardware = "virtio-scsi-single"

  cpu {
    cores = var.vm_cpu_cores
    type  = "x86-64-v2-AES"
  }

  memory {
    dedicated = var.vm_memory_mb
  }

  agent {
    enabled = true
  }

  operating_system {
    type = "l26"
  }

  network_device {
    bridge  = var.vm_bridge
    vlan_id = var.vm_vlan_id
  }

  disk {
    datastore_id = var.target_storage
    file_id      = proxmox_virtual_environment_download_file.ubuntu_noble_cloud_image.id
    interface    = "scsi0"
    size         = var.vm_disk_size_gb
    iothread     = true
    discard      = "on"
  }

  initialization {
    datastore_id       = var.target_storage
    user_data_file_id = proxmox_virtual_environment_file.noble_base_cloud_config.id

    dns {
      servers = var.vm_dns_servers
    }

    ip_config {
      ipv4 {
        address = var.vm_ipv4_address
        gateway = local.use_dhcp ? null : var.vm_ipv4_gateway
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
