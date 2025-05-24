output "artifact_bucket_name" {
  description = "Name of the S3 bucket for artifacts"
  value       = aws_s3_bucket.artifacts.id
}

output "artifact_bucket_arn" {
  description = "ARN of the S3 bucket for artifacts"
  value       = aws_s3_bucket.artifacts.arn
}

output "cicd_user_name" {
  description = "Name of the IAM user for CI/CD"
  value       = aws_iam_user.cicd.name
}

output "cicd_user_arn" {
  description = "ARN of the IAM user for CI/CD"
  value       = aws_iam_user.cicd.arn
}

output "cicd_access_key_id" {
  description = "Access key ID for the CI/CD user"
  value       = aws_iam_access_key.cicd.id
  sensitive   = true
}

output "cicd_secret_access_key" {
  description = "Secret access key for the CI/CD user"
  value       = aws_iam_access_key.cicd.secret
  sensitive   = true
} 