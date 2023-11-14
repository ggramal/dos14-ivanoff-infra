
output "rds_username" {
  description = "Username for RDS"
  value       = aws_db_instance.postgres.username
}

output "rds_password" {
  description = "Password for RDS"
  value       = random_password.password.result
  sensitive   = true
}
