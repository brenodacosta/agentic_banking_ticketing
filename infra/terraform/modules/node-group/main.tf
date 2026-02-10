module "managed_node_group" {
  source  = "terraform-aws-modules/eks/aws//modules/eks-managed-node-group"
  version = "~> 20.0"

  name = "default"

  cluster_name        = var.cluster_name
  cluster_endpoint    = var.cluster_endpoint
  cluster_auth_base64 = var.cluster_ca_data

  subnet_ids = var.private_subnet_ids

  instance_types = var.node_instance_types
  min_size       = var.min_size
  max_size       = var.max_size
  desired_size   = var.desired_size

  # Keep it simple for practice; let EKS manage the launch template.
  # Setting these to false allows using `disk_size` directly.
  create_launch_template     = false
  use_custom_launch_template = false
  disk_size                  = 20

  tags = {
    Project = var.cluster_name
  }
}
