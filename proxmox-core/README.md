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

## State Backend

State is stored in an S3-compatible backend, not HCP Terraform, to avoid the managed resource billing limit. Cloudflare R2 is the preferred target because it is cheap, S3-compatible, and already fits the Cloudflare side of the homelab.

Create a private R2 bucket:

```bash
export CLOUDFLARE_ACCOUNT_ID="your-cloudflare-account-id"
export CLOUDFLARE_API_TOKEN="token-with-r2-bucket-edit"
./scripts/create-r2-state-bucket.sh
```

Then write the ignored backend config:

```bash
./scripts/write-r2-backend-config.sh
```

Set R2 credentials before `terraform init`:

```bash
export AWS_ACCESS_KEY_ID="your-r2-access-key-id"
export AWS_SECRET_ACCESS_KEY="your-r2-secret-access-key"
terraform init -backend-config=backend.r2.tfbackend
```

To migrate existing local/HCP Terraform state into R2, run:

```bash
terraform init -migrate-state -backend-config=backend.r2.tfbackend
```

The backend enables S3 native lock files with `use_lockfile = true`, so normal CLI runs from the VPS or workstation get state locking without DynamoDB and without HCP Terraform managed-resource billing.

## Required Runner Details

The provider SSH node override must point `hp1` at `10.0.0.162`; otherwise the provider may try the old local-only node address `192.168.13.4`.

For apply runs from the Frankfurt VPS with Docker host networking:

```bash
docker run --rm --network host \
  -e AWS_ACCESS_KEY_ID \
  -e AWS_SECRET_ACCESS_KEY \
  -e PROXMOX_VE_ENDPOINT \
  -e PROXMOX_VE_INSECURE \
  -e PROXMOX_VE_API_TOKEN \
  -e TF_VAR_proxmox_api_token \
  -e TF_VAR_proxmox_ssh_password \
  -v "$PWD:/workspace" \
  -w /workspace \
  hashicorp/terraform:latest init -backend-config=backend.r2.tfbackend

docker run --rm --network host \
  -e AWS_ACCESS_KEY_ID \
  -e AWS_SECRET_ACCESS_KEY \
  -e PROXMOX_VE_ENDPOINT \
  -e PROXMOX_VE_INSECURE \
  -e PROXMOX_VE_API_TOKEN \
  -e TF_VAR_proxmox_api_token \
  -e TF_VAR_proxmox_ssh_password \
  -v "$PWD:/workspace" \
  -w /workspace \
  hashicorp/terraform:latest apply
```

If a repo needs VCS-driven plans/applies, prefer GitHub Actions or another CI runner on the Frankfurt VPS over HCP Terraform VCS workspaces. That keeps state in R2 and avoids counting every Proxmox/Fortigate/Cloudflare object as an HCP Terraform managed resource.

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
