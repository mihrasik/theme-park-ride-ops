output "rds_endpoint" {
  value = aws_db_instance.theme_park_rds.endpoint
}

output "rds_port" {
  value = aws_db_instance.theme_park_rds.port
}

output "rds_username" {
  value = aws_db_instance.theme_park_rds.username
}

output "rds_password" {
  value = aws_db_instance.theme_park_rds.password
  sensitive = true
}

output "rds_db_name" {
  value = aws_db_instance.theme_park_rds.db_name
}