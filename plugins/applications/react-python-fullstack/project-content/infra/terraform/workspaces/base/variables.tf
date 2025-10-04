# Purpose: Variable definitions for base workspace
# Scope: VPC, networking, ECR, and ALB configuration
# Overview: Defines input variables for the base infrastructure workspace including AWS region,
#     VPC CIDR, availability zones, and project naming. These variables control the networking,
#     container registry, and load balancer configuration for the environment.

variable "aws_region" {
  description = "AWS region for infrastructure deployment"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name for resource naming"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "List of availability zones for multi-AZ deployment"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}
