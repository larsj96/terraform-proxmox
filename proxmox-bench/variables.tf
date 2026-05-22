variable "proxmox_endpoint" {
  description = "Proxmox API endpoint, including https:// and port 8006."
  type        = string
  default     = "https://10.0.0.162:8006/"
}

variable "proxmox_api_token" {
  description = "Proxmox API token in the form user@realm!tokenid=secret."
  type        = string
  sensitive   = true
}

variable "proxmox_insecure" {
  description = "Skip TLS verification for the Proxmox API."
  type        = bool
  default     = true
}

variable "proxmox_ssh_password" {
  description = "Temporary Proxmox root SSH password for provider node operations."
  type        = string
  sensitive   = true
}

variable "image_storage" {
  description = "Storage ID used to download the Ubuntu cloud image."
  type        = string
  default     = "local"
}

variable "snippets_storage" {
  description = "Storage ID that supports Proxmox snippets for custom cloud-init user-data."
  type        = string
  default     = "local"
}

variable "ubuntu_cloud_image_file_id" {
  description = "Default existing Ubuntu cloud image file ID available on each target node."
  type        = string
  default     = "local:iso/ubuntu-24.04-server-cloudimg-amd64.img"
}

variable "vm_bridge" {
  description = "Bridge used for benchmark VM NICs."
  type        = string
  default     = "vmbr0"
}

variable "vm_vlan_id" {
  description = "VLAN tag for benchmark VM NICs."
  type        = number
  default     = 12
}

variable "vm_username" {
  description = "Cloud-init username."
  type        = string
  default     = "ubuntu"
}

variable "workstation_ssh_public_key" {
  description = "Primary workstation SSH public key."
  type        = string
  default     = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL6rilckgv40NViw/SrFwiGMbWeaxc/pT6yE8GGoOcKS ljn@WORKSTATION"
}

variable "bastion_ssh_public_key" {
  description = "SSH public key generated on bastion01."
  type        = string
  default     = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDA6/AtLMyDq7wIPTD8vh0Rf5KBWd0pk22CK8Zn6vWlO ubuntu@bastion01"
}

variable "benchmark_vms" {
  description = "Temporary benchmark VMs, normally one per node/local NVMe storage target."
  type = map(object({
    vm_id         = number
    node          = string
    storage       = string
    cores         = number
    memory        = number
    disk_gb       = number
    image_file_id = optional(string)
  }))
  default = {
    bench-hp1 = {
      vm_id   = 9301
      node    = "hp1"
      storage = "nvme-local"
      cores   = 4
      memory  = 8192
      disk_gb = 100
    }
    bench-hp2 = {
      vm_id   = 9302
      node    = "hp2"
      storage = "nvme-local"
      cores   = 4
      memory  = 8192
      disk_gb = 100
    }
    bench-hp3 = {
      vm_id   = 9303
      node    = "hp3"
      storage = "nvme-local"
      cores   = 4
      memory  = 8192
      disk_gb = 100
    }
    bench-dell1 = {
      vm_id   = 9304
      node    = "dell1"
      storage = "nvme-dell"
      cores   = 4
      memory  = 8192
      disk_gb = 100
    }
  }
}
