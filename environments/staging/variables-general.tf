## General settings
variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

## Shared resources
variable "artifact_bucket_name" {
  description = "Name of the S3 bucket to store artifacts"
  type        = string
  default     = "micropaye-artifacts"
}

variable "cicd_user_name" {
  description = "Name of the IAM user for CI/CD"
  type        = string
  default     = "micropaye-cicd"
}

variable "uploads_bucket_name" {
  description = "Base name of the S3 bucket for chat file uploads"
  type        = string
  default     = "micropaye-uploads"
} 