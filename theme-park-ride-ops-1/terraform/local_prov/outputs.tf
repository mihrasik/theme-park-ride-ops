output "kubernetes_cluster_name" {
  value = module.kubernetes.cluster_name
}

output "kubernetes_cluster_endpoint" {
  value = module.kubernetes.cluster_endpoint
}

output "kubernetes_cluster_certificate" {
  value = module.kubernetes.cluster_certificate
}

output "kubernetes_node_ips" {
  value = module.kubernetes.node_ips
}

output "mariadb_endpoint" {
  value = module.database.endpoint
}

output "mariadb_username" {
  value = module.database.username
}

output "mariadb_password" {
  value = module.database.password
  sensitive = true
}