# Proxmox Benchmark Stack

This stack creates short-lived benchmark VMs, normally one per node/local NVMe storage target, so disk and CPU tests can be compared before and after storage changes such as Ceph.

Default VMs:

| VM | Node | Storage | VMID | CPU | RAM | Disk |
| --- | --- | --- | ---: | ---: | ---: | ---: |
| `bench-hp1` | `hp1` | `nvme-local` | 9301 | 4 cores | 8 GiB | 100 GiB |
| `bench-hp2` | `hp2` | `nvme-local` | 9302 | 4 cores | 8 GiB | 100 GiB |
| `bench-hp3` | `hp3` | `nvme-local` | 9303 | 4 cores | 8 GiB | 100 GiB |
| `bench-dell1` | `dell1` | `nvme-dell` | 9304 | 4 cores | 8 GiB | 100 GiB |

The default map deploys the HP targets. Dell is kept in `benchmark-vms-with-dell.tfvars.example` because the Dell node is not currently a healthy member of the HP cluster API. Enable it when Dell is rejoined or managed by a dedicated standalone stack.

The VMs are disposable. Use Ansible to run the benchmark and collect results, then destroy this stack when done.

Prerequisite: `local:iso/ubuntu-24.04-server-cloudimg-amd64.img` must exist on each target node. The benchmark stack intentionally does not manage the image file so repeated temporary runs do not fight existing Proxmox ISO files.

Storage notes:

- `nvme-local` is a cluster storage ID backed by each HP node's local NVMe LVM-thin pool. A VM on `hp1` uses hp1 local NVMe, a VM on `hp2` uses hp2 local NVMe, and a VM on `hp3` uses hp3 local NVMe.
- `nvme-dell` is the Dell node's local NVMe-backed storage. Keep Dell results separate from HP results because the server is not considered reliable for future cluster design decisions.

```bash
cp backend.r2.tfbackend.example backend.r2.tfbackend
terraform init -backend-config=backend.r2.tfbackend
terraform apply
terraform destroy
```
