## Database
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
  default     = "db.t4g.micro" # Using t4g instance class for better performance
}

variable "skip_final_snapshot" {
  description = "Whether to skip the final snapshot when destroying the RDS instance"
  type        = bool
  default     = false # For production, always create a final snapshot
}

variable "multi_az" {
  description = "Whether to enable Multi-AZ deployment"
  type        = bool
  default     = true # For production, enable Multi-AZ for high availability
} 