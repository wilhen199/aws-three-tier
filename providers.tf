terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
  # Backend configuration for Terraform state
  backend "s3" {
    bucket       = "aws-3-tier-tfstate-7d8387a1"
    key          = "terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}


