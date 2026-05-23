locals {
  vm_node_defaults = {
    ubuntu_test = var.target_node_name
    bastion01   = var.target_node_name
    mkdocs      = var.target_node_name
    docker1     = var.target_node_name
    monitoring1 = var.target_node_name
    media1      = var.target_node_name
    auth1       = var.target_node_name
    certbot1    = var.target_node_name
    mgmt1       = var.target_node_name
    runner1     = var.target_node_name
  }

  vm_node_explicit = merge(local.vm_node_defaults, var.vm_node_placement)

  vm_node_balanced = {
    for idx, name in sort(keys(local.vm_node_defaults)) :
    name => var.placement_nodes[idx % length(var.placement_nodes)]
  }

  vm_node = var.vm_placement_mode == "balanced" ? local.vm_node_balanced : local.vm_node_explicit
}

locals {
  active_vm_nodes = toset(values(local.vm_node))
}
