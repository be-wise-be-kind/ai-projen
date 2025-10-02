# Purpose: Output definitions for ECS workspace resources
# Scope: Exports ECS cluster, service, and task definition identifiers
# Overview: Provides outputs from the ECS workspace including cluster information,
#     service details, task definition ARNs, and IAM role ARNs. These outputs can
#     be used by other workspaces or for CI/CD integration.
# Dependencies: All ECS workspace resources (main.tf)
# Exports: Resource ARNs, names, and identifiers
# Implementation: Simple output strategy for workspace integration

# Cluster Outputs
output "cluster_id" {
  description = "ECS cluster ID"
  value       = aws_ecs_cluster.main.id
}

output "cluster_name" {
  description = "ECS cluster name"
  value       = aws_ecs_cluster.main.name
}

output "cluster_arn" {
  description = "ECS cluster ARN"
  value       = aws_ecs_cluster.main.arn
}

# Service Outputs
output "service_id" {
  description = "ECS service ID"
  value       = aws_ecs_service.app.id
}

output "service_name" {
  description = "ECS service name"
  value       = aws_ecs_service.app.name
}

output "service_arn" {
  description = "ECS service ARN"
  value       = aws_ecs_service.app.arn
}

# Task Definition Outputs
output "task_definition_arn" {
  description = "ECS task definition ARN"
  value       = aws_ecs_task_definition.app.arn
}

output "task_definition_family" {
  description = "ECS task definition family"
  value       = aws_ecs_task_definition.app.family
}

output "task_definition_revision" {
  description = "ECS task definition revision"
  value       = aws_ecs_task_definition.app.revision
}

# IAM Role Outputs
output "task_execution_role_arn" {
  description = "Task execution role ARN"
  value       = aws_iam_role.task_execution_role.arn
}

output "task_role_arn" {
  description = "Task role ARN"
  value       = aws_iam_role.task_role.arn
}

# CloudWatch Log Group
output "log_group_name" {
  description = "CloudWatch log group name"
  value       = aws_cloudwatch_log_group.app.name
}

output "log_group_arn" {
  description = "CloudWatch log group ARN"
  value       = aws_cloudwatch_log_group.app.arn
}

# Configuration Outputs
output "environment" {
  description = "Environment name"
  value       = var.environment
}

output "container_port" {
  description = "Container port"
  value       = var.container_port
}
