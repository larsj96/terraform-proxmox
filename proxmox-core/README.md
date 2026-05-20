# Proxmox Core Terraform

Minimal first-VM Terraform scaffold for the live homelab.

## Current Intent

- Use the `bpg/proxmox` provider.
- Target `hp1` first.
- Use `nvme-local` for VM disks.
- Use the official Ubuntu Noble cloud image.
- Use a Proxmox snippets cloud-init file for base guest setup.

## What This Creates

- one small Ubuntu VM
- one downloaded Ubuntu cloud image on `local`
- cloud-init user, SSH keys, DHCP networking, and guest agent enablement

## Required Runner Details

State is stored in HCP Terraform/Terraform Cloud workspace `terraform-proxmox-core`.

Set these before `terraform init`:

```bash
export TF_CLOUD_ORGANIZATION="your-tfc-org"
export TF_TOKEN_app_terraform_io="your-user-or-team-token"
```

For local CLI use, Terraform can also store the token in `~/.terraform.d/credentials.tfrc.json`. Do not commit that file.

Run Terraform from the Frankfurt VPS with Docker host networking so the container inherits the working IPsec route/source selection:

```bash
docker run --rm --network host \
  -e TF_CLOUD_ORGANIZATION \
  -e TF_TOKEN_app_terraform_io \
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

If the workspace is VCS-driven in Terraform Cloud, connect only the repo/folder that owns this state. For this repo that means `terraform-proxmox` with working directory `proxmox-core`, using the agent pool that can reach the homelab through the Frankfurt VPS.

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

## Cloud-Init And Guest Agent

Ubuntu Noble cloud images do not reliably boot with `qemu-guest-agent` already installed. Terraform enables the Proxmox guest agent on the VM, so the guest OS must install and start the service during first boot.

This repo now creates a Proxmox snippet named `terraform-noble-base-cloud-config.yaml` on the `snippetsogISO` datastore and attaches it as `user_data_file_id` to all VMs. The snippet:

- installs `qemu-guest-agent`, `net-tools`, `curl`, and `ca-certificates`
- enables and starts `qemu-guest-agent`
- sets timezone to `Europe/Oslo`
- adds both the workstation SSH key and the `ubuntu@bastion01` SSH key

If an already-created VM was booted before this snippet existed, install the agent once from inside the guest:

```bash
sudo apt update
sudo apt install -y qemu-guest-agent
sudo systemctl enable --now qemu-guest-agent
```

## Bastion

`bastion01` is the Linux jump host on the Fortigate bastion VLAN:

```text
VMID: 9010
VLAN: 14
DHCP IP observed: 10.0.0.99
CPU: 4 cores
RAM: 32 GiB
Disk: 200 GiB
```

Future VMs should include both the workstation SSH key and the `ubuntu@bastion01` public key so the bastion can reach them for admin and Ansible workflows.

## Service VMs

`mkdocs` and `docker1` live on the Fortigate k8s/services VLAN:

```text
VLAN: 12
CIDR: 10.0.0.32/27
gateway: 10.0.0.33
```

Current Terraform-managed service VMs:

```text
mkdocs
  VMID: 9020
  CPU: 2 cores
  RAM: 4 GiB
  Disk: 64 GiB
  Purpose: self-hosted documentation

docker1
  VMID: 9030
  CPU: 8 cores
  RAM: 32 GiB
  Disk: 500 GiB
  Purpose: Docker Compose services
```

Both use DHCP and include the workstation and bastion SSH public keys.
