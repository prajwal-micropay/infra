output "certificate_arn" {
  description = "ARN of the SSL certificate"
  value       = aws_acm_certificate.app.arn
}

output "domain_validation_options" {
  description = "Domain validation options for the certificate"
  value       = aws_acm_certificate.app.domain_validation_options
} 