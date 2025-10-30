#!/usr/bin/env bash
set -euxo pipefail

# ---- System update -------------------------------------------------
apt-get update && apt-get upgrade -y

# ---- Docker --------------------------------------------------------
curl -fsSL https://get.docker.com | sh
usermod -aG docker vagrant

# ---- k3s (single-node, embedded etcd) -------------------------------
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="server --disable traefik --write-kubeconfig-mode 644" sh -
mkdir -p /home/vagrant/.kube
cp /etc/rancher/k3s/k3s.yaml /home/vagrant/.kube/config
chown vagrant:vagrant /home/vagrant/.kube/config

# ---- Helm -----------------------------------------------------------
# curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
# chmod 700 get_helm.sh
# ./get_helm.sh

# https://helm.sh/docs/intro/install/ install for ubuntu
sudo apt-get install curl gpg apt-transport-https --yes
curl -fsSL https://packages.buildkite.com/helm-linux/helm-debian/gpgkey | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
echo "deb [signed-by=/usr/share/keyrings/helm.gpg] https://packages.buildkite.com/helm-linux/helm-debian/any/ any main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt-get update
sudo apt-get install helm

helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

# ---- Terraform ------------------------------------------------------
TERRAFORM_VER=1.13.4
apt install unzip -y
wget -q https://releases.hashicorp.com/terraform/${TERRAFORM_VER}/terraform_${TERRAFORM_VER}_linux_$(dpkg --print-architecture).zip
unzip terraform_${TERRAFORM_VER}_linux_*.zip -d /usr/local/bin
# terraform_1.9.8_linux_amd64.zip
rm terraform_${TERRAFORM_VER}_linux_*.zip

# ---- Longhorn (optional, for real PVs) ------------------------------
helm repo add longhorn https://charts.longhorn.io
helm repo update