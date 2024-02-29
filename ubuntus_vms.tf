locals {
  ubuntu_vms = {

    ubuntu-master1 = {
      "num_cpus" = "4"
      "memory"   = "16192"
      "disksize" = 100
      vlan       = "12"
    }

    ubuntu-master2 = {
      "num_cpus" = "4"
      "memory"   = "16192"
      "disksize" = 100
      vlan       = "12"
    }

    ubuntu-master3 = {
      "num_cpus" = "4"
      "memory"   = "16192"
      "disksize" = 100
      vlan       = "12"
    }


    ubuntu-work1 = {
      "num_cpus" = "4"
      "memory"   = "16192"
      "disksize" = 125
      vlan       = "12"
    }

    ubuntu-work2 = {
      "num_cpus" = "4"
      "memory"   = "16192"
      "disksize" = 125
      vlan       = "12"
    }

    ubuntu-work3 = {
      "num_cpus" = "4"
      "memory"   = "16192"
      "disksize" = 125
      vlan       = "12"

    }

  }
}






resource "proxmox_virtual_environment_vm" "ubuntu_vms" {

  for_each = local.ubuntu_vms


  name        = each.key
  description = "Managed by Terraform"
  tags        = ["terraform", "ubuntu"]

  node_name = "hp1"



 memory {
  dedicated = each.value.memory
 }

 cpu {
  cores = each.value.num_cpus
 }



  agent {
    # read 'Qemu guest agent' section, change to true only when ready ( this is been added to  cloud init - see proxmox_virtual_environment_file.tf )
    enabled = true
  }

  startup {
    order      = "3"
    up_delay   = "60"
    down_delay = "60"
  }

  disk {
    datastore_id = "nvme"
    file_id      = proxmox_virtual_environment_download_file.latest_ubuntu_22_jammy_qcow2_img.id
    interface    = "scsi0"
    size = each.value.disksize
  }

  initialization {
    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }

    user_account {
      keys     = [trimspace(tls_private_key.ubuntu_vm_key.public_key_openssh)]
      password = random_password.ubuntu_vm_password.result
      username = "ubuntu"
    }

    # user_data_file_id = proxmox_virtual_environment_file.cloud_config.id
    # user_data_file_id = base64encode(file("cloud-init/user-data.yml"))
    user_data_file_id = proxmox_virtual_environment_file.cloud_config.id

  }

  network_device {
    bridge  = "vmbr1"
    vlan_id = each.value.vlan
  }

  operating_system {
    type = "l26"
  }

  tpm_state {
    version = "v2.0"
  }

  serial_device {}

 lifecycle { 
   ignore_changes = [
      # Ignore changes to tags, e.g. because a management agent
      # updates these based on some ruleset managed elsewhere.
      initialization,
   ]
 }


}

resource "proxmox_virtual_environment_download_file" "latest_ubuntu_22_jammy_qcow2_img" {
  content_type = "iso"
  datastore_id = "snippetsogISO"
  node_name    = "hp1"
  url          = "https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img"
}

resource "random_password" "ubuntu_vm_password" {
  length           = 16
  override_special = "_%@"
  special          = true
}

resource "tls_private_key" "ubuntu_vm_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

output "ubuntu_vm_password" {
  value     = random_password.ubuntu_vm_password.result
  sensitive = true
}

output "ubuntu_vm_private_key" {
  value     = tls_private_key.ubuntu_vm_key.private_key_pem
  sensitive = true
}

output "ubuntu_vm_public_key" {
  value = tls_private_key.ubuntu_vm_key.public_key_openssh
}