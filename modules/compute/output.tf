output "alb_dns_name" {
  value       = aws_lb.web-lb.dns_name
  description = "The DNS name of the ALB"
}
