variable "environment" {
  type        = string
  description = "Environment"
}

variable "project_name" {
  type        = string
  description = "Project Name"
}

variable "aws_region" {
  type        = string
  description = "AWS Region"
  default     = "us-east-1"
}
