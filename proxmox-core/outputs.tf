output "test_vm_name" {
  value = proxmox_virtual_environment_vm.ubuntu_test.name
}

output "test_vm_id" {
  value = proxmox_virtual_environment_vm.ubuntu_test.vm_id
}

output "target_node_name" {
  value = proxmox_virtual_environment_vm.ubuntu_test.node_name
}

output "target_storage" {
  value = var.target_storage
}
