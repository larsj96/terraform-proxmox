variable "ssh_key" {
  description = "SSH public key for authorized access"
  type        = string
  default     = "" # Provide your default SSH key here if needed
}

variable "vm_datastore" {
  description = "Datastore used for VMs/lxc/whatnot"
  type        = string
  default     = "local"
}

variable "tmp_dir" {
  description = "Temporary directory for downloading cloud img file from URL"
  type        = string
  default     = "/tmp"
}

variable "local_datastore" {
  description = "Default datastore in Proxmox"
  type        = string
  default     = "local"
}

variable "proxmox_host" {
  description = "Proxmox host"
  type        = string
  default     = "hp1"
}

variable "pm_api_url" {
  description = "Proxmox API URL"
  type        = string
  default     = "192.168.13.8:8006"
}

variable "description" {
  description = "Description for VM"
  type        = string
  default     = "Managed by Terraform"
}


variable "pm_tls_insecure" {
  default = true
}

# variable "template_name" {
#   description = "Default template name"
#   type        = string
#   default     = "ubuntu-2204-efi"
# }

variable "pve_vm_bios" {
  description = "PVE bios (OVMF/SeaBios)"
  type        = string
  default     = "ovmf"
}

variable "pve_vm_machine" {
  description = "PVE machine type (q35/x440)"
  type        = string
  default     = "q35"
}

variable "tablet_device" {
  description = "Use tablet for pointer"
  type        = bool
  default     = false
}



variable "onboot" {
  description = "Set VMs to start on boot"
  type        = bool
  default     = false
}

variable "disk_size" {
  description = "Default disk size in GB"
  type        = string
  default     = "50G"
}

variable "memory" {
  description = "Default memory size in MB"
  type        = number
  default     = 8192
}

variable "selected_vm_instance" {
  description = "The name of the Proxmox VM instance to use for the output"
  type        = string
  default     = "harbor" # Set the name of the desired VM instance
}




#########################


