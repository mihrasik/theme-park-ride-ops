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
          image = "your-docker-repo/app1:latest"

          ports {
            container_port = 8080
          }
        }
      }
    }
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
          image = "your-docker-repo/app2:latest"

          ports {
            container_port = 8080
          }
        }
      }
    }
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
          image = "your-docker-repo/app3:latest"

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
      app = kubernetes_deployment.app1.metadata[0].labels.app
    }

    port {
      port        = 80
      target_port = 8080
    }

    type = "LoadBalancer"
  }
}

resource "kubernetes_service" "app2" {
  metadata {
    name      = "app2"
    namespace = kubernetes_namespace.themepark.metadata[0].name
  }

  spec {
    selector = {
      app = kubernetes_deployment.app2.metadata[0].labels.app
    }

    port {
      port        = 80
      target_port = 8080
    }

    type = "LoadBalancer"
  }
}

resource "kubernetes_service" "app3" {
  metadata {
    name      = "app3"
    namespace = kubernetes_namespace.themepark.metadata[0].name
  }

  spec {
    selector = {
      app = kubernetes_deployment.app3.metadata[0].labels.app
    }

    port {
      port        = 80
      target_port = 8080
    }

    type = "LoadBalancer"
  }
}