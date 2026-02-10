variable "cluster_name" {
  type        = string
  description = "EKS cluster name"
}

variable "cluster_endpoint" {
  type        = string
  description = "EKS cluster endpoint"
}

variable "cluster_ca_data" {
  type        = string
  description = "EKS cluster CA data"
}

variable "cluster_service_cidr" {
  type        = string
  description = "Kubernetes service CIDR for the EKS cluster (required by the node group user-data module)"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "Private subnet IDs"
}

variable "node_instance_types" {
  type        = list(string)
  description = "Instance types for managed node group"
}

variable "desired_size" {
  type        = number
  description = "Desired node count"
}

variable "min_size" {
  type        = number
  description = "Minimum node count"
}

variable "max_size" {
  type        = number
  description = "Maximum node count"
}

