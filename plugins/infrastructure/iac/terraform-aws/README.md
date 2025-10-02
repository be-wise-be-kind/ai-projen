# Terraform/AWS Infrastructure Plugin

**Purpose**: Deploy AWS infrastructure using Terraform with workspace pattern

**Provider**: AWS (Amazon Web Services)

**Infrastructure Components**: VPC, ECS Fargate, Application Load Balancer

---

## Overview

This plugin provides production-ready Terraform configurations for deploying AWS infrastructure
using a workspace pattern. Infrastructure is separated into three composable workspaces that can
be deployed independently and reference each other via Terraform remote state.

### Workspace Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                         AWS Cloud                            │
│                                                              │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  VPC Workspace (Persistent Networking)              │   │
│  │  ├── VPC (10.0.0.0/16)                              │   │
│  │  ├── Public Subnets (Multi-AZ)                      │   │
│  │  ├── Private Subnets (Multi-AZ)                     │   │
│  │  ├── Internet Gateway                               │   │
│  │  ├── Route Tables                                   │   │
│  │  └── Security Groups (ALB, ECS Tasks)               │   │
│  └─────────────────────────────────────────────────────┘   │
│           ▲                            ▲                     │
│           │                            │                     │
│  ┌────────┴───────────┐    ┌──────────┴──────────┐         │
│  │  ECS Workspace     │    │  ALB Workspace      │         │
│  │  ├── ECS Cluster   │    │  ├── Load Balancer  │         │
│  │  ├── Task Defs     │◄───┤  ├── Target Groups  │         │
│  │  ├── Services      │    │  ├── Listeners      │         │
│  │  ├── Auto-Scaling  │    │  └── Health Checks  │         │
│  │  └── CloudWatch    │    └─────────────────────┘         │
│  └────────────────────┘                                     │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## Features

### VPC Workspace
- Multi-AZ VPC with configurable CIDR block
- Public and private subnets across availability zones
- Internet gateway for public internet access
- Route tables with proper routing
- Security groups for ALB and ECS tasks
- Cost-optimized (NAT gateways optional)

### ECS Workspace
- ECS Fargate cluster for serverless containers
- Task definitions with resource allocation
- ECS services with rolling deployments
- Auto-scaling policies (production)
- CloudWatch log groups
- IAM roles with least-privilege access
- Fargate Spot for dev (70% cost savings)
- Health checks and circuit breakers

### ALB Workspace
- Application Load Balancer for traffic distribution
- Target groups with health checks
- HTTP and HTTPS listeners
- Path-based routing rules
- CloudWatch alarms for monitoring
- Sticky sessions support
- HTTPS termination with ACM certificates

---

## Prerequisites

- **Terraform**: >= 1.0
- **AWS CLI**: Configured with credentials
- **AWS Account**: With appropriate IAM permissions
- **State Backend**: S3 bucket and DynamoDB table (setup instructions provided)

---

## Quick Start

### 1. Set Up State Management

Create S3 bucket and DynamoDB table for Terraform state:

```bash
PROJECT_NAME="myproject"
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
BUCKET_NAME="${PROJECT_NAME}-${AWS_ACCOUNT_ID}-terraform-state"

# Create S3 bucket
aws s3api create-bucket --bucket $BUCKET_NAME --region us-west-2

# Enable versioning
aws s3api put-bucket-versioning --bucket $BUCKET_NAME \
  --versioning-configuration Status=Enabled

# Create DynamoDB table
aws dynamodb create-table --table-name ${PROJECT_NAME}-terraform-locks \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST
```

See [How-To: Manage State](howtos/how-to-manage-state.md) for detailed setup.

### 2. Deploy VPC Workspace

```bash
# Create directory
mkdir -p terraform/workspaces/vpc

# Copy templates
cp plugins/infrastructure/iac/terraform-aws/templates/workspaces/vpc/* terraform/workspaces/vpc/
cp plugins/infrastructure/iac/terraform-aws/templates/backend.tf terraform/workspaces/vpc/

# Configure backend.tf and terraform.tfvars
cd terraform/workspaces/vpc

# Initialize and apply
terraform init
terraform apply
```

