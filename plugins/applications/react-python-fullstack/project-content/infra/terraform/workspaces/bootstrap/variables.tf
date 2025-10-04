# Purpose: Variable definitions for bootstrap workspace
# Scope: Terraform backend and GitHub OIDC configuration
# Overview: Defines input variables for the bootstrap workspace including AWS region, project name,
#     and GitHub repository details. These variables configure the Terraform state backend and
#     GitHub Actions authentication infrastructure.

variable "aws_region" {
  description = "AWS region for infrastructure deployment"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name for resource naming"
  type        = string
}

variable "github_org" {
  description = "GitHub organization or username"
  type        = string
}

variable "github_repo" {
  description = "GitHub repository name"
  type        = string
}
