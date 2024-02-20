# output "ubuntu_vm_password" {
#   value     = random_password.ubuntu_vm_password.result
#   sensitive = true
# }

# output "ubuntu_vm_private_key" {
#   value     = tls_private_key.ubuntu_vm_key.private_key_pem
#   sensitive = true
# }

# output "ubuntu_vm_public_key" {
#   value = tls_private_key.ubuntu_vm_key.public_key_openssh
# }

# locals {
#   vm_info = {
#     value = {
#       name = values(proxmox_virtual_environment_vm.vm)[*].name,
#       vmid = values(proxmox_virtual_environment_vm.vm)[*].id,
#       # ip_addr = values(proxmox_virtual_environment_vm.vm)[*].default_ipv4_address,
#       # cores   = values(proxmox_virtual_environment_vm.vm)[*].cpu.cores,
#       # memory  = values(proxmox_virtual_environment_vm.vm)[*].memory.dedicated,
#       # vlan = values(proxmox_vm_qemu.vm)[*].network
#     }
#   }
# }

# output "vminfo" {
#   value = {
#     for vm in proxmox_virtual_environment_vm.vm : vm.name => {
#       vmid        = vm.id
#       cpus        = vm.cpu[0].sockets * vm.cpu[0].cores
#       ip_address  = vm.ipv4_addresses[1][0]
#       mem         = vm.memory[0].dedicated
#       vlan        = vm.network_device[0].vlan_id
#       mac_address = vm.mac_addresses[1]
#       disk        = vm.disk[0].size
#       description = vm.description
#       nic_name    = vm.network_interface_names[1]
#       #ip_address  = vm.ip_address
#     }
#   }
# }
