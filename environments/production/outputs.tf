output "vpc_id" {
  description = "ID of the VPC"
  value       = module.networking.vpc_id
}

output "alb_dns_name" {
  description = "DNS name of the ALB"
  value       = module.compute.alb_dns_name
}

output "rds_endpoint" {
  description = "Endpoint of the RDS instance"
  value       = module.database.rds_endpoint
}

output "artifact_bucket_name" {
  description = "Name of the S3 bucket for artifacts"
  value       = data.aws_s3_bucket.artifacts.id
}

output "cicd_user_name" {
  description = "Name of the IAM user for CI/CD"
  value       = data.aws_iam_user.cicd.user_name
}

output "cicd_access_key_id" {
  description = "Access key ID for the CI/CD user"
  value       = data.aws_iam_user.cicd.arn
  sensitive   = true
} 