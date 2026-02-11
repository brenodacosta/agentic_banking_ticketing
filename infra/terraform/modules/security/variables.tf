variable "name" {
  type        = string
  description = "Name prefix for security group resources"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "app_port" {
  type        = number
  description = "App container port exposed on the EC2 instances"
  default     = 8000
}

variable "alb_ingress_cidrs" {
  type        = list(string)
  description = "CIDR blocks allowed to reach the ALB listener"
  default     = ["0.0.0.0/0"]
}
