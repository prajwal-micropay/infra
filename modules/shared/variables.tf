variable "artifact_bucket_name" {
  description = "Name of the S3 bucket for storing application artifacts"
  type        = string
  default     = "micropaye-artifacts"
}

variable "cicd_user_name" {
  description = "Name of the IAM user for CI/CD deployments"
  type        = string
  default     = "micropaye-cicd"
} 