### 3. Deploy ECS Workspace

```bash
# Create directory
mkdir -p terraform/workspaces/ecs

# Copy templates
cp plugins/infrastructure/iac/terraform-aws/templates/workspaces/ecs/* terraform/workspaces/ecs/
cp plugins/infrastructure/iac/terraform-aws/templates/backend.tf terraform/workspaces/ecs/

# Configure and apply
cd terraform/workspaces/ecs
terraform init
terraform apply
```

### 4. Deploy ALB Workspace

```bash
# Create directory
mkdir -p terraform/workspaces/alb

# Copy templates
cp plugins/infrastructure/iac/terraform-aws/templates/workspaces/alb/* terraform/workspaces/alb/
cp plugins/infrastructure/iac/terraform-aws/templates/backend.tf terraform/workspaces/alb/

# Configure and apply
cd terraform/workspaces/alb
terraform init
terraform apply

# Get ALB DNS name
terraform output alb_dns_name
```

---

## Workspace Structure

```
terraform/
├── workspaces/
│   ├── vpc/
│   │   ├── main.tf           # VPC, subnets, security groups
│   │   ├── variables.tf      # Input variables
│   │   ├── outputs.tf        # Exported values
│   │   ├── backend.tf        # S3 backend config
│   │   └── terraform.tfvars  # Variable values
│   ├── ecs/
│   │   ├── main.tf           # ECS cluster, services, tasks
│   │   ├── variables.tf      # Input variables
│   │   ├── outputs.tf        # Exported values
│   │   ├── backend.tf        # S3 backend config
│   │   └── terraform.tfvars  # Variable values
│   └── alb/
│       ├── main.tf           # ALB, target groups, listeners
│       ├── variables.tf      # Input variables
│       ├── outputs.tf        # Exported values
│       ├── backend.tf        # S3 backend config
│       └── terraform.tfvars  # Variable values
└── README.md
```

---

## Configuration

### VPC Configuration

```hcl
# terraform/workspaces/vpc/terraform.tfvars
project_name = "myproject"
environment  = "dev"
aws_region   = "us-west-2"
vpc_cidr     = "10.0.0.0/16"
az_count     = 2
app_port     = 8000
```

### ECS Configuration

```hcl
# terraform/workspaces/ecs/terraform.tfvars
project_name           = "myproject"
environment            = "dev"
aws_region             = "us-west-2"
terraform_state_bucket = "myproject-123456789012-terraform-state"

service_name    = "backend"
container_image = "nginx:latest"
container_port  = 8000
task_cpu        = "256"
task_memory     = "512"
desired_count   = 1
```

### ALB Configuration

```hcl
# terraform/workspaces/alb/terraform.tfvars
project_name           = "myproject"
environment            = "dev"
aws_region             = "us-west-2"
terraform_state_bucket = "myproject-123456789012-terraform-state"

service_name      = "api"
target_port       = 8000
health_check_path = "/health"
```

---

## Environment-Specific Deployments

### Development

```hcl
environment            = "dev"
desired_count          = 1
task_cpu               = "256"
task_memory            = "512"
enable_autoscaling     = false
```

**Cost**: ~$20-30/month

### Production

```hcl
environment            = "prod"
desired_count          = 3
task_cpu               = "1024"
task_memory            = "2048"
enable_autoscaling     = true
autoscaling_min_capacity = 2
autoscaling_max_capacity = 10
enable_https           = true
certificate_arn        = "arn:aws:acm:..."
```

**Cost**: ~$100-500/month (varies with traffic)

---

## Cost Optimization

This plugin includes several cost optimization features:

1. **Fargate Spot**: 70% savings for dev/staging (automatic fallback to Fargate if Spot unavailable)
2. **Right-Sized Tasks**: Minimal CPU/memory for development
3. **Single Instance**: `desired_count=1` for non-production
4. **No NAT Gateways**: Saves ~$32/month in development
5. **Short Log Retention**: 7 days for dev vs 30 days for prod
6. **Conditional Features**: Container Insights, auto-scaling only in production
7. **No Cross-AZ Traffic**: Disabled cross-zone load balancing

