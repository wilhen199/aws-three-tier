# Random suffix for the backend bucket name to avoid conflicts
resource "random_id" "backend_suffix" {
  byte_length = 4
}

# Create a bucket with a random suffix for the backend
resource "aws_s3_bucket" "backend_bucket" {
  bucket = "${var.project_name}-tfstate-${random_id.backend_suffix.hex}"

  lifecycle {
    prevent_destroy = false
  }

  tags = {
    Name        = "${var.project_name}-tfstate"
    Environment = var.environment
    Project     = var.project_name
  }
}

# Create a DynamoDB table for state locking
resource "aws_dynamodb_table" "backend_lock_table" {
  name         = "${var.project_name}-tfstate-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name        = "${var.project_name}-tfstate-lock"
    Environment = var.environment
    Project     = var.project_name
  }
}

output "backend_bucket_name" {
  value = aws_s3_bucket.backend_bucket.bucket
}

