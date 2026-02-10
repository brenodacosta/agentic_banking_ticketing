variable "aws_region" {
  type        = string
  description = "AWS region for the EKS cluster"
  default     = "us-east-1"
}

variable "project_name" {
  type        = string
  description = "Name prefix for resources"
  default     = "genai-platform"
}

variable "cluster_name" {
  type        = string
  description = "EKS cluster name"
  default     = "genai-eks"
}

variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR"
  default     = "10.0.0.0/16"
}

variable "kubernetes_version" {
  type        = string
  description = "EKS Kubernetes version"
  default     = "1.29"
}

variable "node_instance_types" {
  type        = list(string)
  description = "Instance types for managed node groups"
  default     = ["t3.medium"]
}

variable "desired_size" {
  type        = number
  description = "Desired size for node group"
  default     = 2
}

variable "min_size" {
  type        = number
  description = "Min size for node group"
  default     = 1
}

variable "max_size" {
  type        = number
  description = "Max size for node group"
  default     = 3
}

variable "sandbox_mode" {
  type        = bool
  description = "When true, disables AWS resources/actions commonly blocked in training sandboxes (NAT GW, KMS, log retention, default resource management, tags)."
  default     = true
}
