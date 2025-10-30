resource "helm_release" "nginx" {
  name       = "nginx"
  chart      = "../charts/nginx"
  namespace  = "default"

  values = [
    file("${path.module}/values/nginx-values.yaml")
  ]
}
