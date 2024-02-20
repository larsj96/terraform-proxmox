terraform {
  cloud {
    organization = "lanilsen"

    workspaces {
      name = "proxmox_hjemmelabb"
    }
  }
}