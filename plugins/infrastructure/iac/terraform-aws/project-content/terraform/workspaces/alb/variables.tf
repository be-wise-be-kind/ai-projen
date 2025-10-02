# Purpose: Variable definitions for ALB workspace configuration
# Scope: Input variables for ALB, target groups, listeners, and health checks
# Overview: Defines all input variables required for the ALB workspace including
#     project identification, target group configuration, health check settings,
#     HTTPS configuration, and alarm thresholds. Variables support environment-
#     specific deployments with sensible defaults optimized for cost and availability.
# Dependencies: References VPC workspace via terraform_remote_state
# Exports: Variables available throughout the ALB workspace
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
  description = "Name of the service this ALB serves (e.g., api, web, frontend)"
  type        = string

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]*$", var.service_name))
    error_message = "Service name must start with a letter and contain only lowercase letters, numbers, and hyphens."
  }
}

# Target Group Configuration
variable "target_port" {
  description = "Port for the target group"
  type        = number
  default     = 8000

  validation {
    condition     = var.target_port > 0 && var.target_port < 65536
    error_message = "Target port must be between 1 and 65535."
  }
}

# Health Check Configuration
variable "health_check_path" {
  description = "Path for health check"
  type        = string
  default     = "/health"
}

variable "health_check_interval" {
  description = "Health check interval in seconds"
  type        = number
  default     = 30

  validation {
    condition     = var.health_check_interval >= 5 && var.health_check_interval <= 300
    error_message = "Health check interval must be between 5 and 300 seconds."
  }
}

variable "health_check_timeout" {
  description = "Health check timeout in seconds"
  type        = number
  default     = 5

  validation {
    condition     = var.health_check_timeout >= 2 && var.health_check_timeout <= 120
    error_message = "Health check timeout must be between 2 and 120 seconds."
  }
}

variable "health_check_healthy_threshold" {
  description = "Number of consecutive successful health checks before marking target healthy"
  type        = number
  default     = 2

  validation {
    condition     = var.health_check_healthy_threshold >= 2 && var.health_check_healthy_threshold <= 10
    error_message = "Healthy threshold must be between 2 and 10."
  }
}

variable "health_check_unhealthy_threshold" {
  description = "Number of consecutive failed health checks before marking target unhealthy"
  type        = number
  default     = 2

  validation {
    condition     = var.health_check_unhealthy_threshold >= 2 && var.health_check_unhealthy_threshold <= 10
    error_message = "Unhealthy threshold must be between 2 and 10."
  }
}

variable "health_check_matcher" {
  description = "HTTP status codes to match for successful health check"
  type        = string
  default     = "200"
}

# Stickiness Configuration
variable "enable_stickiness" {
  description = "Enable session stickiness"
  type        = bool
  default     = false
}

# HTTPS Configuration
variable "enable_https" {
  description = "Enable HTTPS listener"
  type        = bool
  default     = false
}

variable "enable_https_redirect" {
  description = "Redirect HTTP to HTTPS"
  type        = bool
  default     = false
}

variable "certificate_arn" {
  description = "ARN of ACM certificate for HTTPS (required if enable_https is true)"
  type        = string
  default     = ""
}

variable "ssl_policy" {
  description = "SSL policy for HTTPS listener"
  type        = string
  default     = "ELBSecurityPolicy-TLS-1-2-2017-01"
}

# Listener Rules
variable "path_patterns" {
  description = "Path patterns for routing (e.g., ['/api/*', '/health'])"
  type        = list(string)
  default     = []
}

# CloudWatch Alarms
variable "latency_threshold" {
  description = "Latency threshold in seconds for CloudWatch alarm"
  type        = number
  default     = 2.0

  validation {
    condition     = var.latency_threshold > 0
    error_message = "Latency threshold must be positive."
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
