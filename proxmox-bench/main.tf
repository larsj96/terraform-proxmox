locals {
  benchmark_nodes = toset(distinct([for vm in values(var.benchmark_vms) : vm.node]))
  ssh_keys        = distinct([var.workstation_ssh_public_key, var.bastion_ssh_public_key])
}

resource "proxmox_virtual_environment_download_file" "ubuntu_noble_cloud_image" {
  for_each = local.benchmark_nodes

  content_type = "iso"
  datastore_id = var.image_storage
  node_name    = each.key
  url          = var.ubuntu_cloud_image_url
}

resource "proxmox_virtual_environment_file" "bench_cloud_config" {
  for_each = local.benchmark_nodes

  content_type = "snippets"
  datastore_id = var.snippets_storage
  node_name    = each.key

  source_raw {
    file_name = "terraform-benchmark-cloud-config-${each.key}.yaml"
    data      = <<-EOF
      #cloud-config
      package_update: true
      packages:
        - qemu-guest-agent
        - curl
        - jq
        - fio
        - sysbench
        - stress-ng
        - iperf3
      timezone: Europe/Oslo
      runcmd:
        - systemctl enable --now qemu-guest-agent
      EOF
  }
}

resource "proxmox_virtual_environment_vm" "benchmark" {
  for_each = var.benchmark_vms

  vm_id         = each.value.vm_id
  name          = each.key
  description   = "Temporary homelab benchmark VM managed by Terraform. Safe to destroy after benchmark collection."
  node_name     = each.value.node
  tags          = ["terraform", "ubuntu", "benchmark", "temporary"]
  on_boot       = false
  started       = true
  scsi_hardware = "virtio-scsi-single"

  cpu {
    cores = each.value.cores
    type  = "x86-64-v2-AES"
  }

  memory {
    dedicated = each.value.memory
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
    file_id      = proxmox_virtual_environment_download_file.ubuntu_noble_cloud_image[each.value.node].id
    interface    = "scsi0"
    size         = each.value.disk_gb
    iothread     = true
    discard      = "on"
  }

  initialization {
    datastore_id      = var.target_storage
    user_data_file_id = proxmox_virtual_environment_file.bench_cloud_config[each.value.node].id

    dns {
      servers = ["1.1.1.1", "8.8.8.8"]
    }

    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }

    user_account {
      username = var.vm_username
      keys     = local.ssh_keys
    }
  }

  lifecycle {
    ignore_changes = [
      disk[0].file_id,
      initialization[0].user_data_file_id,
      initialization[0].user_account[0].keys,
    ]
  }
}
