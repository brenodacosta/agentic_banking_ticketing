module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  # Attach a managed node group to an existing cluster
  cluster_name    = var.cluster_name
  cluster_version = null

  vpc_id     = var.vpc_id
  subnet_ids = var.private_subnet_ids

  create_cluster = false

  eks_managed_node_groups = {
    default = {
      instance_types = var.node_instance_types
      min_size       = var.min_size
      max_size       = var.max_size
      desired_size   = var.desired_size

      create_iam_role = false
      iam_role_arn    = var.eks_managed_node_group_role_arn

      # Use the security groups created by the cluster module
      cluster_security_group_id = var.cluster_security_group_id
      node_security_group_id    = var.node_security_group_id
    }
  }
}
