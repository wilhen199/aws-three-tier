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

# Enable versioning on the bucket
resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.backend_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Block public access to the bucket
resource "aws_s3_bucket_public_access_block" "backend_bucket" {
  bucket = aws_s3_bucket.backend_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
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

