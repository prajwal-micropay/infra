/**
 * Production Environment Configuration
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

# Data sources to reference shared resources from staging
data "aws_s3_bucket" "artifacts" {
  bucket = var.artifact_bucket_name
}

data "aws_iam_user" "cicd" {
  user_name = var.cicd_user_name
}

# Storage - S3 buckets for file uploads
module "uploads_storage" {
  source = "../../modules/storage/uploads"

  environment = "production"
  uploads_bucket_name = var.uploads_bucket_name
  cors_allowed_origins = ["https://${var.domain_name}", "https://web.micropaye.com"]
}

# Certificate for HTTPS
module "certificate" {
  source = "../../modules/dns/certificate"

  environment = "production"
  domain_name = var.domain_name
} 