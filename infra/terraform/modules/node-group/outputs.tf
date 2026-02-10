output "node_group_names" {
  value = keys(module.eks.eks_managed_node_groups)
}
