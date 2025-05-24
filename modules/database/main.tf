/**
 * Database module
 * Creates an RDS PostgreSQL instance in private subnets
 */

# Security group for RDS
resource "aws_security_group" "rds" {
  count = var.create_security_group ? 1 : 0
  
  name        = "${var.environment}-rds-sg"
  description = "Security group for RDS PostgreSQL instance"
  vpc_id      = var.vpc_id

  # If we're creating our own security group, allow all traffic from the VPC
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.environment}-rds-sg"
    Environment = var.environment
  }
}

# Security group for RDS with EC2 security group reference
resource "aws_security_group" "rds_with_ec2" {
  count = var.create_security_group ? 0 : 1
  
  name        = "${var.environment}-rds-sg"
  description = "Security group for RDS PostgreSQL instance"
  vpc_id      = var.vpc_id

  # Allow inbound access from EC2 instances security group
  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [var.ec2_security_group_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.environment}-rds-sg"
    Environment = var.environment
  }
}

locals {
  security_group_id = var.create_security_group ? aws_security_group.rds[0].id : aws_security_group.rds_with_ec2[0].id
}

# Subnet group for RDS
resource "aws_db_subnet_group" "rds" {
  name       = "${var.environment}-rds-subnet-group"
  subnet_ids = [var.private_subnet_a_id, var.private_subnet_b_id]

  tags = {
    Name        = "${var.environment}-rds-subnet-group"
    Environment = var.environment
  }
}

# Random password for RDS admin
resource "random_password" "rds_password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

# Store password in AWS Secrets Manager
resource "aws_secretsmanager_secret" "rds_credentials" {
  name        = "${var.environment}/rds/credentials"
  description = "RDS credentials for ${var.environment} environment"

  tags = {
    Name        = "${var.environment}-rds-credentials"
    Environment = var.environment
  }
}

resource "aws_secretsmanager_secret_version" "rds_credentials" {
  secret_id = aws_secretsmanager_secret.rds_credentials.id
  secret_string = jsonencode({
    username = var.db_username
    password = random_password.rds_password.result
    host     = aws_db_instance.postgres.address
    port     = 5432
    dbname   = var.db_name
  })
}

# RDS PostgreSQL instance
resource "aws_db_instance" "postgres" {
  identifier             = "${var.environment}-postgres"
  engine                 = "postgres"
  engine_version         = var.db_engine_version
  instance_class         = var.db_instance_class
  allocated_storage      = var.db_allocated_storage
  max_allocated_storage  = var.db_max_allocated_storage
  storage_type           = "gp3"
  db_name                = var.db_name
  username               = var.db_username
  password               = random_password.rds_password.result
  db_subnet_group_name   = aws_db_subnet_group.rds.name
  vpc_security_group_ids = [local.security_group_id]
  skip_final_snapshot    = var.skip_final_snapshot
  parameter_group_name   = aws_db_parameter_group.postgres.name
  backup_retention_period = var.backup_retention_period
  multi_az               = var.multi_az
  publicly_accessible    = false
  copy_tags_to_snapshot  = true
  deletion_protection    = true
  apply_immediately      = true

  tags = {
    Name        = "${var.environment}-postgres"
    Environment = var.environment
  }
}

# DB Parameter Group
resource "aws_db_parameter_group" "postgres" {
  name   = "${var.environment}-postgres-params"
  family = "postgres17"

  parameter {
    name  = "log_connections"
    value = "1"
  }

  parameter {
    name  = "log_disconnections"
    value = "1"
  }

  tags = {
    Name        = "${var.environment}-postgres-params"
    Environment = var.environment
  }
} 