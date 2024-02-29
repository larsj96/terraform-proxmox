Project Structure:
Folder
Copy code
│
├── backend.tf              # Configuration for backend on Terraform Cloud
├── main.tf                 # Main Terraform configuration file
├── output.tf               # Configuration for defining output variables
├── providers.tf            # Providers configuration for Proxmox
├── proxmox_virtual_environment_file.tf   # Cloud-init configuration file
├── role.tf                 # Example demonstrating how to create roles in Proxmox
├── ubuntus_vms.tf          # Configuration for setting up Ubuntu cloud images with Proxmox
├── vars.auto.tfvars        # Automatic variables file
└── vars.tf                 # Variable declarations file
Explanation:
ubuntus_vms.tf: This file defines local variables and resources for creating Ubuntu virtual machines on Proxmox.

Local Variables (locals block): Defines a map called ubuntu_vms containing specifications for various Ubuntu virtual machines, each identified by a unique name (e.g., ubuntu-master1, ubuntu-work1). Specifications include the number of CPUs (num_cpus), memory (memory), disk size (disksize), and VLAN (vlan).
Resource proxmox_virtual_environment_vm: This resource is used to define the configuration for each Ubuntu virtual machine. It iterates over the local.ubuntu_vms map using for_each, creating a virtual machine for each entry.
name: Specifies the name of the virtual machine.
description: Description of the virtual machine.
tags: Tags associated with the virtual machine.
node_name: Name of the Proxmox node where the virtual machine will be created.
... (additional blocks explained)
Resource proxmox_virtual_environment_download_file: Downloads the Ubuntu cloud image specified by the URL.

Additional Notes:

Environment variables are utilized to specify credentials for accessing Proxmox from various environments such as local PC or GitLab CI/CD.
This Terraform configuration sets up multiple Ubuntu virtual machines on a Proxmox environment, each with customizable specifications defined in the ubuntus_vms.tf file. The configuration is flexible and can be adjusted based on specific requirements. Make sure to replace placeholder values such as node_name, datastore_id, and bridge with actual values relevant to your Proxmox environment.