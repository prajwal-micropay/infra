variable "environment" {
  description = "Environment name (e.g., staging, production)"
  type        = string
}

variable "domain_name" {
  description = "Domain name for the application (e.g., api.trymicro.io or api.staging.trymicro.io)"
  type        = string
} 