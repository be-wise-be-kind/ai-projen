# Purpose: Output definitions for ALB workspace resources
# Scope: Exports ALB, target group, and listener identifiers
# Overview: Provides outputs from the ALB workspace including load balancer details,
#     target group ARNs, listener ARNs, and DNS names. These outputs can be used
#     by other workspaces (especially ECS) or for DNS configuration.
# Dependencies: All ALB workspace resources (main.tf)
# Exports: Resource ARNs, DNS names, and identifiers
# Implementation: Simple output strategy for workspace integration

# Load Balancer Outputs
output "alb_id" {
  description = "ALB ID"
  value       = aws_lb.main.id
}

output "alb_arn" {
  description = "ALB ARN"
  value       = aws_lb.main.arn
}

output "alb_arn_suffix" {
  description = "ALB ARN suffix for CloudWatch metrics"
  value       = aws_lb.main.arn_suffix
}

output "alb_dns_name" {
  description = "ALB DNS name (use this for Route53 records)"
  value       = aws_lb.main.dns_name
}

output "alb_zone_id" {
  description = "ALB hosted zone ID (for Route53 alias records)"
  value       = aws_lb.main.zone_id
}

# Target Group Outputs
output "target_group_arn" {
  description = "Target group ARN (use this in ECS service configuration)"
  value       = aws_lb_target_group.app.arn
}

output "target_group_name" {
  description = "Target group name"
  value       = aws_lb_target_group.app.name
}

output "target_group_arn_suffix" {
  description = "Target group ARN suffix for CloudWatch metrics"
  value       = aws_lb_target_group.app.arn_suffix
}

# Listener Outputs
output "http_listener_arn" {
  description = "HTTP listener ARN"
  value       = aws_lb_listener.http.arn
}

output "https_listener_arn" {
  description = "HTTPS listener ARN (empty if HTTPS not enabled)"
  value       = var.enable_https && var.certificate_arn != "" ? aws_lb_listener.https[0].arn : ""
}

# Configuration Outputs
output "environment" {
  description = "Environment name"
  value       = var.environment
}

output "service_name" {
  description = "Service name"
  value       = var.service_name
}

output "target_port" {
  description = "Target port"
  value       = var.target_port
}
