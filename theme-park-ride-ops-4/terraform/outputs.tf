terraform/outputs.tf
output "kubernetes_cluster_endpoint" {
  value = kubernetes_cluster.endpoint
}

output "kubernetes_cluster_name" {
  value = kubernetes_cluster.name
}

output "kubernetes_cluster_version" {
  value = kubernetes_cluster.version
}

output "kubernetes_cluster_certificate_authority_data" {
  value = kubernetes_cluster.kube_config[0].cluster[0].certificate_authority_data
}

output "kubernetes_cluster_token" {
  value = kubernetes_cluster.kube_config[0].user[0].token
}