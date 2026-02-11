variable "name" {
  type        = string
  description = "Name prefix"
}

variable "aws_region" {
  type        = string
  description = "AWS region"
}

variable "subnet_ids" {
  type        = list(string)
  description = "Subnets for the AutoScaling Group"
}

variable "ec2_sg_id" {
  type        = string
  description = "Security group ID for the EC2 instances"
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

variable "min_size" {
  type        = number
  description = "Minimum ASG size"
  default     = 1
}

variable "max_size" {
  type        = number
  description = "Maximum ASG size"
  default     = 2
}

variable "target_group_arns" {
  type        = list(string)
  description = "Target group ARNs to attach to the ASG"
  default     = []
}

variable "artifact_bucket_name" {
  type        = string
  description = "S3 bucket name used for CodePipeline/CodeDeploy artifacts (EC2 instances need read access)"
}

variable "db_password_secret_arn" {
  type        = string
  description = "Secrets Manager ARN for the DB password"
}

variable "ai_key_secret_arn" {
  type        = string
  description = "Secrets Manager ARN for the Gemini API key secret"
}
