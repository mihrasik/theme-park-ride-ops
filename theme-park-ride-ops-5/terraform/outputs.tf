# terraform/outputs.tf
output "kubernetes_cluster_name" {
  value = "themepark-cluster"
}

output "themepark_namespace" {
  value = kubernetes_namespace.themepark.metadata[0].name
}

output "ride_ops_service_name" {
  value = kubernetes_service.ride_ops.metadata[0].name
}