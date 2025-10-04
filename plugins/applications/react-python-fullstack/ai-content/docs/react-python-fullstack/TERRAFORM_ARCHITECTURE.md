# Terraform Architecture

**Purpose**: Architectural overview of the Terraform infrastructure for fullstack deployment

**Scope**: Infrastructure design, module organization, and multi-environment strategy

**Overview**: Comprehensive documentation of the Terraform infrastructure architecture including workspace
    organization, module design, networking topology, security configuration, and deployment patterns.
    Explains design decisions, resource dependencies, and best practices for managing AWS infrastructure
    for the React-Python fullstack application.

**Dependencies**: AWS provider, S3 backend, Terraform 1.5+

**Exports**: Infrastructure architecture documentation and design principles

**Related**: how-to-manage-terraform-infrastructure.md, DEPLOYMENT_GUIDE.md, INFRASTRUCTURE_PRINCIPLES.md

**Implementation**: Multi-workspace architecture with reusable modules

---

## Architecture Overview

The Terraform infrastructure uses a multi-workspace, modular architecture to support multiple environments
(dev, staging, prod) with shared code and isolated state.

### Key Design Principles

1. **Workspace Isolation** - Each environment has isolated state in S3
2. **Module Reusability** - Common patterns extracted into reusable modules
3. **Security First** - Encryption, private subnets, least privilege IAM
4. **High Availability** - Multi-AZ deployment for production workloads
5. **GitOps Ready** - GitHub OIDC for secure, keyless CI/CD

## Directory Structure

```
infra/terraform/
├── workspaces/
│   ├── bootstrap/          # S3 backend, DynamoDB, GitHub OIDC (run once)
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── base/               # VPC, ECR, ALB (per environment)
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
├── modules/
│   ├── ecs-service/        # Reusable ECS Fargate service
│   ├── rds/                # Reusable RDS PostgreSQL
│   └── alb/                # (planned) ALB configuration
├── shared/
│   └── variables.tf        # Common variable definitions
└── backend-config/
    ├── dev.tfbackend       # Dev S3 backend config
    ├── staging.tfbackend   # Staging S3 backend config
    └── prod.tfbackend      # Prod S3 backend config
```

## Workspace Architecture

### Bootstrap Workspace

**Purpose**: Create Terraform backend and GitHub OIDC provider (run once)

**Resources**:
- S3 bucket with versioning and encryption
- DynamoDB table for state locking
- GitHub OIDC provider for Actions authentication
- IAM role for GitHub Actions with deployment permissions

**State**: Stored locally (no backend) since this creates the backend

**When to Run**: Once before any other infrastructure

### Base Workspace

**Purpose**: Create core infrastructure per environment

**Resources**:
- VPC with public and private subnets (2 AZs)
- Internet Gateway and NAT Gateways (1 per AZ)
- ECR repositories (backend + frontend)
- Application Load Balancer with target groups
- Security groups (ALB, ECS tasks)

**State**: Stored in S3 at `{env}/terraform.tfstate`

**Workspaces**: dev, staging, prod (isolated state)

## Network Architecture

### VPC Design

```
VPC: 10.0.0.0/16

├── Public Subnets (2)
│   ├── us-east-1a: 10.0.0.0/20    (4,096 IPs)
│   └── us-east-1b: 10.0.16.0/20   (4,096 IPs)
│
└── Private Subnets (2)
    ├── us-east-1a: 10.0.128.0/20  (4,096 IPs)
    └── us-east-1b: 10.0.144.0/20  (4,096 IPs)
```

### Traffic Flow

1. **Internet → ALB** (public subnets)
2. **ALB → ECS Tasks** (private subnets)
3. **ECS Tasks → Internet** (via NAT Gateways)
4. **ECS Tasks → RDS** (private subnets, isolated)

### Security Groups

- **ALB Security Group**: Allows 80, 443 from 0.0.0.0/0
- **ECS Tasks Security Group**: Allows all from ALB security group
- **RDS Security Group**: Allows 5432 from ECS tasks security group

## Module Architecture

### ECS Service Module

**Purpose**: Deploy Fargate services with auto-scaling

**Inputs**:
- `cluster_name`, `service_name`
- `container_image`, `container_port`
- `task_cpu`, `task_memory`
- `desired_count`, `min_capacity`, `max_capacity`
- `private_subnet_ids`, `security_group_id`
- `target_group_arn`

**Resources Created**:
- ECS Cluster with Container Insights
- ECS Task Definition
- ECS Service (Fargate)
- IAM roles (execution + task)
- CloudWatch Log Group
- Auto-scaling target and policies (CPU + memory)

