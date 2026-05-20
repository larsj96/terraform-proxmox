locals {
  default_ssh_public_keys = distinct(compact(concat(
    var.vm_ssh_public_keys,
    [
      var.workstation_ssh_public_key,
      var.bastion_ssh_public_key,
    ],
  )))

  noble_base_cloud_config = {
    package_update = true

    packages = [
      "qemu-guest-agent",
      "net-tools",
      "curl",
      "ca-certificates",
    ]

    users = [
      "default",
      {
        name                = var.vm_username
        groups              = ["sudo"]
        shell               = "/bin/bash"
        sudo                = "ALL=(ALL) NOPASSWD:ALL"
        ssh_authorized_keys = local.default_ssh_public_keys
      },
    ]

    timezone = "Europe/Oslo"

    runcmd = [
      "systemctl enable --now qemu-guest-agent",
      "echo done > /tmp/terraform-cloud-init.done",
    ]
  }
}

resource "proxmox_virtual_environment_file" "noble_base_cloud_config" {
  content_type = "snippets"
  datastore_id = var.snippets_storage
  node_name    = var.target_node_name

  source_raw {
    data      = "#cloud-config\n${yamlencode(local.noble_base_cloud_config)}"
    file_name = "terraform-noble-base-cloud-config.yaml"
  }
}
