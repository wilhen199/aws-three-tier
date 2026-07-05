# Subnet group for RDS
resource "aws_db_subnet_group" "rds_subnet_group" {
  name        = "${var.project_name}-rds-subnet-group"
  description = "RDS subnet group"
  subnet_ids  = var.private_subnets_db
  tags = {
    Name        = "${var.project_name}-rds-subnet-group"
    Project     = var.project_name
    Environment = var.environment
  }
}

# RDS Security Group
resource "aws_security_group" "db_sg" {
  name        = "${var.project_name}-db-sg"
  description = "Allows traffic only from EC2 instances to RDS"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Allow traffic from EC2"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [var.security_group_ec2_sg]
  }
  tags = {
    Name        = "${var.project_name}-db-sg"
    Project     = var.project_name
    Environment = var.environment
  }
}

# Random for DB password
resource "random_password" "db_password" {
  length           = 16
  special          = false
  override_special = "!#$%&*-=+?"
}

# Secret Manager to RDS
resource "aws_secretsmanager_secret" "db_password" {
  name_prefix             = "${var.project_name}-db-password"
  description             = "DB Password for ${var.project_name}"
  recovery_window_in_days = 0
  tags = {
    Name        = "${var.project_name}-db-password"
    Project     = var.project_name
    Environment = var.environment
  }
}

# Storage random password into the vault.
resource "aws_secretsmanager_secret_version" "db_password_val" {
  secret_id     = aws_secretsmanager_secret.db_password.id
  secret_string = random_password.db_password.result
}

# RDS Instances
resource "aws_db_instance" "rds" {
  allocated_storage = var.allocated_storage
  storage_type      = var.db_storage_type
  engine            = var.db_engine
  engine_version    = var.db_engine_version
  instance_class    = var.db_instance_class
  db_name           = var.db_name
  username          = var.db_username
  password          = random_password.db_password.result

  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  skip_final_snapshot    = true
  publicly_accessible    = false
  tags = {
    Name        = "${var.project_name}-rds"
    Project     = var.project_name
    Environment = var.environment
  }
}
