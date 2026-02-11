resource "random_password" "db" {
  length  = 24
  special = true
}

resource "aws_secretsmanager_secret" "db_password" {
  name = "${var.name}/rds/mysql/password"
}

resource "aws_secretsmanager_secret_version" "db_password" {
  secret_id     = aws_secretsmanager_secret.db_password.id
  secret_string = random_password.db.result
}

resource "aws_db_subnet_group" "this" {
  name       = "${var.name}-db-subnets"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name = "${var.name}-db-subnets"
  }
}

resource "aws_db_instance" "this" {
  identifier = "${var.name}-mysql"

  engine         = "mysql"
  engine_version = "8.0"

  instance_class    = var.instance_class
  allocated_storage = var.allocated_storage

  db_name  = var.db_name
  username = var.db_username
  password = random_password.db.result

  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [var.rds_sg_id]

  publicly_accessible = false
  multi_az            = false
  skip_final_snapshot = true

  backup_retention_period = 0

  tags = {
    Name = "${var.name}-mysql"
  }
}

resource "aws_secretsmanager_secret" "ai_key" {
  name        = "${var.name}/app/AI_AGENTIC_AI_API_KEY"
  description = "Gemini API key for the app. Set the secret value manually; do not store it in Terraform state."
}
