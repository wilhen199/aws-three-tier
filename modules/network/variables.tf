variable "environment" {
  type        = string
  description = "Environment"
}

variable "project_name" {
  type        = string
  description = "Project Name"
}

variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR block"
}

variable "availability_zones" {
  type        = list(string)
  description = "Availability Zones"
}
