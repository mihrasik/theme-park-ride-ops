terraform/outputs.tf
# Outputs for Terraform configuration

output "kubeconfig" {
  value = module.kubernetes.kubeconfig
}

output "cluster_name" {
  value = module.kubernetes.cluster_name
}

output "node_ips" {
  value = module.kubernetes.node_ips
}

output "db_endpoint" {
  value = module.database.endpoint
}

output "app_url" {
  value = "http://${module.app.service_ip}:${var.app_port}"
}