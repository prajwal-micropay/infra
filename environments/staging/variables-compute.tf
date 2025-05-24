## Compute
variable "ami_id" {
  description = "ID of the AMI to use for EC2 instances"
  type        = string
  default     = "ami-086a54924e40cab98" # Amazon Linux 2023 AMI for ARM64 in us-east-1
}

variable "instance_type" {
  description = "Instance type for EC2 instances"
  type        = string
  default     = "t4g.micro"
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

variable "application_artifact" {
  description = "Filename of the application artifact"
  type        = string
  default     = "micropaye-app.zip"
} 