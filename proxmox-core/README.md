# Proxmox Core Terraform

Minimal first-VM Terraform scaffold for the live homelab.

## Current Intent

- Use the `bpg/proxmox` provider.
- Target `hp1` first.
- Use `nvme-local` for VM disks.
- Use the official Ubuntu Noble cloud image.
- Use built-in cloud-init fields instead of a custom snippet file for now.

## What This Creates

- Ubuntu cloud-image VMs with cloud-init.
- A downloaded Ubuntu Noble cloud image on `local`.
- VM disks and cloud-init disks on `nvme-local`.
- SSH keys injected into the `ubuntu` user.

## Required Runner Details

Run Terraform from the Frankfurt VPS with Docker host networking so the container inherits the working IPsec route/source selection:

```bash
docker run --rm --network host \
  -e PROXMOX_VE_ENDPOINT \
  -e PROXMOX_VE_INSECURE \
  -e PROXMOX_VE_API_TOKEN \
  -e TF_VAR_proxmox_api_token \
  -e TF_VAR_proxmox_ssh_password \
  -e TF_VAR_vm_ssh_public_keys \
  -v "$PWD:/workspace" \
  -w /workspace \
  hashicorp/terraform:latest apply
```

The provider SSH node override must point `hp1` at `10.0.0.162`; otherwise the provider may try the old local-only node address `192.168.13.4`.

The cloud-init initialization datastore must be `nvme-local`; `local` does not support VM image content.

## Deployed VMs

```text
ubuntu-noble-test-01
  VMID: 9001
  VLAN: 110
  Disk: 60 GiB

bastion01
  VMID: 9010
  VLAN: 14
  DHCP IP observed: 10.0.0.99
  CPU: 4 cores
  RAM: 32 GiB
  Disk: 200 GiB

mkdocs
  VMID: 9020
  VLAN: 12
  CPU: 2 cores
  RAM: 4 GiB
  Disk: 64 GiB
  Purpose: self-hosted documentation

docker1
  VMID: 9030
  VLAN: 12
  CPU: 8 cores
  RAM: 32 GiB
  Disk: 500 GiB
  Purpose: Docker Compose services
```

`mkdocs` and `docker1` were observed on VLAN 12 with SSH open on `10.0.0.35` and `10.0.0.37`; confirm exact mapping by SSH hostname or Fortigate DHCP leases.

Future VMs should include both the workstation SSH key and the `ubuntu@bastion01` public key so the bastion can reach them for admin and Ansible workflows.
