variable "name" {
  type        = string
  description = "Name prefix"
}

variable "asg_name" {
  type        = string
  description = "AutoScaling Group name to associate with the deployment group"
}

variable "target_group_name" {
  type        = string
  description = "ALB target group name to use with CodeDeploy traffic control"
}
