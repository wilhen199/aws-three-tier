output "vpc_id" {
  value       = aws_vpc.vpc_main.id
  description = "The ID of the VPC"
}

output "public_subnets" {
  value       = aws_subnet.subnet_public_alb[*].id
  description = "The IDs of the public subnets"
}

output "private_subnets_web" {
  value       = aws_subnet.subnet_private_web[*].id
  description = "The IDs of the private subnets web"
}

output "private_subnets_db" {
  value       = aws_subnet.subnet_private_db[*].id
  description = "The IDs of the private subnets db"
}
