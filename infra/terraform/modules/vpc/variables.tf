variable "project_name" {
  type        = string
  description = "Name prefix for resources"
}

variable "cluster_name" {
  type        = string
  description = "EKS cluster name (used for subnet tags)"
}

variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR"
}

variable "azs" {
  type        = list(string)
  description = "Availability zones"
}
