output "alb_dns_name" {
  value       = aws_lb.web-lb.dns_name
  description = "The DNS name of the ALB"
}

output "security_group_ec2_sg" {
  value       = aws_security_group.ec2_sg.id
  description = "The ID of the security group"
}
