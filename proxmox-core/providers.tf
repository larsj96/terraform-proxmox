provider "proxmox" {
  endpoint = var.proxmox_endpoint
  insecure = var.proxmox_insecure

  api_token = var.proxmox_api_token

  ssh {
    username = "root"
    password = var.proxmox_ssh_password

    node {
      name    = var.target_node_name
      address = var.proxmox_ssh_node_address
    }
  }
}
