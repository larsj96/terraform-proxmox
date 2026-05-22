provider "proxmox" {
  endpoint  = var.proxmox_endpoint
  insecure  = var.proxmox_insecure
  api_token = var.proxmox_api_token

  ssh {
    username = "root"
    password = var.proxmox_ssh_password

    node {
      name    = "hp1"
      address = "10.0.0.162"
    }

    node {
      name    = "hp2"
      address = "10.0.0.163"
    }

    node {
      name    = "hp3"
      address = "10.0.0.164"
    }

    node {
      name    = "dell1"
      address = "10.0.0.165"
    }
  }
}
