output "uploads_bucket_name" {
  description = "Name of the S3 bucket for file uploads"
  value       = aws_s3_bucket.uploads.id
}

output "uploads_bucket_arn" {
  description = "ARN of the S3 bucket for file uploads"
  value       = aws_s3_bucket.uploads.arn
}

output "uploads_bucket_domain_name" {
  description = "Domain name of the S3 bucket for file uploads"
  value       = aws_s3_bucket.uploads.bucket_regional_domain_name
} 