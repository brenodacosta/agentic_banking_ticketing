module "managed_node_group" {
  source  = "terraform-aws-modules/eks/aws//modules/eks-managed-node-group"
  version = "~> 20.0"

  name = "default"

  cluster_name         = var.cluster_name
  cluster_endpoint     = var.cluster_endpoint
  cluster_auth_base64  = var.cluster_ca_data
  cluster_service_cidr = var.cluster_service_cidr

  subnet_ids = var.private_subnet_ids

  instance_types = var.node_instance_types
  min_size       = var.min_size
  max_size       = var.max_size
  desired_size   = var.desired_size

  create_launch_template     = false
  use_custom_launch_template = false
  disk_size                  = 20

  # NOTE: No tags in Whizlabs sandbox to avoid iam:TagPolicy denial.
}
