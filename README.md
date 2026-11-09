# Proxmox LXC — Prebaked Kubernetes (k3s) Node

> **Status:** planning / prompt phase. No container has been built yet. Project name and final scope are being finalized before implementation.

## What this project is

A reproducible build specification for a **Proxmox LXC template** that arrives with everything a k3s node needs already installed and image-cached, so cloning a working control-plane or worker node takes seconds and works offline.

Target hypervisor: **Proxmox VE** (single node or cluster). Base OS: **Ubuntu 24.04 LTS**. Distribution: **k3s** (lightweight Kubernetes, Flannel CNI included). LXC mode: **privileged** with nesting enabled.

## Why LXC instead of VMs

- Sub-second boot and near-bare-metal performance (shared host kernel).
- Far smaller disk footprint than full VMs.
- Clone-from-template workflow via `pct`.
- Trade-off: reduced isolation from the Proxmox host and reliance on the host kernel/modules.

## v1 done criteria (agent-verifiably)

1. A prebaked LXC template exists on the Proxmox host.
2. A full clone boots, runs `k3s --version`, and has the air-gapped image cache present.
3. A disposable control-plane clone + worker clone form a real k3s cluster and run a smoke workload.

User hand-verifies only UI/UX items (node placement, resource sliders, etc.).

## Prebake implications (short)

"Prebaked" means OS updates, kernel fixes, k3s binary, and the k3s air-gapped image archive are baked in and available offline. It does **not** mean the cluster identity (server vs. agent, join token, IP, node name) is baked in — those must be per-node and cannot live in a shared read-only template for security reasons. A clone therefore needs a handful of post-clone configuration lines before it can join a cluster.

Template size grows to roughly 2–4 GB and full clones are independent disks of roughly 4–6 GB each. k3s version upgrades require rebuilding the template.

## Planned structure

```
docs/00-project-prompt.md   # full build prompt (this project)
docs/01-prerequisites.md     # (planned)
docs/02-proxmox-lxc-config.md # (planned)
docs/03-prebake-build.md     # (planned)
docs/04-clone-and-join.md    # (planned)
docs/05-verification.md      # (planned)
scripts/                    # build/join scripts (planned)
manifests/                  # smoke workloads (planned)
```

## Build system assumptions

- Proxmox VE 9.x, root shell access via SSH.
- `pct` CLI for container creation/cloning.
- Storage: `local` (templates) and `local-lvm` (rootfs).
- No paid cloud or external secrets manager in v1; join tokens are generated on the first control-plane node and injected per node out-of-band.

## License

TBD (recommend MIT for a resume portfolio repository).

## Name

Project name: **kubeforge** (finalized).