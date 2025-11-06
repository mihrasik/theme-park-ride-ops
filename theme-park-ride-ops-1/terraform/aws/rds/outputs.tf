output "db_instance_endpoint" {
  value = aws_db_instance.theme_park_db.endpoint
}

output "db_instance_port" {
  value = aws_db_instance.theme_park_db.port
}

output "db_instance_identifier" {
  value = aws_db_instance.theme_park_db.id
}

output "db_instance_arn" {
  value = aws_db_instance.theme_park_db.arn
}