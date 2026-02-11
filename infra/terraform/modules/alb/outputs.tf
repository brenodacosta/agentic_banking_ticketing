output "alb_dns_name" {
  value       = aws_lb.this.dns_name
  description = "DNS name of the ALB"
}

output "alb_arn" {
  value       = aws_lb.this.arn
  description = "ARN of the ALB"
}

output "target_group_arn" {
  value       = aws_lb_target_group.app.arn
  description = "ARN of the app target group"
}

output "target_group_name" {
  value       = aws_lb_target_group.app.name
  description = "Name of the app target group"
}
