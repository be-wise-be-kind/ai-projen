# Purpose: ALB workspace - Application Load Balancer infrastructure
# Scope: ALB, target groups, listeners, and health check configurations
# Overview: Creates the Application Load Balancer that serves as the entry point for
#     all incoming traffic to the application. Includes target groups for services
#     running on ECS Fargate, health check configurations to ensure availability,
#     and listener rules for HTTP/HTTPS traffic routing. The ALB is designed for
#     cost optimization with minimal resources while maintaining high availability.
#     Security is enforced through security groups and HTTPS termination.
# Dependencies: Requires VPC workspace outputs (VPC ID, subnet IDs, security group IDs)
# Exports: ALB ARN, DNS name, target group ARNs, listener ARNs
# Configuration: Uses variables.tf and references VPC workspace via data sources
# Implementation: Public ALB with configurable target groups and listeners

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
data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

# Reference VPC workspace outputs
data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = var.terraform_state_bucket
    key    = "vpc/${var.environment}/terraform.tfstate"
    region = var.aws_region
  }
}

# Local variables
locals {
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
    Workspace   = "alb"
  }

  vpc_id                 = data.terraform_remote_state.vpc.outputs.vpc_id
  public_subnet_ids      = data.terraform_remote_state.vpc.outputs.public_subnet_ids
  alb_security_group_id  = data.terraform_remote_state.vpc.outputs.alb_security_group_id
}

# Application Load Balancer
resource "aws_lb" "main" {
  name               = "${var.project_name}-${var.environment}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [local.alb_security_group_id]
  subnets            = local.public_subnet_ids

  enable_deletion_protection       = var.environment == "prod" ? true : false
  enable_http2                     = true
  enable_cross_zone_load_balancing = false

  tags = merge(
    local.common_tags,
    {
      Name = "${var.project_name}-${var.environment}-alb"
      Type = "ApplicationLoadBalancer"
    }
  )
}

# Target Group
resource "aws_lb_target_group" "app" {
  name                 = "${var.project_name}-${var.environment}-${var.service_name}-tg"
  port                 = var.target_port
  protocol             = "HTTP"
  vpc_id               = local.vpc_id
  target_type          = "ip"
  deregistration_delay = var.environment == "prod" ? 30 : 10

  health_check {
    enabled             = true
    healthy_threshold   = var.health_check_healthy_threshold
    unhealthy_threshold = var.health_check_unhealthy_threshold
    timeout             = var.health_check_timeout
    interval            = var.health_check_interval
    path                = var.health_check_path
    matcher             = var.health_check_matcher
    protocol            = "HTTP"
  }

  stickiness {
    enabled         = var.enable_stickiness
    type            = "lb_cookie"
    cookie_duration = 86400
  }

  tags = merge(
    local.common_tags,
    {
      Name    = "${var.project_name}-${var.environment}-${var.service_name}-tg"
      Service = var.service_name
    }
  )
}

# HTTP Listener
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = var.enable_https_redirect ? "redirect" : "forward"

    dynamic "redirect" {
      for_each = var.enable_https_redirect ? [1] : []
      content {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }
    }

    target_group_arn = var.enable_https_redirect ? null : aws_lb_target_group.app.arn
  }
}

# HTTPS Listener (optional)
resource "aws_lb_listener" "https" {
  count = var.enable_https && var.certificate_arn != "" ? 1 : 0

  load_balancer_arn = aws_lb.main.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = var.ssl_policy
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }
}

# Additional Listener Rules (optional)
resource "aws_lb_listener_rule" "path_based" {
  count = length(var.path_patterns) > 0 ? 1 : 0

  listener_arn = aws_lb_listener.http.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }

  condition {
    path_pattern {
      values = var.path_patterns
    }
  }
}

# CloudWatch Alarms - Unhealthy Hosts
resource "aws_cloudwatch_metric_alarm" "unhealthy_hosts" {
  count = var.environment == "prod" ? 1 : 0

  alarm_name          = "${var.project_name}-${var.environment}-alb-unhealthy-hosts"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "UnHealthyHostCount"
  namespace           = "AWS/ApplicationELB"
  period              = "300"
  statistic           = "Average"
  threshold           = "0"
  alarm_description   = "Alert when ALB has unhealthy targets"
  treat_missing_data  = "breaching"

  dimensions = {
    LoadBalancer = aws_lb.main.arn_suffix
  }

  tags = local.common_tags
}

# CloudWatch Alarms - High Latency
resource "aws_cloudwatch_metric_alarm" "high_latency" {
  count = var.environment == "prod" ? 1 : 0

  alarm_name          = "${var.project_name}-${var.environment}-alb-high-latency"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "TargetResponseTime"
  namespace           = "AWS/ApplicationELB"
  period              = "300"
  statistic           = "Average"
  threshold           = var.latency_threshold
  alarm_description   = "Alert when ALB response time exceeds threshold"
  treat_missing_data  = "notBreaching"

  dimensions = {
    LoadBalancer = aws_lb.main.arn_suffix
  }

  tags = local.common_tags
}
