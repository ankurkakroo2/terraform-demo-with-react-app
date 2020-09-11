output "listener" {
  value       = aws_lb_listener.listener
  description = "Load Balancer listener"
}

output "target_group" {
  value       = aws_lb_target_group.target_group
  description = "Load Balancer target group"
}

output "environment_url" {
  value = aws_alb.lb.dns_name
}