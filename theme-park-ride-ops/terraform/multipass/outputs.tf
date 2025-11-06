output "kubernetes_cluster_name" {
  value = "theme-park-ride-ops-cluster"
}

output "kubernetes_cluster_endpoint" {
  value = module.k8s.endpoint
}

output "kubernetes_cluster_certificate" {
  value = module.k8s.certificate
}

output "kubernetes_cluster_node_ips" {
  value = module.k8s.node_ips
}
###
#   Outputs wie IP-Adresse und DNS Name
#  

output "ip_vm" {
  value       = var.module
  description = "The IP address of the server instance."
}

output "fqdn_vm" {
  value       = format("%s.mshome.net", var.module)
  description = "The FQDN of the server instance."
}

output "description" {
  value = var.description 
  description = "Description VM"
}
