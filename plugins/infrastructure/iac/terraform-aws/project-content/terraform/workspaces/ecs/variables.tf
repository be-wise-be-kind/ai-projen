# Purpose: Variable definitions for ECS workspace configuration
# Scope: Input variables for ECS cluster, services, tasks, and auto-scaling
# Overview: Defines all input variables required for the ECS workspace including
#     project identification, service configuration, task sizing, container settings,
#     auto-scaling parameters, and VPC workspace references. Variables support
#     environment-specific deployments with sensible defaults optimized for cost
#     and performance.
# Dependencies: References VPC workspace via terraform_remote_state
# Exports: Variables available throughout the ECS workspace
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

# Service Configuration
variable "service_name" {
  description = "Name of the ECS service (e.g., backend, frontend, api)"
  type        = string

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]*$", var.service_name))
    error_message = "Service name must start with a letter and contain only lowercase letters, numbers, and hyphens."
  }
}

variable "desired_count" {
  description = "Desired number of tasks to run"
  type        = number
  default     = 1

  validation {
    condition     = var.desired_count >= 0
    error_message = "Desired count must be non-negative."
  }
}

# Task Configuration
variable "task_cpu" {
  description = "CPU units for the task (256, 512, 1024, 2048, 4096)"
  type        = string
  default     = "256"

  validation {
    condition     = contains(["256", "512", "1024", "2048", "4096"], var.task_cpu)
    error_message = "Task CPU must be one of: 256, 512, 1024, 2048, 4096."
  }
}

variable "task_memory" {
  description = "Memory for the task in MB (512, 1024, 2048, 4096, 8192, etc.)"
  type        = string
  default     = "512"
}

# Container Configuration
variable "container_image" {
  description = "Docker image for the container (e.g., nginx:latest or ECR URI)"
  type        = string
}

variable "container_port" {
  description = "Port exposed by the container"
  type        = number
  default     = 8000

  validation {
    condition     = var.container_port > 0 && var.container_port < 65536
    error_message = "Container port must be between 1 and 65535."
  }
}

variable "container_environment" {
  description = "Environment variables for the container"
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

variable "health_check_command" {
  description = "Health check command for the container"
  type        = list(string)
  default     = ["CMD-SHELL", "curl -f http://localhost:8000/health || exit 1"]
}

# Load Balancer Integration
variable "target_group_arn" {
  description = "ARN of the target group to attach (leave empty for no load balancer)"
  type        = string
  default     = ""
}

# Auto-scaling Configuration
variable "enable_autoscaling" {
  description = "Enable auto-scaling for the service"
  type        = bool
  default     = false
}

variable "autoscaling_min_capacity" {
  description = "Minimum number of tasks for auto-scaling"
  type        = number
  default     = 1
}

variable "autoscaling_max_capacity" {
  description = "Maximum number of tasks for auto-scaling"
  type        = number
  default     = 4
}

variable "autoscaling_cpu_target" {
  description = "Target CPU utilization percentage for auto-scaling"
  type        = number
  default     = 60.0

  validation {
    condition     = var.autoscaling_cpu_target > 0 && var.autoscaling_cpu_target <= 100
    error_message = "CPU target must be between 1 and 100."
  }
}

# VPC Workspace Reference
variable "terraform_state_bucket" {
  description = "S3 bucket name for Terraform state (to reference VPC workspace)"
  type        = string
}

# Tags
variable "additional_tags" {
  description = "Additional tags to apply to all resources"
  type        = map(string)
  default     = {}
}
