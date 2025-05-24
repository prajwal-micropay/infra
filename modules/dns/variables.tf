variable "environment" {
  description = "Environment name (e.g., staging, production)"
  type        = string
}

variable "domain_name" {
  description = "Domain name for the application (e.g., api.micropaye.com or api.staging.micropaye.com)"
  type        = string
}

variable "hosted_zone_id" {
  description = "ID of the Route53 hosted zone"
  type        = string
}

variable "alb_dns_name" {
  description = "DNS name of the ALB"
  type        = string
}

variable "alb_zone_id" {
  description = "Zone ID of the ALB"
  type        = string
} 