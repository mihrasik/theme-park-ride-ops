terraform/main.tf
provider "kubernetes" {
  config_path = "~/.kube/config"
}

resource "kubernetes_namespace" "themepark" {
  metadata {
    name = var.namespace
  }
}

resource "kubernetes_secret" "db_credentials" {
  metadata {
    name      = "db-credentials"
    namespace = var.namespace
  }

  data = {
    DB_USER = base64encode(var.db_user)
    DB_PASS = base64encode(var.db_pass)
  }
}

resource "kubernetes_deployment" "service1" {
  metadata {
    name      = "service1"
    namespace = var.namespace
  }

  spec {
    replicas = 3

    selector {
      match_labels = {
        app = "service1"
      }
    }

    template {
      metadata {
        labels = {
          app = "service1"
        }
      }

      spec {
        container {
          name  = "service1"
          image = "${var.registry_url}/service1:${var.image_tag}"

          env {
            name  = "DB_URL"
            value = "mysql://${kubernetes_secret.db_credentials.data.DB_USER}:${kubernetes_secret.db_credentials.data.DB_PASS}@mariadb:${var.db_port}/${var.db_name}"
          }
        }
      }
    }
  }
}

resource "kubernetes_deployment" "service2" {
  metadata {
    name      = "service2"
    namespace = var.namespace
  }

  spec {
    replicas = 3

    selector {
      match_labels = {
        app = "service2"
      }
    }

    template {
      metadata {
        labels = {
          app = "service2"
        }
      }

      spec {
        container {
          name  = "service2"
          image = "${var.registry_url}/service2:${var.image_tag}"

          env {
            name  = "DB_URL"
            value = "mysql://${kubernetes_secret.db_credentials.data.DB_USER}:${kubernetes_secret.db_credentials.data.DB_PASS}@mariadb:${var.db_port}/${var.db_name}"
          }
        }
      }
    }
  }
}

resource "kubernetes_deployment" "service3" {
  metadata {
    name      = "service3"
    namespace = var.namespace
  }

  spec {
    replicas = 3

    selector {
      match_labels = {
        app = "service3"
      }
    }

    template {
      metadata {
        labels = {
          app = "service3"
        }
      }

      spec {
        container {
          name  = "service3"
          image = "${var.registry_url}/service3:${var.image_tag}"

          env {
            name  = "DB_URL"
            value = "mysql://${kubernetes_secret.db_credentials.data.DB_USER}:${kubernetes_secret.db_credentials.data.DB_PASS}@mariadb:${var.db_port}/${var.db_name}"
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "mariadb" {
  metadata {
    name      = "mariadb"
    namespace = var.namespace
  }

  spec {
    selector = {
      app = "mariadb"
    }

    port {
      port     = var.db_port
      target_port = var.db_port
    }
  }
}