output "asg_name" {
  value       = aws_autoscaling_group.this.name
  description = "AutoScaling Group name"
}

output "ec2_role_arn" {
  value       = aws_iam_role.ec2.arn
  description = "IAM role ARN for the EC2 instances"
}
