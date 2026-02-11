output "alb_sg_id" {
  value       = aws_security_group.alb.id
  description = "Security group ID for the ALB"
}

output "ec2_sg_id" {
  value       = aws_security_group.ec2.id
  description = "Security group ID for the EC2 instances"
}

output "rds_sg_id" {
  value       = aws_security_group.rds.id
  description = "Security group ID for the RDS instance"
}
