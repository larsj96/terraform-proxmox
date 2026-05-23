# Proxmox Benchmark Stack

This stack creates short-lived benchmark VMs, normally one per node/local NVMe storage target, so disk and CPU tests can be compared before and after storage changes such as Ceph.

Default VMs:

| VM | Node | Storage | VMID | CPU | RAM | Disk |
| --- | --- | --- | ---: | ---: | ---: | ---: |
| `bench-hp1` | `hp1` | `nvme-local` | 9301 | 4 cores | 8 GiB | 100 GiB |
| `bench-hp2` | `hp2` | `nvme-local` | 9302 | 4 cores | 8 GiB | 100 GiB |
| `bench-hp3` | `hp3` | `nvme-local` | 9303 | 4 cores | 8 GiB | 100 GiB |
| `bench-hp3-sas` | `hp3` | `sas-hp3` | 9304 | 4 cores | 8 GiB | 100 GiB |
| `bench-dell1` | `dell1` | `nvme-dell` | 9305 | 4 cores | 8 GiB | 100 GiB |

The default map deploys the HP targets. Dell is kept in `benchmark-vms-with-dell.tfvars.example` because the Dell node is not currently a healthy member of the HP cluster API. Enable it when Dell is rejoined or managed by a dedicated standalone stack.

The VMs are disposable. Use Ansible to run the benchmark and collect results, then destroy this stack when done.

Prerequisite: `nvme-files:iso/noble-server-cloudimg-amd64.img` must exist on each HP target node. `nvme-files` is a small ext4 filesystem on each node's local NVMe VG, mounted at `/mnt/pve/nvme-files`, and registered as a Proxmox directory storage for `iso`, `snippets`, `import`, and `vztmpl` content. Do not use `local:iso` for benchmark sources on the HP nodes because `local` lives under `/var/lib/vz` on the Proxmox boot device, and these servers currently boot from USB.

Storage notes:

- `nvme-local` is a cluster storage ID backed by each HP node's local NVMe LVM-thin pool. A VM on `hp1` uses hp1 local NVMe, a VM on `hp2` uses hp2 local NVMe, and a VM on `hp3` uses hp3 local NVMe.
- `nvme-files` is file storage on local NVMe for cloud images and snippets only. It keeps benchmark image imports away from USB-backed `local`.
- `sas-hp3` is a local hp3 LVM-thin pool backed by the 4.9 TB SAS logical volume.
- `nvme-dell` is the Dell node's local NVMe-backed storage. Keep Dell results separate from HP results because the server is not considered reliable for future cluster design decisions.

Run SAS comparison separately from the HP NVMe baseline. SAS VM creation/import is expected to be much slower than NVMe because the VM disk lands on the SAS LVM-thin pool; keep that provisioning-time signal separate from the inside-guest `fio` storage result.

```bash
cp backend.r2.tfbackend.example backend.r2.tfbackend
terraform init -backend-config=backend.r2.tfbackend
terraform apply
terraform destroy
```
