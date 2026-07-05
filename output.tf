output "alb_dns_name" {
  value       = "http://${module.compute.alb_dns_name}"
  description = "The DNS name of the ALB"
}

output "db_endpoint" {
  value       = module.database.db_endpoint
  description = "Database endpoint"
}

output "db_secret_arn" {
  value       = module.database.db_secret_arn
  description = "ARN del secreto de la BD en Secrets Manager"
}
