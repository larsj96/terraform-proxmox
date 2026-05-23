resource "proxmox_virtual_environment_vm" "auth1" {
  vm_id         = 9080
  name          = "auth1"
  description   = "Authentik SSO and MFA identity provider managed by Terraform"
  node_name     = local.vm_node.auth1
  tags          = ["terraform", "ubuntu", "identity", "authentik", "docker"]
  on_boot       = true
  started       = true
  scsi_hardware = "virtio-scsi-single"

  cpu {
    cores = 4
    type  = "x86-64-v2-AES"
  }

  memory {
    dedicated = 8192
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
    size         = 120
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
        address = "10.0.0.36/27"
        gateway = "10.0.0.33"
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
      initialization[0].user_data_file_id,
      initialization[0].user_account[0].keys,
    ]
  }
}
