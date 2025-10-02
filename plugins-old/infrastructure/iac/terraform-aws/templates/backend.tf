# Purpose: Configure Terraform backend for secure state management using AWS S3 and DynamoDB
# Scope: Infrastructure state storage and locking for all environments and workspaces
# Overview: This file establishes the backend configuration for Terraform state management,
#     using S3 for versioned state storage and DynamoDB for state locking to prevent
#     concurrent modifications. The backend ensures infrastructure state is securely stored,
#     encrypted at rest, and protected from simultaneous updates. This configuration must
#     be initialized before any infrastructure can be created or modified. The S3 bucket
#     and DynamoDB table must exist before running terraform init.
# Dependencies: AWS S3 bucket and DynamoDB table (must be created manually first)
# Configuration: Customize bucket name, region, and key path for your project
# Implementation: Copy this file to each workspace directory and customize the key path

terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # S3 backend configuration for state storage
  # IMPORTANT: The S3 bucket and DynamoDB table must be created before running terraform init
  # See how-to-manage-state.md for setup instructions
  backend "s3" {
    # Bucket name - MUST be globally unique
    # Recommended naming: [project]-[account-id]-terraform-state
    # Example: myproject-123456789012-terraform-state
    bucket = "REPLACE_WITH_YOUR_BUCKET_NAME"

    # Key path within the bucket for the state file
    # Use different paths for different workspaces and environments
    # VPC workspace:    "vpc/[environment]/terraform.tfstate"
    # ECS workspace:    "ecs/[environment]/terraform.tfstate"
    # ALB workspace:    "alb/[environment]/terraform.tfstate"
    key = "REPLACE_WITH_WORKSPACE_PATH/terraform.tfstate"

    # AWS region where the bucket exists
    region = "us-west-2"

    # Enable state file encryption at rest
    encrypt = true

    # DynamoDB table for state locking
    # Table must have a primary key named "LockID" of type String
    # Recommended naming: [project]-terraform-locks
    dynamodb_table = "REPLACE_WITH_YOUR_LOCK_TABLE_NAME"
  }
}

# Example backend configurations for different workspaces:
#
# VPC workspace (terraform/workspaces/vpc/backend.tf):
# backend "s3" {
#   bucket         = "myproject-123456789012-terraform-state"
#   key            = "vpc/dev/terraform.tfstate"
#   region         = "us-west-2"
#   encrypt        = true
#   dynamodb_table = "myproject-terraform-locks"
# }
#
# ECS workspace (terraform/workspaces/ecs/backend.tf):
# backend "s3" {
#   bucket         = "myproject-123456789012-terraform-state"
#   key            = "ecs/dev/terraform.tfstate"
#   region         = "us-west-2"
#   encrypt        = true
#   dynamodb_table = "myproject-terraform-locks"
# }
#
# ALB workspace (terraform/workspaces/alb/backend.tf):
# backend "s3" {
#   bucket         = "myproject-123456789012-terraform-state"
#   key            = "alb/dev/terraform.tfstate"
#   region         = "us-west-2"
#   encrypt        = true
#   dynamodb_table = "myproject-terraform-locks"
# }
