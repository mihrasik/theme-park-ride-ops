#!/usr/bin/env bash
set -eux

curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--docker" sh -s - --write-kubeconfig-mode 644

mkdir -p /etc/rancher/k3s
cat <<EOF >/etc/rancher/k3s/registries.yaml
mirrors:
  "192.168.56.10:5000":
    endpoint:
      - "http://192.168.56.10:5000"
EOF

systemctl restart k3s
