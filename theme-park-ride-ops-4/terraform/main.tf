terraform/main.tf
provider "kubernetes" {
  host                   = var.k8s_host
  token                  = var.k8s_token
  cluster_ca_certificate = base64decode(var.k8s_ca_certificate)
}

resource "kubernetes_namespace" "themepark" {
  metadata {
    name = var.namespace
  }
}

resource "kubernetes_deployment" "service1" {
  metadata {
    name      = "service1"
    namespace = kubernetes_namespace.themepark.metadata[0].name
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
          ports {
            container_port = 8080
          }
          env {
            name  = "DB_URL"
            value = "jdbc:mysql://${var.db_host}:${var.db_port}/${var.db_name}"
          }
        }
      }
    }
  }
}

resource "kubernetes_deployment" "service2" {
  metadata {
    name      = "service2"
    namespace = kubernetes_namespace.themepark.metadata[0].name
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
          ports {
            container_port = 8080
          }
          env {
            name  = "DB_URL"
            value = "jdbc:mysql://${var.db_host}:${var.db_port}/${var.db_name}"
          }
        }
      }
    }
  }
}

resource "kubernetes_deployment" "service3" {
  metadata {
    name      = "service3"
    namespace = kubernetes_namespace.themepark.metadata[0].name
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
          ports {
            container_port = 8080
          }
          env {
            name  = "DB_URL"
            value = "jdbc:mysql://${var.db_host}:${var.db_port}/${var.db_name}"
          }
        }
      }
    }
  }
}

resource "kubernetes_stateful_set" "mariadb" {
  metadata {
    name      = "mariadb"
    namespace = kubernetes_namespace.themepark.metadata[0].name
  }
  spec {
    service_name = "mariadb"
    replicas     = 1
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
          image = "${var.registry_url}/mariadb:${var.image_tag}"
          ports {
            container_port = 3306
          }
          env {
            name  = "MYSQL_DATABASE"
            value = var.db_name
          }
          env {
            name  = "MYSQL_USER"
            value = var.db_user
          }
          env {
            name  = "MYSQL_PASSWORD"
            value = var.db_pass
          }
        }
      }
    }
  }
}