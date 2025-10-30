#!/usr/bin/env bash
set -eux

docker run -d -p 5000:5000 --restart=always --name registry registry:2

mkdir -p /etc/docker
cat <<EOF >/etc/docker/daemon.json
{
  "insecure-registries" : ["192.168.56.10:5000"]
}
EOF

systemctl restart docker
