variable "project_name" {
  type        = string
  description = "Name prefix for resources"
}

variable "name" {
  type        = string
  description = "Name used for tagging/naming resources"
}

variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR"
}

variable "azs" {
  type        = list(string)
  description = "Availability zones"
}

variable "enable_nat_gateway" {
  type        = bool
  description = "Whether to provision NAT Gateways for private subnet egress"
  default     = true
}

variable "single_nat_gateway" {
  type        = bool
  description = "Whether to provision a single shared NAT Gateway"
  default     = true
}

variable "manage_default_network_acl" {
  type        = bool
  description = "Whether to manage the default network ACL (can require delete permissions)"
  default     = true
}

variable "manage_default_route_table" {
  type        = bool
  description = "Whether to manage the default route table"
  default     = true
}

variable "manage_default_security_group" {
  type        = bool
  description = "Whether to manage the default security group"
  default     = true
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to resources"
  default     = {}
}
