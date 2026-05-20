# Proxmox Core Terraform

Minimal first-VM Terraform scaffold for the live homelab.

## Current Intent

- Use the `bpg/proxmox` provider.
- Target `hp1` first.
- Use `nvme-local` for VM disks.
- Use the official Ubuntu Noble cloud image.
- Use built-in cloud-init fields instead of a custom snippet file for now.

## What This Creates

- one small Ubuntu VM
- one downloaded Ubuntu cloud image on `local`
- cloud-init user, SSH key, DHCP networking, and guest agent enablement

## Required Runner Details

Run Terraform from the Frankfurt VPS with Docker host networking so the container inherits the working IPsec route/source selection:

```bash
docker run --rm --network host \
  -e PROXMOX_VE_ENDPOINT \
  -e PROXMOX_VE_INSECURE \
  -e PROXMOX_VE_API_TOKEN \
  -e TF_VAR_proxmox_api_token \
  -e TF_VAR_proxmox_ssh_password \
  -v "$PWD:/workspace" \
  -w /workspace \
  hashicorp/terraform:latest apply
```

The provider SSH node override must point `hp1` at `10.0.0.162`; otherwise the provider may try the old local-only node address `192.168.13.4`.

## Live Test Result

On `2026-05-20`, after the Fortigate IPsec tunnel recovered, this scaffold successfully created and started:

```text
VM ID: 9001
name: ubuntu-noble-test-01
node: hp1
disk: nvme-local, 60 GiB
network: vmbr0, VLAN 110
```

The cloud-init initialization datastore must be `nvme-local`; `local` does not support VM image content.
