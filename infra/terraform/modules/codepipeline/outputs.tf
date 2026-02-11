output "pipeline_name" {
  value       = aws_codepipeline.this.name
  description = "CodePipeline name"
}

output "pipeline_console_url" {
  value       = "https://${var.aws_region}.console.aws.amazon.com/codesuite/codepipeline/pipelines/${aws_codepipeline.this.name}/view?region=${var.aws_region}"
  description = "AWS console URL for the pipeline"
}
