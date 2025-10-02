# Terraform and AWS Infrastructure Standards

**Purpose**: Standards and best practices for Terraform infrastructure code and AWS deployments

**Scope**: Terraform code organization, AWS resource configuration, security, and cost optimization

**Overview**: This document defines comprehensive standards for writing, organizing, and deploying
    Terraform infrastructure code for AWS. It covers file organization, naming conventions, variable
    management, state management, security best practices, and cost optimization strategies. These
    standards ensure consistency, maintainability, and security across all infrastructure deployments.

**Dependencies**: Terraform >= 1.0, AWS provider ~> 5.0

**Implementation**: All Terraform code must follow these standards

---

## File Organization

### Workspace Structure

```
terraform/
├── workspaces/
│   ├── vpc/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   ├── backend.tf
│   │   └── terraform.tfvars
│   ├── ecs/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   ├── backend.tf
│   │   └── terraform.tfvars
│   └── alb/
│       ├── main.tf
│       ├── variables.tf
│       ├── outputs.tf
│       ├── backend.tf
│       └── terraform.tfvars
└── README.md
```

### File Headers

Every Terraform file must include a header comment block:

```hcl
# Purpose: Brief description of what this file does
# Scope: What resources/configurations are included
# Overview: Detailed explanation of the file's role
# Dependencies: List of dependencies (other workspaces, AWS resources)
# Exports: What this file exports (outputs, resources)
# Configuration: How to configure this file
# Implementation: Key implementation details
```

### File Naming

- `main.tf` - Primary resource definitions
- `variables.tf` - Input variable definitions
- `outputs.tf` - Output value definitions
- `backend.tf` - Backend configuration
- `providers.tf` - Provider configuration (if separate from main.tf)
- `locals.tf` - Local value definitions (if many)
- `data.tf` - Data source definitions (if many)

---

## Naming Conventions

### Resources

Format: `aws_<resource_type>.<name>`

```hcl
# Good
resource "aws_vpc" "main" { }
resource "aws_subnet" "public" { }
resource "aws_security_group" "alb" { }

# Bad
resource "aws_vpc" "my_vpc" { }
resource "aws_subnet" "subnet1" { }
```

### Variables

- Use snake_case: `vpc_cidr`, `az_count`, `project_name`
- Be descriptive: `enable_nat_gateway` not `nat`
- Boolean variables: prefix with `enable_` or `use_`

```hcl
# Good
variable "vpc_cidr" { }
variable "enable_nat_gateway" { }
variable "az_count" { }

# Bad
variable "CIDR" { }
variable "nat" { }
variable "azs" { }
```

### AWS Resource Names

Format: `${project_name}-${environment}-<resource-type>`

```hcl
# Good
name = "${var.project_name}-${var.environment}-vpc"
name = "${var.project_name}-${var.environment}-alb"

# Bad
name = "my-vpc"
name = "prod_alb"
```

---

## Variable Management

### Variable Definitions

All variables must include:
- `description` - Clear description of purpose
- `type` - Explicit type constraint
- `default` - Default value (if optional)
- `validation` - Validation rules (when applicable)

```hcl
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
```

### Environment-Specific Variables

Use separate tfvars files for each environment:
- `terraform.tfvars` - Development (default)
- `staging.tfvars` - Staging
- `prod.tfvars` - Production

```bash
# Development (default)
terraform apply

# Staging
terraform apply -var-file=staging.tfvars

# Production
terraform apply -var-file=prod.tfvars
```

---

## State Management

### Backend Configuration

Always use S3 backend with DynamoDB locking:

```hcl
terraform {
  backend "s3" {
    bucket         = "project-account-terraform-state"
    key            = "vpc/dev/terraform.tfstate"
    region         = "us-west-2"
    encrypt        = true
    dynamodb_table = "project-terraform-locks"
  }
}
```

### State File Organization

Separate state files by workspace and environment:
- VPC: `vpc/${environment}/terraform.tfstate`
- ECS: `ecs/${environment}/terraform.tfstate`
- ALB: `alb/${environment}/terraform.tfstate`

### State Locking

- Always use DynamoDB for state locking
- Table must have primary key "LockID" (String type)
- Never disable locking in production

---

## Security Best Practices

### IAM Roles

- Use least-privilege access
- Separate execution and task roles
- Document required permissions

```hcl
# Task Execution Role - Used by ECS to pull images and write logs
resource "aws_iam_role" "task_execution_role" {
  name = "${var.project_name}-${var.environment}-task-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
    }]
  })
}
```

### Security Groups

- Use specific CIDR blocks, not 0.0.0.0/0 for ingress (except ALB)
- Reference security groups instead of CIDR blocks when possible
- Document all rules

```hcl
# Good - Reference security groups
ingress {
  description     = "Traffic from ALB"
  from_port       = 8000
  to_port         = 8000
  protocol        = "tcp"
  security_groups = [aws_security_group.alb.id]
}

# Bad - Open to world unnecessarily
ingress {
  from_port   = 8000
  to_port     = 8000
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}
```

### Secrets Management

- Never hardcode secrets in Terraform
- Use AWS Secrets Manager or SSM Parameter Store
- Reference secrets via data sources

```hcl
# Good
data "aws_ssm_parameter" "db_password" {
  name = "/${var.project_name}/${var.environment}/db_password"
}

# Bad
variable "db_password" {
  default = "supersecret123"
}
```

### Encryption

