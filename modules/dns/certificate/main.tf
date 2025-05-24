/**
 * DNS Certificate module
 * Creates SSL certificates for the application
 */

# SSL Certificate for ALB
resource "aws_acm_certificate" "app" {
  domain_name       = var.domain_name
  validation_method = "DNS"

  tags = {
    Name        = "${var.environment}-certificate"
    Environment = var.environment
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Certificate validation (without DNS records)
# This will be validated when records are created
resource "aws_acm_certificate_validation" "app" {
  certificate_arn         = aws_acm_certificate.app.arn
  # Not requiring validation records allows us to break the dependency cycle
  # validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
} 