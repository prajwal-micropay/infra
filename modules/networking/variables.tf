variable "environment" {
  description = "Environment name (e.g., staging, production)"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_a_cidr" {
  description = "CIDR block for the public subnet in AZ A"
  type        = string
  default     = "10.0.1.0/24"
}

variable "public_subnet_b_cidr" {
  description = "CIDR block for the public subnet in AZ B"
  type        = string
  default     = "10.0.2.0/24"
}

variable "private_subnet_a_cidr" {
  description = "CIDR block for the private subnet in AZ A"
  type        = string
  default     = "10.0.3.0/24"
}

variable "private_subnet_b_cidr" {
  description = "CIDR block for the private subnet in AZ B"
  type        = string
  default     = "10.0.4.0/24"
}

variable "availability_zone_a" {
  description = "Availability zone for subnet A"
  type        = string
}

variable "availability_zone_b" {
  description = "Availability zone for subnet B"
  type        = string
} 