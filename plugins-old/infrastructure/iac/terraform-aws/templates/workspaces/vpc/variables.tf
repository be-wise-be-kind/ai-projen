# Purpose: Variable definitions for VPC workspace configuration
# Scope: Input variables for VPC, subnets, and networking resources
# Overview: Defines all input variables required for the VPC workspace including
#     project identification, environment configuration, VPC CIDR blocks, availability
#     zone count, and application port settings. Each variable includes validation
#     rules to ensure proper values and sensible defaults optimized for cost and
#     security. Variables support multi-environment deployments with environment-
#     specific tfvars files.
# Dependencies: None
# Exports: Variables available throughout the VPC workspace
# Configuration: Override via terraform.tfvars or -var flags

# Core Configuration
variable "project_name" {
  description = "Name of the project, used as a prefix for all resources"
  type        = string

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]*$", var.project_name))
    error_message = "Project name must start with a letter and contain only lowercase letters, numbers, and hyphens."
  }
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be one of: dev, staging, prod."
  }
}

variable "aws_region" {
  description = "AWS region for resource deployment"
  type        = string
  default     = "us-west-2"
}

# Networking Variables
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"

  validation {
    condition     = can(cidrhost(var.vpc_cidr, 0))
    error_message = "VPC CIDR must be a valid IPv4 CIDR block."
  }
}

variable "az_count" {
  description = "Number of availability zones to use"
  type        = number
  default     = 2

  validation {
    condition     = var.az_count >= 1 && var.az_count <= 6
    error_message = "AZ count must be between 1 and 6."
  }
}

variable "app_port" {
  description = "Application port for ECS tasks (used in security group rules)"
  type        = number
  default     = 8000

  validation {
    condition     = var.app_port > 0 && var.app_port < 65536
    error_message = "App port must be between 1 and 65535."
  }
}

# Tags
variable "additional_tags" {
  description = "Additional tags to apply to all resources"
  type        = map(string)
  default     = {}
}
