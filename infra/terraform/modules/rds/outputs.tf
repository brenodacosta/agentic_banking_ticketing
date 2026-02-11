output "rds_endpoint" {
  value       = aws_db_instance.this.address
  description = "RDS endpoint address"
}

output "rds_port" {
  value       = aws_db_instance.this.port
  description = "RDS port"
}

output "db_name" {
  value       = var.db_name
  description = "Database name"
}

output "db_username" {
  value       = var.db_username
  description = "Database master username"
}

output "db_password_secret_arn" {
  value       = aws_secretsmanager_secret.db_password.arn
  description = "Secrets Manager ARN for the DB password"
}

output "ai_key_secret_arn" {
  value       = aws_secretsmanager_secret.ai_key.arn
  description = "Secrets Manager ARN for the Gemini API key secret"
}
