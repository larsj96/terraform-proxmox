# Proxmox Benchmark Stack

This stack creates short-lived benchmark VMs, normally one per HP Proxmox node, so disk and CPU tests can be compared before and after storage changes such as Ceph.

Default VMs:

| VM | Node | VMID | CPU | RAM | Disk |
| --- | --- | ---: | ---: | ---: | ---: |
| `bench-hp1` | `hp1` | 9301 | 4 cores | 8 GiB | 100 GiB |
| `bench-hp2` | `hp2` | 9302 | 4 cores | 8 GiB | 100 GiB |
| `bench-hp3` | `hp3` | 9303 | 4 cores | 8 GiB | 100 GiB |

The VMs are disposable. Use Ansible to run the benchmark and collect results, then destroy this stack when done.

```bash
cp backend.r2.tfbackend.example backend.r2.tfbackend
terraform init -backend-config=backend.r2.tfbackend
terraform apply
terraform destroy
```