**Outputs**:
- `cluster_id`, `cluster_arn`
- `service_name`, `service_id`
- `task_definition_arn`
- `log_group_name`

### RDS Module

**Purpose**: Deploy PostgreSQL with backups and monitoring

**Inputs**:
- `identifier`, `engine_version`, `instance_class`
- `allocated_storage`, `max_allocated_storage`
- `database_name`, `master_username`, `master_password`
- `multi_az`, `backup_retention_period`
- `vpc_id`, `subnet_ids`, `ecs_security_group_id`

**Resources Created**:
- RDS PostgreSQL instance (encrypted)
- DB subnet group
- Security group (PostgreSQL access from ECS)
- Parameter group (custom settings)
- IAM role for enhanced monitoring

**Outputs**:
- `endpoint`, `address`, `port`
- `database_name`
- `security_group_id`

## State Management

### Remote State (S3 + DynamoDB)

- **Bucket**: `{project-name}-terraform-state`
- **Encryption**: AES256 server-side encryption
- **Versioning**: Enabled for state history
- **Locking**: DynamoDB table prevents concurrent modifications
- **State Keys**:
  - `dev/terraform.tfstate`
  - `staging/terraform.tfstate`
  - `prod/terraform.tfstate`

### Workspace Strategy

Each environment uses a separate Terraform workspace with isolated state:

- **dev**: Development environment, no deletion protection
- **staging**: Pre-production environment, mirrors prod
- **prod**: Production environment, deletion protection enabled

## CI/CD Integration

### GitHub OIDC Authentication

- **Provider**: GitHub Actions OIDC (no static credentials)
- **Trust Policy**: Scoped to specific repo and branches
- **Permissions**: Full ECS, ECR, EC2, RDS, ALB access
- **Session Duration**: Short-lived tokens (1 hour)

### Deployment Workflow

1. GitHub Actions authenticates via OIDC
2. Assumes IAM role with deployment permissions
3. Runs Terraform plan
4. Applies approved changes
5. Updates ECS services with new images

## Resource Dependencies

### Bootstrap → Base

1. Bootstrap creates S3 bucket and DynamoDB table
2. Base uses S3 backend for state storage
3. Base references GitHub OIDC role for CI/CD

### Base → Application

1. Base creates VPC, subnets, security groups
2. Base creates ECR repositories and ALB
3. Application modules use base outputs:
   - VPC ID, subnet IDs
   - Security group IDs
   - ECR repository URLs
   - ALB target group ARNs

## Security Considerations

1. **Encryption at Rest**: All data encrypted (S3, RDS, EBS)
2. **Encryption in Transit**: HTTPS for ALB, TLS for RDS
3. **Network Segmentation**: Public/private subnet separation
4. **Least Privilege IAM**: Minimal permissions per role
5. **Secrets Management**: Use AWS Secrets Manager or Parameter Store
6. **No Hardcoded Credentials**: OIDC for GitHub Actions

## Scalability

### Horizontal Scaling

- **ECS Auto-scaling**: CPU/memory-based scaling (1-10 tasks)
- **ALB**: Automatic scaling for traffic distribution
- **Multi-AZ**: High availability across availability zones

### Vertical Scaling

- **RDS**: Instance class upgrades (db.t3.micro → db.r6g.large)
- **ECS Tasks**: CPU/memory adjustments (256 → 4096)

## Cost Optimization

1. **Right-Sizing**: Use appropriate instance sizes per environment
2. **NAT Gateway**: Single NAT per AZ in dev, multi-AZ in prod
3. **RDS**: db.t3.micro for dev, larger for prod
4. **Auto-scaling**: Scale down during low traffic
5. **ECR Lifecycle**: Keep only 10 recent images

## Disaster Recovery

1. **S3 State Versioning**: Recover previous state versions
2. **RDS Automated Backups**: 7-day retention (configurable)
3. **Multi-AZ RDS**: Automatic failover in prod
4. **Infrastructure as Code**: Rebuild from Terraform
5. **ECR Image Retention**: Multiple tagged versions

## Monitoring

1. **CloudWatch Container Insights**: ECS metrics
2. **CloudWatch Logs**: Application and system logs
3. **RDS Enhanced Monitoring**: 60-second granularity
4. **ALB Access Logs**: Request logging to S3
5. **CloudWatch Alarms**: Auto-scaling triggers

## Future Enhancements

- [ ] Add AWS WAF for ALB security
- [ ] Implement CloudFront CDN
- [ ] Add Route53 DNS management
- [ ] Implement ACM certificate automation
- [ ] Add VPN/PrivateLink for database access
- [ ] Implement blue/green deployment
- [ ] Add cost allocation tags
- [ ] Implement GuardDuty threat detection
