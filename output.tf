output "alb_dns_name" {
  value       = "http://${module.compute.alb_dns_name}"
  description = "The DNS name of the ALB"
}
