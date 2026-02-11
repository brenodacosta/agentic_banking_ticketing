variable "name" {
  type        = string
  description = "Name prefix for ALB resources"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "public_subnet_ids" {
  type        = list(string)
  description = "Public subnet IDs for the ALB"
}

variable "alb_sg_id" {
  type        = string
  description = "Security group ID for the ALB"
}

variable "target_port" {
  type        = number
  description = "Port on the target instances"
  default     = 8000
}

variable "health_check_path" {
  type        = string
  description = "HTTP health check path"
  default     = "/docs"
}
