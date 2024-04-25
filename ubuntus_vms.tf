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

     gitlabrunner1 = {
      "num_cpus" = "4"
      "memory"   = "32192"
      "disksize" = 100
      vlan       = "14"
    }

      sftp1 = {
      "num_cpus" = "4"
      "memory"   = "32192"
      "disksize" = 100
      vlan       = "18"
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
      initialization,
        disk[0].file_id, // Specify the index of the disk if there are multiple disks
        node_name # ignore if we migrate VMS to another proxmox node
   ]
 }



}

resource "proxmox_virtual_environment_download_file" "latest_ubuntu_22_jammy_qcow2_img" {
  content_type = "iso"
  datastore_id = "snippetsogISO"
  node_name    = "hp1"
  url          = "https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img"
}

