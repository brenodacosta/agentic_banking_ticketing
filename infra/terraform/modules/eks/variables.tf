variable "cluster_name" {
  type        = string
  description = "EKS cluster name"
}

variable "kubernetes_version" {
  type        = string
  description = "EKS Kubernetes version"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "Private subnet IDs"
}

variable "public_subnet_ids" {
  type        = list(string)
  description = "Public subnet IDs"
}

variable "enable_irsa" {
  type        = bool
  description = "Whether to enable IRSA (requires IAM OIDC provider creation)"
  default     = true
}

variable "create_kms_key" {
  type        = bool
  description = "Whether to create a KMS key for cluster encryption"
  default     = true
}

variable "cluster_encryption_config" {
  type        = any
  description = "Cluster encryption config (set to {} to disable)"
  default     = null
}

variable "create_cloudwatch_log_group" {
  type        = bool
  description = "Whether to create/manage the EKS CloudWatch log group"
  default     = true
}

variable "cluster_enabled_log_types" {
  type        = list(string)
  description = "EKS control-plane log types to enable"
  default     = ["api", "audit", "authenticator"]
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to EKS resources"
  default     = {}
}
