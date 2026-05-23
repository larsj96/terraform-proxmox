# Proxmox Core Terraform

Minimal first-VM Terraform scaffold for the live homelab.

## Current Intent

- Use the `bpg/proxmox` provider.
- Target `hp1` first.
- Use `nvme-local` for VM disks.
- Use a pinned official Ubuntu Noble cloud image.
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

The current `ubuntu@bastion01` public key is stored in `var.bastion_ssh_public_key`. When `bastion01` is rebuilt and a new key is generated, update that variable first, then add the new public key to existing VMs with Ansible or SSH. Existing VM lifecycle blocks intentionally ignore cloud-init snippet/key drift so a key rotation does not accidentally replace running VMs.

New VMs still receive the current cloud-init key set at creation time. Existing VMs are treated as live machines after first boot; use Ansible for key rotation and service configuration.

The Ubuntu cloud image URL is pinned in `var.ubuntu_cloud_image_url` instead of using `/current/`. Update the pinned release deliberately when you want a new base image, then plan carefully before applying.

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

## Proxmox Metrics

`monitoring1` already collects Proxmox metrics with Telegraf's Proxmox API input. That is the active monitoring path today and writes into the `homelab` InfluxDB bucket.

Newer `bpg/proxmox` provider releases have a native metric server resource, but the provider version currently pinned by this stack does not support it yet. Keep the checked-in example for the later provider upgrade/test pass:

```hcl
metrics.tf.example
```

After the provider is upgraded deliberately, copy the example to `metrics.tf`, pass the token at runtime, and enable the flag:

```bash
export TF_VAR_enable_proxmox_native_metrics=true
export TF_VAR_proxmox_metrics_influx_token="influx-token-with-write-access"
terraform plan
terraform apply
```

Target defaults:

```text
server: 10.0.0.38
port: 8086
protocol: http
organization: lanilsen
bucket: homelab
```

Keep the InfluxDB token out of Git. Until then, Telegraf's Proxmox API collector is the working implementation.

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

monitoring1
  VMID: 9040
  CPU: 8 cores
  RAM: 32 GiB
  Disk: 500 GiB
  Purpose: central monitoring stack

media1
  VMID: 9050
  CPU: 8 cores
  RAM: 32 GiB
  Disk: 250 GiB
  Purpose: Docker Compose media automation and first Plex host

auth1
  VMID: 9080
  Static IP: 10.0.0.36/27
  CPU: 4 cores
  RAM: 8 GiB
  Disk: 120 GiB
  Purpose: Authentik SSO/MFA identity provider

certbot1
  VMID: 9060
  VLAN: 14 / bastion
  CPU: 2 cores
  RAM: 2 GiB
  Disk: 32 GiB
  Purpose: optional certificate automation host for Palo Alto GlobalProtect

mgmt1
  VMID: 9070
  VLAN: 14 / bastion
  Static IP: 10.0.0.100/27
  CPU: 8 cores
  RAM: 32 GiB
  Disk: 250 GiB
  Purpose: browser-accessible Linux management workbench

runner1
  VMID: 9071
  VLAN: 14 / bastion
  Static IP: 10.0.0.101/27
  CPU: 4 cores
  RAM: 16 GiB
  Disk: 120 GiB
  Purpose: inside automation runner for future CI/Codex-style jobs
```

These service VMs use DHCP and include the workstation and bastion SSH public keys.

`media1` intentionally keeps the media library out of its Terraform-managed boot disk. The first iteration runs the VM on the shared service VLAN and expects Ansible to mount HP2 SAS-backed media storage later, likely by NFS, once that filesystem/export is confirmed.

`certbot1` is intentionally placed on the bastion VLAN instead of the services VLAN. It needs outbound internet for Let's Encrypt and Cloudflare DNS-01 plus routed reachability to the Palo Alto management interface. The companion certificate automation lives in the Palo repo under `tools/letsencrypt-paloalto`.

For now, `create_certbot1` defaults to `false`. The Frankfurt VPS is the cleaner first certificate automation host because it already has the Palo IPsec path. Enable this VM later when routing from the Proxmox/Fortigate site to the Palo management subnet is confirmed.

`mgmt1` is intended to be exposed through Cloudflare Access at `mgmt.lanilsen.com` and configured by Ansible as a Linux browser/workbench host. It is placed on the bastion VLAN because it is an admin foothold, not a public application VM.

`runner1` is intentionally smaller and does not expose a web UI by default. Use it later for GitHub Actions runners, scheduled jobs, or other inside-the-network automation that should keep running when the workstation is off.

## Windows Templates

Windows image builds should be handled by Packer rather than hand-built Proxmox templates. A scaffold lives under `packer/windows/` for:

- Windows 11 Pro
- Windows Server LTSC, currently best treated as Windows Server 2025 evaluation unless legitimate Windows Server 2026 media is available

The scaffold expects user-supplied Windows and VirtIO ISOs on Proxmox ISO storage and does not contain license keys. See `packer/windows/README.md`.

## VM Placement

The live stack still defaults to `hp1` for safety. VM nodes now flow through a conservative map in `vm-placement.tf`:

- `vm_placement_mode = "explicit"` uses `vm_node_placement` overrides.
- `vm_placement_mode = "balanced"` rotates VMs across `placement_nodes` deterministically.

Current defaults keep everything on `hp1` until migrations are planned:

```hcl
vm_placement_mode  = "explicit"
placement_nodes    = ["hp1", "hp2", "hp3"]
vm_node_placement = {
  # mkdocs  = "hp2"
  # docker1 = "hp3"
}
```

See `vm-placement.md` for full rollout guidance and the artifact preconditions for moving workloads off `hp1`.
