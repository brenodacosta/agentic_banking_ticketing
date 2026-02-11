variable "name" {
  type        = string
  description = "Name prefix"
}

variable "artifact_bucket_name" {
  type        = string
  description = "S3 bucket used as the CodePipeline artifact store"
}

variable "source_object_key" {
  type        = string
  description = "S3 object key for the source bundle (zip)"
}

variable "codedeploy_app_name" {
  type        = string
  description = "CodeDeploy application name"
}

variable "codedeploy_deployment_group_name" {
  type        = string
  description = "CodeDeploy deployment group name"
}

variable "aws_region" {
  type        = string
  description = "AWS region (used for console URL output)"
}
