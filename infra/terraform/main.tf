data "aws_availability_zones" "available" {
  state = "available"
}

module "vpc" {
  source = "./modules/vpc"

  project_name = var.project_name
  cluster_name = var.cluster_name
  vpc_cidr     = var.vpc_cidr
  azs          = slice(data.aws_availability_zones.available.names, 0, 3)

  enable_nat_gateway = var.sandbox_mode ? false : true
  single_nat_gateway = var.sandbox_mode ? false : true

  manage_default_network_acl    = var.sandbox_mode ? false : true
  manage_default_route_table    = var.sandbox_mode ? false : true
  manage_default_security_group = var.sandbox_mode ? false : true

  tags = var.sandbox_mode ? {} : {
    Project = var.cluster_name
  }
}

module "eks" {
  source = "./modules/eks"

  cluster_name       = var.cluster_name
  kubernetes_version = var.kubernetes_version
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  public_subnet_ids  = module.vpc.public_subnet_ids

  # Sandbox: avoid kms:CreateKey
  create_kms_key            = false
  cluster_encryption_config = {}

  # Sandbox: avoid logs:PutRetentionPolicy
  create_cloudwatch_log_group = false
  cluster_enabled_log_types   = []

  tags = var.sandbox_mode ? {} : {
    Project = var.cluster_name
  }
}

module "node_group" {
  source = "./modules/node-group"

  cluster_name         = module.eks.cluster_name
  cluster_endpoint     = module.eks.cluster_endpoint
  cluster_ca_data      = module.eks.cluster_ca_data
  cluster_service_cidr = module.eks.cluster_service_cidr

  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids

  node_instance_types = var.node_instance_types
  desired_size        = var.desired_size
  min_size            = var.min_size
  max_size            = var.max_size
}
