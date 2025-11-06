###
#   Ressourcen
#

resource "null_resource" "multipass" {
  triggers = {
    name = var.module
  }

  # terraform apply
  provisioner "local-exec" {
    command = "multipass launch --name ${var.module} -c${var.cores} -m${var.memory}GB -d${var.storage}GB --cloud-init ${var.userdata}"
    on_failure = continue    
  }
  provisioner "local-exec" {
    command = "multipass set client.primary-name=${var.module}"
    on_failure = continue
  }

  # terraform destroy - ohne wird VM physikalisch nicht geloescht
  provisioner "local-exec" {
    when    = destroy
    command = "multipass set client.primary-name=primary"

    on_failure = continue
  }  
  provisioner "local-exec" {
    when    = destroy
    command = "multipass delete ${self.triggers.name} --purge"
    on_failure = continue
  }
}

module "multipass" {
  source  = "mc-b/multipass/lerncloud"
  version = "1.0.1"

  key       = "<your_api_key>"
  url       = "<your_api_url>"
  vpn       = "<optional_vpn>"

  cores     = 2
  description = "Kubernetes Control Plane"
  memory    = 4
  module      = "k8s-control-plane"
  ports     = [22, 80]
  storage   = 20
  userdata  = "cloud-init.yaml"
}

module "multipass_worker" {
  count = 3

  source  = "mc-b/multipass/lerncloud"
  version = "1.0.1"

  key       = "<your_api_key>"
  url       = "<your_api_url>"
  vpn       = "<optional_vpn>"

  cores     = 2
  description = "Kubernetes Worker Node ${count.index}"
  memory    = 4
  module      = "k8s-worker-${count.index}"
  ports     = [22, 80]
  storage   = 20
  userdata  = "cloud-init.yaml"
}

output "control_plane_ip" {
  value = module.multipass.ip_vm
}

output "worker_ips" {
  value = [for worker in module.multipass_worker : worker.ip_vm]
}