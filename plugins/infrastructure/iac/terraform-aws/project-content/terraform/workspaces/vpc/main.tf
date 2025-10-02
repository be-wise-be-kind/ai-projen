# Purpose: VPC workspace - Persistent networking infrastructure
# Scope: VPC, subnets, internet gateway, route tables, and security groups
# Overview: Creates the foundational network infrastructure for AWS deployments including
#     a VPC with public and private subnets across multiple availability zones, internet
#     gateway for public internet access, route tables for traffic routing, and security
#     groups for ALB and ECS tasks. This workspace contains persistent resources that
#     should not be destroyed frequently. NAT gateways are intentionally omitted for
#     cost optimization and can be added separately if private subnet internet access
#     is required.
# Dependencies: None - this is the foundation workspace
# Exports: VPC ID, subnet IDs, security group IDs for use by other workspaces
# Configuration: Uses variables.tf for customization
# Implementation: Multi-AZ architecture with cost-optimized defaults

terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Data sources
data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

# Local variables
locals {
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
    Workspace   = "vpc"
  }
}

# VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(
    local.common_tags,
    var.additional_tags,
    {
      Name = "${var.project_name}-${var.environment}-vpc"
      Type = "networking"
    }
  )
}

# Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    local.common_tags,
    var.additional_tags,
    {
      Name = "${var.project_name}-${var.environment}-igw"
      Type = "networking"
    }
  )
}

# Public Subnets
resource "aws_subnet" "public" {
  count = var.az_count

  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = merge(
    local.common_tags,
    var.additional_tags,
    {
      Name = "${var.project_name}-${var.environment}-public-${count.index + 1}"
      Type = "public"
      AZ   = data.aws_availability_zones.available.names[count.index]
    }
  )
}

# Private Subnets
resource "aws_subnet" "private" {
  count = var.az_count

  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, var.az_count + count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = merge(
    local.common_tags,
    var.additional_tags,
    {
      Name = "${var.project_name}-${var.environment}-private-${count.index + 1}"
      Type = "private"
      AZ   = data.aws_availability_zones.available.names[count.index]
    }
  )
}

# Route Table - Public
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = merge(
    local.common_tags,
    var.additional_tags,
    {
      Name = "${var.project_name}-${var.environment}-public-rt"
      Type = "route-table"
    }
  )
}

# Route Table Associations - Public
resource "aws_route_table_association" "public" {
  count = var.az_count

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# Security Group - ALB
resource "aws_security_group" "alb" {
  name        = "${var.project_name}-${var.environment}-alb-sg"
  description = "Security group for Application Load Balancer"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "All outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    local.common_tags,
    var.additional_tags,
    {
      Name      = "${var.project_name}-${var.environment}-alb-sg"
      Type      = "security-group"
      Component = "load-balancer"
    }
  )
}

# Security Group - ECS Tasks
resource "aws_security_group" "ecs_tasks" {
  name        = "${var.project_name}-${var.environment}-ecs-tasks-sg"
  description = "Security group for ECS tasks"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "Application traffic from ALB"
    from_port       = var.app_port
    to_port         = var.app_port
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  egress {
    description = "All outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    local.common_tags,
    var.additional_tags,
    {
      Name      = "${var.project_name}-${var.environment}-ecs-tasks-sg"
      Type      = "security-group"
      Component = "ecs-tasks"
    }
  )
}
