/**
 * Staging Environment Configuration
 */

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.0.0"
}

provider "aws" {
  region  = var.region
  profile = "micropaye"
}

# Reference to shared resources (S3 artifact bucket & IAM CI/CD user)
module "shared_resources" {
  source = "../../modules/shared"

  artifact_bucket_name = var.artifact_bucket_name
  cicd_user_name       = var.cicd_user_name
}

# Storage - S3 buckets for file uploads
module "uploads_storage" {
  source = "../../modules/storage/uploads"

  environment = "staging"
  uploads_bucket_name = var.uploads_bucket_name
  cors_allowed_origins = ["https://${var.domain_name}", "https://staging.micropaye.com"]
}

# Networking
module "networking" {
  source = "../../modules/networking"

  environment           = "staging"
  vpc_cidr              = var.vpc_cidr
  public_subnet_a_cidr  = var.public_subnet_a_cidr
  public_subnet_b_cidr  = var.public_subnet_b_cidr
  private_subnet_a_cidr = var.private_subnet_a_cidr
  private_subnet_b_cidr = var.private_subnet_b_cidr
  availability_zone_a   = var.availability_zone_a
  availability_zone_b   = var.availability_zone_b
}

# First create the certificate
module "certificate" {
  source = "../../modules/dns/certificate"

  environment = "staging"
  domain_name = var.domain_name
}

# Database (RDS) - Create before compute so we have the secret ARN
module "database" {
  source = "../../modules/database"

  environment          = "staging"
  vpc_id               = module.networking.vpc_id
  private_subnet_a_id  = module.networking.private_subnet_a_id
  private_subnet_b_id  = module.networking.private_subnet_b_id
  # Remove dependency on compute's security group
  create_security_group = true  # New variable to create its own security group
  db_name              = var.db_name
  db_username          = var.db_username
  db_instance_class    = var.db_instance_class
  skip_final_snapshot  = var.skip_final_snapshot
  multi_az             = var.multi_az
}

# Compute resources (EC2, ALB, ASG)
module "compute" {
  source = "../../modules/compute"

  environment           = "staging"
  region                = var.region
  vpc_id                = module.networking.vpc_id
  public_subnet_ids     = [module.networking.public_subnet_a_id, module.networking.public_subnet_b_id]
  private_subnet_ids    = [module.networking.private_subnet_a_id, module.networking.private_subnet_b_id]
  ami_id                = var.ami_id
  instance_type         = var.instance_type
  min_instances         = var.min_instances
  max_instances         = var.max_instances
  desired_instances     = var.desired_instances
  health_check_path     = var.health_check_path
  health_check_port     = var.health_check_port
  artifact_bucket_name  = module.shared_resources.artifact_bucket_name
  artifact_bucket_arn   = module.shared_resources.artifact_bucket_arn
  application_artifact  = var.application_artifact
  certificate_arn       = module.certificate.certificate_arn
  db_secret_arn         = module.database.secret_arn
  db_security_group_id  = module.database.security_group_id
  uploads_bucket_name   = module.uploads_storage.uploads_bucket_name
  uploads_bucket_arn    = module.uploads_storage.uploads_bucket_arn
}

# DNS record creation - this depends on the compute module for ALB info
module "dns_records" {
  source = "../../modules/dns/records"

  environment     = "staging"
  domain_name     = var.domain_name
  hosted_zone_id  = var.hosted_zone_id
  certificate_arn = module.certificate.certificate_arn
  domain_validation_options = module.certificate.domain_validation_options
  alb_dns_name    = module.compute.alb_dns_name
  alb_zone_id     = module.compute.alb_zone_id

  depends_on = [module.compute, module.certificate]
} 