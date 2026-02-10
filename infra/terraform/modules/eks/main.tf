module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = var.cluster_name
  cluster_version = var.kubernetes_version

  vpc_id     = var.vpc_id
  subnet_ids = var.private_subnet_ids

  cluster_endpoint_public_access  = true
  cluster_endpoint_private_access = true

  enable_irsa = var.enable_irsa

  create_kms_key            = var.create_kms_key
  cluster_encryption_config = var.cluster_encryption_config

  create_cloudwatch_log_group = var.create_cloudwatch_log_group
  cluster_enabled_log_types   = var.cluster_enabled_log_types

  # We keep node groups separate in this phase.
  eks_managed_node_groups = {}

  tags = var.tags
}
