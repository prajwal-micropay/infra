## DNS
variable "domain_name" {
  description = "Domain name for the application"
  type        = string
  default     = "api.micropaye.com"
}

variable "hosted_zone_id" {
  description = "ID of the Route53 hosted zone"
  type        = string
  default     = "Z09778141S629D558GPDF"
} 