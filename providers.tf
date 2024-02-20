terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.46.5"
    }
  }
}

provider "proxmox" {
  # endpoint = var.pm_api_url
  insecure = var.pm_tls_insecure
  tmp_dir  = var.tmp_dir

  endpoint = "https://192.168.13.8:8006/"

  ssh {
    agent    = true
    username = "root"
  }
}
