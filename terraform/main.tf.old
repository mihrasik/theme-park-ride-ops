# terraform/main.tf

terraform {
  required_version = ">= 1.5"
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.23"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.12"
    }
  }
}

# Kubernetes Provider – uses kubeconfig
provider "kubernetes" {
  config_path = "~/.kube/config"
}

# Helm Provider – NEW SYNTAX (no block!)
provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

# -------------------------------------------------
# 1. Load local Docker images into k3s
# -------------------------------------------------
resource "null_resource" "load_images" {
  triggers = {
    app     = filesha256("../docker-images/app.tar")
    mariadb = filesha256("../docker-images/mariadb.tar")
    lb      = filesha256("../docker-images/lb.tar")
  }

  provisioner "local-exec" {
    command = <<EOT
      sudo k3s ctr images import /vagrant/docker-images/app.tar
      sudo k3s ctr images import /vagrant/docker-images/mariadb.tar
      sudo k3s ctr images import /vagrant/docker-images/lb.tar
    EOT
  }
}

# -------------------------------------------------
# 2. Nginx Ingress
# -------------------------------------------------
resource "helm_release" "ingress" {
  name       = "nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  namespace  = "ingress"
  create_namespace = true

  set {
    name  = "controller.service.type"
    value = "NodePort"
  }
  set {
    name  = "controller.service.nodePorts.http"
    value = "30080"
  }
}

# -------------------------------------------------
# 3. Your Helm chart (uses local images)
# -------------------------------------------------
resource "helm_release" "dataops" {
  depends_on = [null_resource.load_images, helm_release.ingress]

  name       = "dataops"
  chart      = "../charts/dataops"
  namespace  = "prod"
  create_namespace = true

  timeout = 600

  set {
    name  = "image.repository"
    value = "local/app"
  }
  set {
    name  = "image.tag"
    value = "latest"
  }
  set {
    name  = "image.pullPolicy"
    value = "Never"
  }

  # MariaDB
  set {
    name  = "mariadb.image.repository"
    value = "local/mariadb"
  }
  set {
    name  = "mariadb.image.tag"
    value = "latest"
  }
  set {
    name  = "mariadb.image.pullPolicy"
    value = "Never"
  }

  # LB (optional – you can keep it as a Deployment)
  set {
    name  = "lb.enabled"
    value = "true"
  }
  set {
    name  = "lb.image.repository"
    value = "local/nginx-lb"
  }
  set {
    name  = "lb.image.tag"
    value = "latest"
  }
  set {
    name  = "lb.image.pullPolicy"
    value = "Never"
  }
}