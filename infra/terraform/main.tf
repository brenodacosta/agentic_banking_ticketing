data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  app_subnet_ids = var.sandbox_mode ? module.vpc.public_subnet_ids : module.vpc.private_subnet_ids
  tags = var.sandbox_mode ? {} : {
    Project = var.name
  }
}

module "vpc" {
  source = "./modules/vpc"

  project_name = var.project_name
  name         = var.name
  vpc_cidr     = var.vpc_cidr
  azs          = slice(data.aws_availability_zones.available.names, 0, 3)

  enable_nat_gateway = var.sandbox_mode ? false : true
  single_nat_gateway = var.sandbox_mode ? false : true

  manage_default_network_acl    = var.sandbox_mode ? false : true
  manage_default_route_table    = var.sandbox_mode ? false : true
  manage_default_security_group = var.sandbox_mode ? false : true

  tags = local.tags
}

module "security" {
  source = "./modules/security"

  name   = var.name
  vpc_id = module.vpc.vpc_id

  app_port          = var.app_port
  alb_ingress_cidrs = var.alb_ingress_cidrs
}

module "alb" {
  source = "./modules/alb"

  name              = var.name
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  alb_sg_id         = module.security.alb_sg_id

  target_port       = var.app_port
  health_check_path = var.alb_health_check_path
}

module "s3_artifacts" {
  source = "./modules/s3_artifacts"

  name          = var.name
  force_destroy = var.artifacts_force_destroy
}

module "rds" {
  source = "./modules/rds"

  name               = var.name
  private_subnet_ids = module.vpc.private_subnet_ids
  rds_sg_id          = module.security.rds_sg_id

  db_name           = var.db_name
  db_username       = var.db_username
  instance_class    = var.db_instance_class
  allocated_storage = var.db_allocated_storage
}

module "asg" {
  source = "./modules/asg"

  name       = var.name
  aws_region = var.aws_region

  subnet_ids = local.app_subnet_ids
  ec2_sg_id  = module.security.ec2_sg_id

  instance_type    = var.instance_type
  desired_capacity = var.desired_capacity
  min_size         = var.asg_min_size
  max_size         = var.asg_max_size

  target_group_arns = [module.alb.target_group_arn]

  artifact_bucket_name   = module.s3_artifacts.bucket_name
  db_password_secret_arn = module.rds.db_password_secret_arn
  ai_key_secret_arn      = module.rds.ai_key_secret_arn
}

module "codedeploy" {
  source = "./modules/codedeploy"

  name              = var.name
  asg_name          = module.asg.asg_name
  target_group_name = module.alb.target_group_name
}

module "codepipeline" {
  source = "./modules/codepipeline"

  name                             = var.name
  aws_region                       = var.aws_region
  artifact_bucket_name             = module.s3_artifacts.bucket_name
  source_object_key                = var.pipeline_source_object_key
  codedeploy_app_name              = module.codedeploy.codedeploy_app_name
  codedeploy_deployment_group_name = module.codedeploy.deployment_group_name
}
