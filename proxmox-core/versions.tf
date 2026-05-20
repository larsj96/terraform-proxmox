terraform {
  required_version = ">= 1.10.0"

  backend "s3" {}

  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0.46.5"
    }
  }
}
