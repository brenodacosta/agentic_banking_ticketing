output "alb_dns_name" {
  value       = module.alb.alb_dns_name
  description = "DNS name of the Application Load Balancer"
}

output "rds_endpoint" {
  value       = module.rds.rds_endpoint
  description = "RDS endpoint address"
}

output "asg_name" {
  value       = module.asg.asg_name
  description = "AutoScaling Group name"
}

output "artifacts_bucket_name" {
  value       = module.s3_artifacts.bucket_name
  description = "S3 bucket name used for CodePipeline artifacts and S3 source"
}

output "codepipeline_console_url" {
  value       = module.codepipeline.pipeline_console_url
  description = "AWS console URL for the CodePipeline"
}
