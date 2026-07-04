
output "db_endpoint" {
  value       = aws_db_instance.rds.endpoint
  description = "Database endpoint"
}

output "db_secret_arn" {
  value       = aws_secretsmanager_secret.db_password.arn
  description = "Vault location on Secret Manager for EC2 can read the password"
}
