output "kubernetes_cluster_name" {
  value = module.kubernetes.cluster_name
}

output "kubernetes_cluster_endpoint" {
  value = module.kubernetes.cluster_endpoint
}

output "kubernetes_cluster_certificate_authority_data" {
  value = module.kubernetes.cluster_certificate_authority_data
}

output "node_instance_ips" {
  value = module.kubernetes.node_instance_ips
}

output "load_balancer_ip" {
  value = module.load_balancer.ip
}