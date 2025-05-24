variable "environment" {
  description = "Environment name (staging, production)"
  type        = string
}

variable "uploads_bucket_name" {
  description = "Base name of the S3 bucket for storing chat file uploads"
  type        = string
  default     = "micropaye-uploads"
}

variable "cors_allowed_origins" {
  description = "List of allowed origins for CORS"
  type        = list(string)
  default     = ["*"]
}

variable "expired_object_delete_days" {
  description = "Number of days after which objects should be deleted"
  type        = number
  default     = 365
} 