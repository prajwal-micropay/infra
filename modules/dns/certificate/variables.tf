variable "environment" {
  description = "Environment name (e.g., staging, production)"
  type        = string
}

variable "domain_name" {
  description = "Domain name for the application (e.g., api.micropaye.com or api.staging.micropaye.com)"
  type        = string
} 