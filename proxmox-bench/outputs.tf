output "benchmark_vms" {
  description = "Temporary benchmark VMs created by this stack."
  value = {
    for name, vm in proxmox_virtual_environment_vm.benchmark : name => {
      vm_id   = vm.vm_id
      node    = vm.node_name
      name    = vm.name
      storage = var.benchmark_vms[name].storage
    }
  }
}
