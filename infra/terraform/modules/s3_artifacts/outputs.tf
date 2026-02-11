output "bucket_name" {
  value       = aws_s3_bucket.this.bucket
  description = "Artifact bucket name"
}

output "bucket_arn" {
  value       = aws_s3_bucket.this.arn
  description = "Artifact bucket ARN"
}
