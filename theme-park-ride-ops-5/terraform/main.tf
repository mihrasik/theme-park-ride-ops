# terraform/main.tf

provider "kubernetes" {
  config_path = "~/.kube/config"
}

resource "kubernetes_namespace" "themepark" {
  metadata {
    name = var.themepark_namespace
  }
}

resource "kubernetes_deployment" "ride_ops" {
  metadata {
    name      = "ride-ops"
    namespace = kubernetes_namespace.themepark.metadata[0].name
  }

  spec {
    replicas = 3

    selector {
      match_labels = {
        app = "ride-ops"
      }
    }

    template {
      metadata {
        labels = {
          app = "ride-ops"
        }
      }

      spec {
        container {
          name  = "ride-ops"
          image = "${var.registry_url}/ride-ops:${var.image_tag}"

          ports {
            container_port = 8080
          }

          env {
            name  = "DB_HOST"
            value = var.db_host
          }

          env {
            name  = "DB_PORT"
            value = var.db_port
          }

          env {
            name  = "DB_NAME"
            value = var.db_name
          }

          env {
            name  = "DB_USER"
            value = var.db_user
          }

          env {
            name  = "DB_PASS"
            value = var.db_pass
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "ride_ops" {
  metadata {
    name      = "ride-ops"
    namespace = kubernetes_namespace.themepark.metadata[0].name
  }

  spec {
    selector = {
      app = "ride-ops"
    }

    port {
      port        = 80
      target_port = 8080
    }
  }
}