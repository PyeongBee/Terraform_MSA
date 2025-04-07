output "web_alb" {
  description = "The ALB"
  value       = aws_lb.alb_sub
}

output "web_alb_arn" {
  description = "The ARN of ALB"
  value       = aws_lb.alb_sub.arn
}

output "web_alb_name" {
  description = "The name of ALB"
  value       = aws_lb.alb_sub.name
}

output "web_alb_dns_name" {
  description = "The DNS name of ALB"
  value       = aws_lb.alb_sub.dns_name
}

output "web_target_group_id" {
  description = "The ID of Target Group for ALB"
  value       = aws_lb_target_group.alb_sub_http_tg.id
}

output "web_target_group_arn" {
  description = "The ARN of Target Group for ALB"
  value       = aws_lb_target_group.alb_sub_http_tg.arn
}
