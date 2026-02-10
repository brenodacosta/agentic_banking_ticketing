output "node_group_arn" {
  value       = module.managed_node_group.node_group_arn
  description = "ARN of the managed node group"
}

output "node_group_id" {
  value       = module.managed_node_group.node_group_id
  description = "EKS cluster name and node group name separated by ':'"
}

output "node_group_iam_role_arn" {
  value       = module.managed_node_group.iam_role_arn
  description = "IAM role ARN for the managed node group"
}
