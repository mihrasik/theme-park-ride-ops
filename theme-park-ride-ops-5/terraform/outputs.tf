# terraform/outputs.tf
output "kubernetes_cluster_name" {
  value = "themepark-cluster"
}

output "kubernetes_cluster_endpoint" {
  value = module.k3s.cluster_endpoint
}

output "kubernetes_cluster_certificate" {
  value = module.k3s.cluster_certificate
}

output "mariadb_service_ip" {
  value = kubernetes_service.mariadb.status[0].load_balancer[0].ingress[0].ip
}

output "traefik_service_ip" {
  value = kubernetes_service.traefik.status[0].load_balancer[0].ingress[0].ip
}

output "argo_cd_url" {
  value = "http://${kubernetes_service.argocd_server.status[0].load_balancer[0].ingress[0].ip}:80"
}