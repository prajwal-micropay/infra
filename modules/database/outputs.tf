output "rds_endpoint" {
  description = "Endpoint of the RDS instance"
  value       = aws_db_instance.postgres.address
}

output "rds_port" {
  description = "Port of the RDS instance"
  value       = aws_db_instance.postgres.port
}

output "rds_name" {
  description = "The name of the database"
  value       = aws_db_instance.postgres.db_name
}

output "rds_username" {
  description = "The username for the database"
  value       = aws_db_instance.postgres.username
}

output "secret_arn" {
  description = "ARN of the secret containing RDS credentials"
  value       = aws_secretsmanager_secret.rds_credentials.arn
}

output "secret_name" {
  description = "Name of the secret containing RDS credentials"
  value       = aws_secretsmanager_secret.rds_credentials.name
}

output "security_group_id" {
  description = "ID of the RDS security group"
  value       = local.security_group_id
} 