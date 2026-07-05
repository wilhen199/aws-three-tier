variable "environment" {
  type        = string
  description = "Environment"
}

variable "project_name" {
  type        = string
  description = "Project Name"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "security_group_ec2_sg" {
  type        = string
  description = "Security Group EC2"
}

variable "db_name" {
  type        = string
  description = "Database name"
}

variable "db_username" {
  type        = string
  description = "Database username"
}

variable "db_instance_class" {
  type        = string
  description = "Database instance class"
  default     = "db.t3.micro"
}

variable "db_storage_type" {
  type        = string
  description = "Storage type"
  default     = "gp2"
}

variable "db_engine" {
  type        = string
  description = "DB Engine"
  default     = "mysql"
}

variable "db_engine_version" {
  type        = string
  description = "DB Engine Version"
  default     = "8.0"
}

variable "allocated_storage" {
  type        = number
  description = "Allocated storage in GB"
  default     = 20
}

variable "private_subnets_db" {
  type        = list(string)
  description = "The IDs of the private subnets db"
}
