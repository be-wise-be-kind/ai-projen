# Purpose: Shared variable definitions used across all Terraform workspaces
# Scope: Common configuration values for project, AWS, and environment settings
# Overview: Provides centralized variable definitions that are shared across all Terraform workspaces
#     including project naming, AWS region, availability zones, and common tags. These variables
#     ensure consistency across all infrastructure components and environments.
# Dependencies: None - this is the foundation for other workspaces
# Exports: Shared variable definitions for import by workspaces
# Related: All workspace variable files that reference these shared values
# Implementation: Reusable variable definitions with sensible defaults

variable "project_name" {
  description = "Project name used for resource naming and tagging"
  type        = string
  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.project_name))
    error_message = "Project name must contain only lowercase letters, numbers, and hyphens"
  }
}

variable "aws_region" {
  description = "AWS region for infrastructure deployment"
  type        = string
  default     = "us-east-1"
  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-[0-9]$", var.aws_region))
    error_message = "AWS region must be in format: us-east-1, eu-west-1, etc."
  }
}

variable "availability_zones" {
  description = "List of availability zones for multi-AZ deployment"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be one of: dev, staging, prod"
  }
}

variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default = {
    ManagedBy = "Terraform"
    Project   = "fullstack-app"
  }
}
