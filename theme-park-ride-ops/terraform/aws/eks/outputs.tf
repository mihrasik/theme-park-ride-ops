output "cluster_name" {
  value = aws_eks_cluster.theme_park_ride_ops.name
}

output "cluster_endpoint" {
  value = aws_eks_cluster.theme_park_ride_ops.endpoint
}

output "cluster_security_group_id" {
  value = aws_eks_cluster.theme_park_ride_ops.vpc_config[0].cluster_security_group_id
}

output "cluster_certificate_authority_data" {
  value = aws_eks_cluster.theme_park_ride_ops.certificate_authority[0].data
}

output "node_group_role_arn" {
  value = aws_iam_role.node_group_role.arn
}

output "node_group_id" {
  value = aws_eks_node_group.theme_park_ride_ops_node_group.id
}

output "node_group_subnet_ids" {
  value = aws_eks_node_group.theme_park_ride_ops_node_group.subnet_ids
}