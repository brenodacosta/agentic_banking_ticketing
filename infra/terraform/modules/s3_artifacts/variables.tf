variable "name" {
  type        = string
  description = "Name prefix"
}

variable "force_destroy" {
  type        = bool
  description = "Whether to allow destroying the bucket even if it contains objects"
  default     = false
}
