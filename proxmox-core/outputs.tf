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

output "vm_node_placement" {
  value = local.vm_node
}

output "mgmt_dns_records" {
  description = "Management DNS records consumed by firewall DNS stacks."
  value = {
    bastion1 = "10.0.0.102"
    mgmt1    = "10.0.0.100"
    code     = "10.0.0.100"
    runner1  = "10.0.0.101"
    proxmox1 = "10.0.0.162"
    docs     = "10.0.0.35"
    grafana  = "10.0.0.38"
    docker1  = "10.0.0.37"
    auth1    = "10.0.0.36"
    media1   = "10.0.0.39"
  }
}

output "ilo_dns_records" {
  description = "Out-of-band management DNS records consumed by firewall DNS stacks."
  value = {
    hp1   = "10.0.124.164"
    hp2   = "10.0.124.165"
    hp3   = "10.0.124.163"
    dell1 = "10.0.124.162"
  }
}
