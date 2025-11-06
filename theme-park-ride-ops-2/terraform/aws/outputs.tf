output "eks_cluster_id" {
  value = aws_eks_cluster.theme_park_ride_ops.id
}

output "eks_cluster_endpoint" {
  value = aws_eks_cluster.theme_park_ride_ops.endpoint
}

output "eks_cluster_security_group_id" {
  value = aws_eks_cluster.theme_park_ride_ops.vpc_config[0].cluster_security_group_id
}

output "rds_instance_endpoint" {
  value = aws_db_instance.theme_park_ride_ops.endpoint
}

output "rds_instance_id" {
  value = aws_db_instance.theme_park_ride_ops.id
}

output "rds_instance_username" {
  value = aws_db_instance.theme_park_ride_ops.username
}