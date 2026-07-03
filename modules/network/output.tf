output "VPC_ID" {
  value       = aws_vpc.vpc_main.id
  description = "The ID of the VPC"
}

output "Public_Subnet_IDs" {
  value       = aws_subnet.subnet_public_alb[*].id
  description = "The IDs of the public subnets"
}

output "Private_Subnet_Web_IDs" {
  value       = aws_subnet.subnet_private_web[*].id
  description = "The IDs of the private subnets web"
}

output "Private_Subnet_DB_IDs" {
  value       = aws_subnet.subnet_private_db[*].id
  description = "The IDs of the private subnets web"
}
