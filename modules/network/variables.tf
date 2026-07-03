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

variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR block"
}

##variable "public_subnet_cidrs" {
##  type        = list(string)
##  description = "List of public subnet CIDR blocks"
##}
##
##variable "private_subnet_web_cidrs" {
##  type        = list(string)
##  description = "List of private subnet CIDR blocks"
##}
##
##variable "private_subnet_db_cidrs" {
##  type        = list(string)
##  description = "List of private subnet CIDR blocks for database"
##}
