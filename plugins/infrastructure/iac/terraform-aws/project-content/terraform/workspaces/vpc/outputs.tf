# Purpose: Output definitions for VPC workspace resources
# Scope: Exports VPC, subnet, and security group identifiers
# Overview: Provides comprehensive outputs from the VPC workspace that can be consumed
#     by other workspaces (ECS, ALB) via Terraform data sources or remote state. These
#     outputs include all necessary identifiers for VPC networking, public and private
#     subnets, security groups, and configuration values. Outputs enable other workspaces
#     to reference VPC resources without direct dependencies, maintaining clean separation
#     between workspace layers.
# Dependencies: All VPC workspace resources (main.tf)
# Exports: Resource IDs, CIDRs, and configuration values
# Implementation: Simple output strategy for workspace composition

# VPC Outputs
output "vpc_id" {
  description = "VPC ID for use by other workspaces"
  value       = aws_vpc.main.id
}

output "vpc_cidr" {
  description = "VPC CIDR block"
  value       = aws_vpc.main.cidr_block
}

# Subnet Outputs
output "public_subnet_ids" {
  description = "Public subnet IDs for ALB and other public resources"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "Private subnet IDs for ECS tasks and other private resources"
  value       = aws_subnet.private[*].id
}

output "public_subnet_cidrs" {
  description = "Public subnet CIDR blocks"
  value       = aws_subnet.public[*].cidr_block
}

output "private_subnet_cidrs" {
  description = "Private subnet CIDR blocks"
  value       = aws_subnet.private[*].cidr_block
}

# Security Group Outputs
output "alb_security_group_id" {
  description = "ALB security group ID for use by ALB workspace"
  value       = aws_security_group.alb.id
}

output "ecs_tasks_security_group_id" {
  description = "ECS tasks security group ID for use by ECS workspace"
  value       = aws_security_group.ecs_tasks.id
}

# Configuration Outputs
output "environment" {
  description = "Environment name"
  value       = var.environment
}

output "aws_region" {
  description = "AWS region"
  value       = var.aws_region
}

output "project_name" {
  description = "Project name"
  value       = var.project_name
}

output "availability_zones" {
  description = "Availability zones used by subnets"
  value       = data.aws_availability_zones.available.names
}