- Enable encryption at rest for all storage (S3, EBS, RDS)
- Use HTTPS/TLS for all data in transit
- Enable CloudTrail for audit logging

---

## Cost Optimization

### Environment-Specific Sizing

Use conditional logic for resource sizing:

```hcl
# ECS Task sizing
cpu    = var.environment == "prod" ? "1024" : "256"
memory = var.environment == "prod" ? "2048" : "512"

# Fargate Spot for dev/staging
capacity_provider = var.environment == "prod" ? "FARGATE" : "FARGATE_SPOT"

# Log retention
retention_in_days = var.environment == "prod" ? 30 : 7
```

### Resource Count

```hcl
# Multiple instances for production, single for dev
desired_count = var.environment == "prod" ? 3 : 1

# Auto-scaling only for production
count = var.environment == "prod" ? 1 : 0
```

### Optional Features

```hcl
# Container Insights only for production
setting {
  name  = "containerInsights"
  value = var.environment == "prod" ? "enabled" : "disabled"
}

# Deletion protection only for production
enable_deletion_protection = var.environment == "prod" ? true : false
```

---

## Tagging Strategy

### Required Tags

All resources must include:

```hcl
locals {
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
    Workspace   = "vpc"  # or "ecs", "alb"
  }
}

resource "aws_vpc" "main" {
  tags = merge(
    local.common_tags,
    var.additional_tags,
    {
      Name = "${var.project_name}-${var.environment}-vpc"
      Type = "networking"
    }
  )
}
```

### Tag Categories

- **Identification**: Project, Environment, Name
- **Management**: ManagedBy, Workspace
- **Organization**: Team, CostCenter, Owner
- **Technical**: Component, Service, Type

---

## Resource Organization

### Workspace Pattern

Separate infrastructure into logical workspaces:

1. **VPC Workspace** (Persistent)
   - VPC, subnets, internet gateway
   - Route tables, security groups
   - Base networking infrastructure

2. **ECS Workspace** (Application)
   - ECS cluster, task definitions, services
   - IAM roles, CloudWatch logs
   - Auto-scaling policies

3. **ALB Workspace** (Ingress)
   - Application Load Balancer
   - Target groups, listeners
   - Health checks, alarms

### Dependency Management

Reference other workspaces via remote state:

```hcl
data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = var.terraform_state_bucket
    key    = "vpc/${var.environment}/terraform.tfstate"
    region = var.aws_region
  }
}

locals {
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id
}
```

---

## Outputs

### Output Definitions

All outputs must include descriptions:

```hcl
output "vpc_id" {
  description = "VPC ID for use by other workspaces"
  value       = aws_vpc.main.id
}

output "private_subnet_ids" {
  description = "Private subnet IDs for ECS tasks"
  value       = aws_subnet.private[*].id
}
```

### What to Export

- Resource IDs (for references)
- Resource ARNs (for policies)
- DNS names (for routing)
- Configuration values (for validation)

---

## Validation and Testing

### Pre-Deployment Checks

```bash
# Format code
terraform fmt -recursive

# Validate syntax
terraform validate

# Check plan
terraform plan

# Verify state
terraform state list
```

### Variable Validation

Use validation blocks for all critical variables:

```hcl
validation {
  condition     = var.az_count >= 1 && var.az_count <= 6
  error_message = "AZ count must be between 1 and 6."
}
```

---

## Common Patterns

### Multi-AZ Resources

```hcl
resource "aws_subnet" "private" {
  count = var.az_count

  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, var.az_count + count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]
}
```

### Conditional Resources

```hcl
# Create only in production
resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  count = var.environment == "prod" ? 1 : 0
  # ...
}
```

### Dynamic Blocks

```hcl
dynamic "access_logs" {
  for_each = var.environment == "prod" ? [1] : []
  content {
    bucket  = aws_s3_bucket.alb_logs[0].bucket
    enabled = true
  }
}
```

---

## Error Handling

### Lifecycle Rules

```hcl
lifecycle {
  # Prevent accidental destruction
  prevent_destroy = true

  # Ignore external changes
  ignore_changes = [tags, desired_count]

  # Create before destroy
  create_before_destroy = true
}
```

### Timeouts

```hcl
timeouts {
  create = "10m"
  update = "10m"
  delete = "10m"
}
```

---

## Documentation

### Code Comments

- Document complex logic
- Explain non-obvious decisions
- Reference AWS documentation

```hcl
# Cost optimization: Use Fargate Spot for 70% savings in dev
# Spot interruptions are acceptable for non-production workloads
capacity_provider = var.environment == "prod" ? "FARGATE" : "FARGATE_SPOT"
```

### README Files

Each workspace should have a README:
- Purpose of the workspace
- Prerequisites
- Variables to configure
- Deployment instructions
- Troubleshooting tips

---

## Workspace Deployment Order

Always deploy in this order:

1. **VPC Workspace** - Foundation networking
2. **ECS Workspace** - Container orchestration
3. **ALB Workspace** - Load balancing and ingress

Dependencies flow downward (VPC → ECS → ALB).

---

## Continuous Integration

### Pre-commit Hooks

- `terraform fmt -check`
- `terraform validate`
- `tflint` (optional)

### CI/CD Pipeline

1. Format check
2. Validation
3. Plan generation
4. Manual approval (production)
5. Apply

---

## References

- [Terraform Best Practices](https://www.terraform.io/docs/language/index.html)
- [AWS Well-Architected Framework](https://aws.amazon.com/architecture/well-architected/)
- [Terraform AWS Provider Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
