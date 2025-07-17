## DNS
variable "domain_name" {
  description = "Domain name for the application"
  type        = string
  default     = "api.trymicro.io"
}

variable "hosted_zone_id" {
  description = "ID of the Route53 hosted zone"
  type        = string
  default     = "Z07102503JPUWVPOSTMD"
} 