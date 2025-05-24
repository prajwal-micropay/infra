output "certificate_arn" {
  description = "ARN of the SSL certificate"
  value       = aws_acm_certificate.app.arn
}

output "domain_name" {
  description = "Domain name for the application"
  value       = var.domain_name
} 