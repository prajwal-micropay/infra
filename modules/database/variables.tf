variable "environment" {
  description = "Environment name (e.g., staging, production)"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "private_subnet_a_id" {
  description = "ID of the private subnet in AZ A"
  type        = string
}

variable "private_subnet_b_id" {
  description = "ID of the private subnet in AZ B"
  type        = string
}

variable "ec2_security_group_id" {
  description = "ID of the EC2 security group"
  type        = string
  default     = ""
}

variable "create_security_group" {
  description = "Whether to create a security group for the database"
  type        = bool
  default     = false
}

variable "db_name" {
  description = "Name of the database"
  type        = string
  default     = "micropaye"
}

variable "db_username" {
  description = "Username for the database"
  type        = string
  default     = "micropayeadmin"
}

variable "db_engine_version" {
  description = "Version of the PostgreSQL engine"
  type        = string
  default     = "17.4"
}

variable "db_instance_class" {
  description = "Instance class for the RDS instance"
  type        = string
  default     = "db.t3.micro"
}

variable "db_allocated_storage" {
  description = "Allocated storage for the RDS instance (in GB)"
  type        = number
  default     = 20
}

variable "db_max_allocated_storage" {
  description = "Maximum allocated storage for the RDS instance (in GB)"
  type        = number
  default     = 100
}

variable "skip_final_snapshot" {
  description = "Whether to skip the final snapshot when destroying the RDS instance"
  type        = bool
  default     = false
}

variable "backup_retention_period" {
  description = "Number of days to retain backups"
  type        = number
  default     = 7
}

variable "multi_az" {
  description = "Whether to enable Multi-AZ deployment"
  type        = bool
  default     = false
} 