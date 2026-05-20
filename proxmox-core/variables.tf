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
  description = "Temporary Proxmox root SSH password for provider node operations. Prefer replacing with key auth later."
  type        = string
  sensitive   = true
}

variable "proxmox_ssh_node_address" {
  description = "Routed management address the provider should use for SSH to the target node."
  type        = string
  default     = "10.0.0.162"
}

variable "target_node_name" {
  description = "First node to target for the initial test VM."
  type        = string
  default     = "hp1"
}

variable "target_storage" {
  description = "Storage ID for VM disks."
  type        = string
  default     = "nvme-local"
}

variable "image_storage" {
  description = "Storage ID used to download the Ubuntu cloud image."
  type        = string
  default     = "local"
}

variable "snippets_storage" {
  description = "Storage ID that supports Proxmox snippets for custom cloud-init user-data."
  type        = string
  default     = "snippetsogISO"
}

variable "pool_name" {
  description = "Optional Proxmox pool for Terraform-managed workloads."
  type        = string
  default     = "homelab"
}

variable "vm_id" {
  description = "VMID for the first test VM."
  type        = number
  default     = 9001
}

variable "vm_name" {
  description = "Name of the first test VM."
  type        = string
  default     = "ubuntu-noble-test-01"
}

variable "vm_description" {
  description = "Description shown in Proxmox."
  type        = string
  default     = "Managed by Terraform"
}

variable "vm_tags" {
  description = "Tags applied to the VM."
  type        = list(string)
  default     = ["terraform", "ubuntu", "test"]
}

variable "vm_cpu_cores" {
  description = "CPU cores for the first test VM."
  type        = number
  default     = 2
}

variable "vm_memory_mb" {
  description = "Memory for the first test VM in MiB."
  type        = number
  default     = 4096
}

variable "vm_disk_size_gb" {
  description = "Primary disk size in GiB."
  type        = number
  default     = 60
}

variable "vm_bridge" {
  description = "Bridge used for the guest NIC."
  type        = string
  default     = "vmbr0"
}

variable "vm_vlan_id" {
  description = "Optional VLAN tag for the guest NIC."
  type        = number
  default     = 110
}

variable "vm_ipv4_address" {
  description = "IPv4 address for cloud-init. Use dhcp or CIDR like 10.0.0.170/27."
  type        = string
  default     = "dhcp"
}

variable "vm_ipv4_gateway" {
  description = "IPv4 gateway when using a static IPv4 address."
  type        = string
  default     = "10.0.0.161"
}

variable "vm_dns_servers" {
  description = "DNS servers for cloud-init."
  type        = list(string)
  default     = ["1.1.1.1", "8.8.8.8"]
}

variable "vm_username" {
  description = "Cloud-init username."
  type        = string
  default     = "ubuntu"
}

variable "vm_ssh_public_keys" {
  description = "SSH public keys for the cloud-init user."
  type        = list(string)
  default     = []
}

variable "workstation_ssh_public_key" {
  description = "Primary workstation SSH public key for the bastion VM."
  type        = string
  default     = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL6rilckgv40NViw/SrFwiGMbWeaxc/pT6yE8GGoOcKS ljn@WORKSTATION"
}

variable "bastion_ssh_public_key" {
  description = "SSH public key generated on bastion01 for access to future VMs."
  type        = string
  default     = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKEPk8EwvWaugg+Cmj3JBgHzTJEj4nM2BNdPSu/0LRuw ubuntu@bastion01"
}

variable "ubuntu_cloud_image_url" {
  description = "Ubuntu cloud image URL."
  type        = string
  default     = "https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img"
}