---

## Security Features

- Encryption at rest for state files (S3)
- State file versioning for disaster recovery
- State locking to prevent concurrent modifications
- Least-privilege IAM roles
- Security groups with minimal access
- Private subnets for ECS tasks
- HTTPS termination at ALB
- Health checks for zero-downtime deploys

---

## Monitoring and Observability

- CloudWatch log groups for application logs
- CloudWatch alarms for unhealthy targets (production)
- CloudWatch alarms for high latency (production)
- ECS Container Insights (production only)
- ALB access logs (production, optional)

---

## Deployment Workflow

1. **VPC First**: Deploy foundational networking
2. **ECS Second**: Deploy container orchestration
3. **ALB Third**: Deploy load balancing
4. **Link ECS to ALB**: Add target group ARN to ECS config
5. **Verify**: Test health checks and application access

**Deployment Time**: ~10-15 minutes total

---

## Common Operations

### Update Container Image

```bash
# Update terraform.tfvars
container_image = "myapp:v2"

# Apply changes
cd terraform/workspaces/ecs
terraform apply
```

ECS performs rolling update automatically.

### Scale Service

```bash
# Update terraform.tfvars
desired_count = 5

# Apply changes
cd terraform/workspaces/ecs
terraform apply
```

### Enable HTTPS

```bash
# Request ACM certificate in AWS Console
# Update terraform.tfvars
enable_https = true
certificate_arn = "arn:aws:acm:..."

# Apply changes
cd terraform/workspaces/alb
terraform apply
```

### Destroy Infrastructure

```bash
# Destroy in reverse order
cd terraform/workspaces/alb && terraform destroy
cd terraform/workspaces/ecs && terraform destroy
cd terraform/workspaces/vpc && terraform destroy
```

---

## Documentation

### How-To Guides

- [How-To: Create a Workspace](howtos/how-to-create-workspace.md) - Creating new workspaces
- [How-To: Deploy to AWS](howtos/how-to-deploy-to-aws.md) - Full deployment workflow
- [How-To: Manage State](howtos/how-to-manage-state.md) - State management setup

### Standards

- [Terraform Standards](standards/terraform-standards.md) - Best practices and conventions

### Agent Instructions

- [AGENT_INSTRUCTIONS.md](AGENT_INSTRUCTIONS.md) - For AI agents setting up infrastructure

---

## Troubleshooting

### ECS Tasks Not Starting

**Check**: CloudWatch logs and task stopped reason
```bash
aws ecs describe-tasks --cluster <cluster> --tasks <task-arn>
```

**Common Causes**:
- Container image not found (check ECR URL)
- Health check failing
- Insufficient IAM permissions

### ALB Targets Unhealthy

**Check**: Target health status
```bash
aws elbv2 describe-target-health --target-group-arn <arn>
```

**Common Causes**:
- Security group blocking traffic
- Health check path incorrect
- Application not ready

### State Lock Timeout

**Check**: DynamoDB for locks
```bash
aws dynamodb scan --table-name <project>-terraform-locks
```

**Fix**: Force unlock if no process running
```bash
terraform force-unlock <lock-id>
```

---

## Plugin Dependencies

This plugin works standalone but integrates well with:

- **Docker Plugin**: Build and push images to ECR before deploying ECS
- **GitHub Actions Plugin**: Automate Terraform deployments
- **Python/TypeScript Plugins**: Application code must expose health endpoints

---

## AWS Permissions Required

IAM user/role needs:
- EC2: Full access (VPC, subnets, security groups)
- ECS: Full access (clusters, services, tasks)
- ElasticLoadBalancing: Full access (ALB, target groups)
- IAM: Create roles and policies
- CloudWatch: Create log groups and alarms
- S3: Read/write to state bucket
- DynamoDB: Read/write to lock table

---

## Support

For issues or questions:
- Review [Terraform Standards](standards/terraform-standards.md)
- Check [How-To Guides](howtos/)
- Consult [AWS Documentation](https://docs.aws.amazon.com/)
- Review [Terraform AWS Provider Docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)

---

## License

This plugin follows the same license as the ai-projen framework.
