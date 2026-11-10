#!/usr/bin/env bash
# kubeforge — Proxmox host prep: load and persist kernel modules needed by k3s/Flannel.
# Run as root on the Proxmox host. Idempotent. Does not change host sysctls
# (forwarding/bridge-nf are per-netns and set inside the privileged container).
set -euo pipefail

MODULES=(overlay br_netfilter ip_vs ip_vs_rr ip_vs_wrr ip_vs_sh nf_conntrack vxlan iptable_nat)
CONF=/etc/modules-load.d/k8s.conf

printf '%s\n' "${MODULES[@]}" >"$CONF"
for m in "${MODULES[@]}"; do
  modprobe "$m"
done

rc=0
for m in "${MODULES[@]}"; do
  if [ -d "/sys/module/${m}" ] || modinfo "$m" 2>/dev/null | grep '^filename:.*(builtin)' >/dev/null; then
    echo "ok      $m"
  else
    echo "MISSING $m"; rc=1
  fi
done
echo "persisted: $CONF"
exit "$rc"
