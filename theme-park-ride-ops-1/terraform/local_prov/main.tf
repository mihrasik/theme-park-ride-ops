provider "kubernetes" {
  config_path = "~/.kube/config"
}

resource "kubernetes_namespace" "themepark" {
  metadata {
    name = "themepark"
  }
}

resource "kubernetes_deployment" "app1" {
  metadata {
    name      = "app1"
    namespace = kubernetes_namespace.themepark.metadata[0].name
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = "app1"
      }
    }

    template {
      metadata {
        labels = {
          app = "app1"
        }
      }

      spec {
        container {
          name  = "app1"
          image = "your-dockerhub-username/app1:latest"

          ports {
            container_port = 8080
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "app1" {
  metadata {
    name      = "app1"
    namespace = kubernetes_namespace.themepark.metadata[0].name
  }

  spec {
    selector = {
      app = kubernetes_deployment.app1.metadata[0].labels["app"]
    }

    port {
      port        = 80
      target_port = 8080
    }

    type = "ClusterIP"
  }
}

resource "kubernetes_deployment" "app2" {
  metadata {
    name      = "app2"
    namespace = kubernetes_namespace.themepark.metadata[0].name
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = "app2"
      }
    }

    template {
      metadata {
        labels = {
          app = "app2"
        }
      }

      spec {
        container {
          name  = "app2"
          image = "your-dockerhub-username/app2:latest"

          ports {
            container_port = 8080
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "app2" {
  metadata {
    name      = "app2"
    namespace = kubernetes_namespace.themepark.metadata[0].name
  }

  spec {
    selector = {
      app = kubernetes_deployment.app2.metadata[0].labels["app"]
    }

    port {
      port        = 80
      target_port = 8080
    }

    type = "ClusterIP"
  }
}

resource "kubernetes_deployment" "app3" {
  metadata {
    name      = "app3"
    namespace = kubernetes_namespace.themepark.metadata[0].name
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = "app3"
      }
    }

    template {
      metadata {
        labels = {
          app = "app3"
        }
      }

      spec {
        container {
          name  = "app3"
          image = "your-dockerhub-username/app3:latest"

          ports {
            container_port = 8080
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "app3" {
  metadata {
    name      = "app3"
    namespace = kubernetes_namespace.themepark.metadata[0].name
  }

  spec {
    selector = {
      app = kubernetes_deployment.app3.metadata[0].labels["app"]
    }

    port {
      port        = 80
      target_port = 8080
    }

    type = "ClusterIP"
  }
}

resource "kubernetes_deployment" "mariadb" {
  metadata {
    name      = "mariadb"
    namespace = kubernetes_namespace.themepark.metadata[0].name
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "mariadb"
      }
    }

    template {
      metadata {
        labels = {
          app = "mariadb"
        }
      }

      spec {
        container {
          name  = "mariadb"
          image = "mariadb:latest"

          ports {
            container_port = 3306
          }

          env {
            name  = "MYSQL_ROOT_PASSWORD"
            value = var.db_root_password
          }

          volume_mount {
            mount_path = "/var/lib/mysql"
            name       = "mariadb-storage"
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "mariadb" {
  metadata {
    name      = "mariadb"
    namespace = kubernetes_namespace.themepark.metadata[0].name
  }

  spec {
    selector = {
      app = kubernetes_deployment.mariadb.metadata[0].labels["app"]
    }

    port {
      port        = 3306
      target_port = 3306
    }

    type = "ClusterIP"
  }
}

resource "kubernetes_persistent_volume_claim" "mariadb" {
  metadata {
    name      = "mariadb-storage"
    namespace = kubernetes_namespace.themepark.metadata[0].name
  }

  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests {
        storage = "1Gi"
      }
    }
  }
}