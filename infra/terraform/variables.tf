variable "aws_region" {
  type        = string
  description = "AWS region"
  default     = "us-east-1"
}

variable "project_name" {
  type        = string
  description = "Name prefix for resources (legacy; used by some modules)"
  default     = "agentic-banking-ticketing"
}

variable "name" {
  type        = string
  description = "Name prefix for resources"
  default     = "agentic-banking-ticketing"
}

variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR"
  default     = "10.0.0.0/16"
}

variable "sandbox_mode" {
  type        = bool
  description = "When true, biases toward sandbox-friendly infra choices (e.g., no NAT, app instances in public subnets)."
  default     = true
}

variable "app_port" {
  type        = number
  description = "Port the app container listens on"
  default     = 8000
}

variable "alb_ingress_cidrs" {
  type        = list(string)
  description = "CIDR blocks allowed to reach the ALB listener"
  default     = ["0.0.0.0/0"]
}

variable "alb_health_check_path" {
  type        = string
  description = "ALB health check path"
  default     = "/docs"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type"
  default     = "t3.micro"
}

variable "desired_capacity" {
  type        = number
  description = "Desired ASG capacity"
  default     = 1
}

variable "asg_min_size" {
  type        = number
  description = "Minimum ASG size"
  default     = 1
}

variable "asg_max_size" {
  type        = number
  description = "Maximum ASG size"
  default     = 2
}

variable "db_name" {
  type        = string
  description = "RDS database name"
  default     = "genai"
}

variable "db_username" {
  type        = string
  description = "RDS master username"
  default     = "app"
}

variable "db_instance_class" {
  type        = string
  description = "RDS instance class"
  default     = "db.t3.micro"
}

variable "db_allocated_storage" {
  type        = number
  description = "RDS allocated storage (GiB)"
  default     = 20
}

variable "artifacts_force_destroy" {
  type        = bool
  description = "Whether to allow destroying the artifact bucket even if it contains objects"
  default     = false
}

variable "pipeline_source_object_key" {
  type        = string
  description = "S3 object key (within the artifact bucket) for the CodeDeploy bundle zip"
  default     = "app.zip"
}
