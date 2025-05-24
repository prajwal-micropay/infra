variable "environment" {
  description = "Environment name (e.g., staging, production)"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "public_subnet_ids" {
  description = "IDs of the public subnets for the ALB"
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "IDs of the private subnets for the EC2 instances"
  type        = list(string)
}

variable "ami_id" {
  description = "ID of the AMI to use for EC2 instances"
  type        = string
  default     = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

variable "instance_type" {
  description = "Instance type for EC2 instances"
  type        = string
  default     = "t2.micro"
}

variable "min_instances" {
  description = "Minimum number of instances in the ASG"
  type        = number
  default     = 1
}

variable "max_instances" {
  description = "Maximum number of instances in the ASG"
  type        = number
  default     = 2
}

variable "desired_instances" {
  description = "Desired number of instances in the ASG"
  type        = number
  default     = 1
}

variable "health_check_path" {
  description = "Path for health check"
  type        = string
  default     = "/ping"
}

variable "health_check_port" {
  description = "Port for health check"
  type        = number
  default     = 80
}

variable "artifact_bucket_name" {
  description = "Name of the S3 bucket for artifacts"
  type        = string
}

variable "artifact_bucket_arn" {
  description = "ARN of the S3 bucket for artifacts"
  type        = string
}

variable "application_artifact" {
  description = "Filename of the application artifact"
  type        = string
  default     = "micropaye-app.zip"
}

variable "certificate_arn" {
  description = "ARN of the SSL certificate"
  type        = string
}

variable "db_secret_arn" {
  description = "ARN of the secret containing DB credentials"
  type        = string
}

variable "db_security_group_id" {
  description = "ID of the RDS security group"
  type        = string
  default     = ""
}

variable "uploads_bucket_name" {
  description = "Name of the S3 bucket for file uploads"
  type        = string
}

variable "uploads_bucket_arn" {
  description = "ARN of the S3 bucket for file uploads"
  type        = string
} 