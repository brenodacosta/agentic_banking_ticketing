variable "name" {
  type        = string
  description = "Name prefix"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "Private subnet IDs for the DB subnet group"
}

variable "rds_sg_id" {
  type        = string
  description = "Security group ID for the RDS instance"
}

variable "db_name" {
  type        = string
  description = "Database name"
  default     = "genai"
}

variable "db_username" {
  type        = string
  description = "Database master username"
  default     = "app"
}

variable "instance_class" {
  type        = string
  description = "RDS instance class"
  default     = "db.t3.micro"
}

variable "allocated_storage" {
  type        = number
  description = "Allocated storage (GiB)"
  default     = 20
}
