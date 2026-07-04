terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
  # Backend configuration for Terraform state
  backend "s3" {
    bucket       = "aws-3-tier-tfstate-a9157f2c"
    key          = "terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.aws_region
}


