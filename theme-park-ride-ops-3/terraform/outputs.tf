terraform/outputs.tf
output "kubernetes_cluster_name" {
  value = "themepark-cluster"
}

output "kubernetes_cluster_endpoint" {
  value = kubernetes_cluster.endpoint
}

output "kubernetes_cluster_certificate" {
  value = kubernetes_cluster.kube_config[0].cluster[0].certificate_authority_data
}

output "kubernetes_admin_token" {
  value = kubernetes_cluster.kube_config[0].user[0].token
}

output "mariadb_service_ip" {
  value = kubernetes_service.mariadb[0].cluster_ip
}

output "traefik_service_ip" {
  value = kubernetes_service.traefik[0].cluster_ip
}