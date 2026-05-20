terraform {
  required_version = ">= 1.6.0"

  cloud {
    workspaces {
      name = "terraform-proxmox-core"
    }
  }

  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0.46.5"
    }
  }
}
