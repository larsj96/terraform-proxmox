# locals {
#   talos_images = {

#     talos-cp1 = {
#       "num_cpus" = "4"
#       "memory"   = "16192"
#       "disksize" = 100
#       vlan       = "12"
#     }

#     talos-cp2 = {
#       "num_cpus" = "4"
#       "memory"   = "16192"
#       "disksize" = 100
#       vlan       = "12"
#     }

#     talos-cp3 = {
#       "num_cpus" = "4"
#       "memory"   = "16192"
#       "disksize" = 100
#       vlan       = "12"
#     }


#     talos-work1 = {
#       "num_cpus" = "4"
#       "memory"   = "16192"
#       "disksize" = 125
#       vlan       = "12"
#     }

#     talos-work2 = {
#       "num_cpus" = "4"
#       "memory"   = "16192"
#       "disksize" = 125
#       vlan       = "12"
#     }

#     talos-work3 = {
#       "num_cpus" = "4"
#       "memory"   = "16192"
#       "disksize" = 125
#       vlan       = "12"

#     }


#   }
# }

# # variable "config_network_bridge" {
# #     description = "The name of the network bridge on the Proxmox host that will be used for the configuration network."
# #     type = string
# #     default = "vmbr1"
# # }





# resource "proxmox_virtual_environment_vm" "talos_images" {

#   for_each = local.talos_images


#   description = "Managed by Terraform"
#   tags        = ["terraform", "talos"]


#   name = each.key

#   iso         = "local:iso/metal-amd64.iso"
#   target_node = "hp1"
#   vmid        = "${001}${num + 1}"
#   qemu_os     = "l26" # Linux kernel type
#   scsihw      = "virtio-scsi-pci"
#   memory      = each.value.memory
#   cpu         = "kvm64"
#   cores       = each.value.num_cpus
#   sockets     = 1
#   network {
#     model  = "virtio"
#     tag    = each.value.vlan
#     bridge = "vmbr1"
#   }

#   disk {
#     type    = "virtio"
#     size    = each.value.disksize
#     storage = var.boot_disk_storage_pool
#   }

# }