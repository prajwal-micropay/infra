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
  value       = module.shared_resources.artifact_bucket_name
}

output "cicd_user_name" {
  description = "Name of the IAM user for CI/CD"
  value       = module.shared_resources.cicd_user_name
}

output "cicd_access_key_id" {
  description = "Access key ID for the CI/CD user"
  value       = module.shared_resources.cicd_access_key_id
  sensitive   = true
} 