# How to Deploy Full-Stack App to AWS

**Purpose**: Complete guide for deploying React + Python full-stack application to AWS with Terraform

**Scope**: Production deployment to AWS ECS with RDS, ALB, VPC, CI/CD pipeline, and monitoring

**Overview**: Step-by-step walkthrough for deploying the full-stack application to AWS production environment
    using Terraform for infrastructure as code, GitHub Actions for CI/CD, ECS for container orchestration,
    RDS for PostgreSQL database, ALB for load balancing, and CloudWatch for monitoring. Covers environment
    configuration, secrets management, database migrations, zero-downtime deployments, and rollback procedures.

**Prerequisites**: AWS account, AWS CLI configured, Terraform installed, GitHub repository

**Estimated Time**: 60-90 minutes

---

## What You'll Deploy

- **Backend**: ECS Fargate containers with auto-scaling
- **Frontend**: S3 + CloudFront (or ECS for SSR)
- **Database**: RDS PostgreSQL with automated backups
- **Load Balancer**: Application Load Balancer with SSL
- **CI/CD**: GitHub Actions automated deployment
- **Monitoring**: CloudWatch logs and metrics
- **Secrets**: AWS Secrets Manager

## Prerequisites

- AWS account with appropriate permissions
- AWS CLI installed and configured: `aws configure`
- Terraform installed: `terraform --version`
- Domain name (optional, for custom domain)
- GitHub repository with application code

## Architecture Overview

```
Internet
   │
   ▼
Route 53 (DNS)
   │
   ▼
CloudFront (CDN) ──► S3 (Frontend Static Files)
   │
   ▼
Application Load Balancer (ALB) - HTTPS
   │
   ├──► ECS Service (Backend Containers)
   │       ├─ Task 1 (Fargate)
   │       └─ Task 2 (Fargate)
   │
   └──► Target Group
           │
           ▼
   RDS PostgreSQL (Private Subnet)
```

## Step 1: Prepare AWS Account

```bash
# Install AWS CLI
pip install awscli

# Configure AWS credentials
aws configure
# Enter: Access Key ID, Secret Access Key, Region (us-east-1), Output format (json)

# Verify access
aws sts get-caller-identity

# Install Terraform
# macOS: brew install terraform
# Linux: Download from terraform.io
# Verify: terraform --version
```

## Step 2: Set Up Terraform Configuration

Create Terraform files in `terraform/` directory:

**File**: `terraform/main.tf`

```hcl
# Purpose: Main Terraform configuration for AWS full-stack infrastructure
# Scope: Complete AWS infrastructure for production deployment
# Overview: Defines AWS resources for ECS cluster, RDS database, ALB, VPC, security groups,
#     CloudWatch logging, and secrets management. Provisions complete production environment
#     with high availability, auto-scaling, and monitoring.
# Dependencies: AWS provider, Terraform 1.5+
# Exports: Infrastructure outputs (ALB DNS, ECS cluster ARN, RDS endpoint)
# Environment: Production AWS environment

terraform {
  required_version = ">= 1.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # Backend for state storage (configure after initial setup)
  backend "s3" {
    bucket         = "your-terraform-state-bucket"
    key            = "fullstack-app/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-state-lock"
  }
}

provider "aws" {
  region = var.aws_region
}

# VPC and Networking
module "vpc" {
  source = "./modules/vpc"

  project_name = var.project_name
  environment  = var.environment
  vpc_cidr     = var.vpc_cidr
}

# ECS Cluster
module "ecs" {
  source = "./modules/ecs"

  project_name = var.project_name
  environment  = var.environment
  vpc_id       = module.vpc.vpc_id
  subnet_ids   = module.vpc.private_subnet_ids
  alb_security_group_id = module.alb.security_group_id

  backend_image = var.backend_docker_image
  backend_port  = 8000
  cpu           = 512
  memory        = 1024
  desired_count = 2
}

# Application Load Balancer
module "alb" {
  source = "./modules/alb"

  project_name = var.project_name
  environment  = var.environment
  vpc_id       = module.vpc.vpc_id
  subnet_ids   = module.vpc.public_subnet_ids

  certificate_arn = var.certificate_arn  # Optional: for HTTPS
}

# RDS Database
module "rds" {
  source = "./modules/rds"

  project_name = var.project_name
  environment  = var.environment
  vpc_id       = module.vpc.vpc_id
  subnet_ids   = module.vpc.private_subnet_ids

  database_name = var.database_name
  username      = var.database_username
  instance_class = "db.t3.micro"
  allocated_storage = 20
}

# Outputs
output "alb_dns_name" {
  value       = module.alb.dns_name
  description = "DNS name of the load balancer"
}

output "rds_endpoint" {
  value       = module.rds.endpoint
  description = "RDS database endpoint"
}
```

**File**: `terraform/variables.tf`

```hcl
variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name for resource naming"
  type        = string
  default     = "fullstack-app"
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "prod"
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
  default     = "10.0.0.0/16"
}

variable "backend_docker_image" {
  description = "Docker image for backend"
  type        = string
}

variable "database_name" {
  description = "RDS database name"
  type        = string
  default     = "app_db"
}

variable "database_username" {
  description = "RDS master username"
  type        = string
  default     = "postgres"
}

variable "certificate_arn" {
  description = "ARN of ACM certificate for HTTPS"
  type        = string
  default     = ""
}
```

## Step 3: Create ECS Task Definition

**File**: `terraform/ecs_task_definition.json`

```json
{
  "family": "fullstack-backend",
  "networkMode": "awsvpc",
  "requiresCompatibilities": ["FARGATE"],
  "cpu": "512",
  "memory": "1024",
  "containerDefinitions": [
    {
      "name": "backend",
      "image": "${backend_image}",
      "essential": true,
      "portMappings": [
        {
          "containerPort": 8000,
          "protocol": "tcp"
        }
      ],
      "environment": [
        {
          "name": "ENVIRONMENT",
          "value": "production"
        }
      ],
      "secrets": [
        {
          "name": "DATABASE_URL",
          "valueFrom": "${database_url_secret_arn}"
        },
        {
          "name": "SECRET_KEY",
          "valueFrom": "${secret_key_secret_arn}"
        }
      ],
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "/ecs/fullstack-backend",
          "awslogs-region": "us-east-1",
          "awslogs-stream-prefix": "backend"
        }
      },
      "healthCheck": {
        "command": ["CMD-SHELL", "curl -f http://localhost:8000/health || exit 1"],
        "interval": 30,
        "timeout": 5,
        "retries": 3,
        "startPeriod": 60
      }
    }
  ]
}
```

## Step 4: Set Up GitHub Actions CI/CD

**File**: `.github/workflows/deploy.yml`

```yaml
# Purpose: CI/CD pipeline for automated testing and deployment to AWS
# Scope: Build, test, and deploy full-stack application to production
# Overview: Automated workflow that runs on push to main branch, executes tests, builds
#     Docker images, pushes to ECR, and deploys to ECS with zero-downtime rolling update.
# Dependencies: GitHub Actions, AWS credentials, Docker, Terraform
# Environment: Production AWS deployment

name: Deploy to AWS

on:
  push:
    branches: [main]
  workflow_dispatch:

env:
  AWS_REGION: us-east-1
  ECR_REPOSITORY: fullstack-backend

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - name: Run backend tests
        run: |
          cd backend
          docker-compose run backend pytest

      - name: Run frontend tests
        run: |
          cd frontend
          npm install
          npm test

  build-and-deploy:
    needs: test
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - name: Configure AWS credentials
        uses: aws-actions/configure-aws-credentials@v2
        with:
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          aws-region: ${{ env.AWS_REGION }}

      - name: Login to Amazon ECR
        id: login-ecr
        uses: aws-actions/amazon-ecr-login@v1

      - name: Build, tag, and push backend image to ECR
        env:
          ECR_REGISTRY: ${{ steps.login-ecr.outputs.registry }}
          IMAGE_TAG: ${{ github.sha }}
        run: |
          docker build -t $ECR_REGISTRY/$ECR_REPOSITORY:$IMAGE_TAG -f backend/Dockerfile backend/
          docker push $ECR_REGISTRY/$ECR_REPOSITORY:$IMAGE_TAG
          docker tag $ECR_REGISTRY/$ECR_REPOSITORY:$IMAGE_TAG $ECR_REGISTRY/$ECR_REPOSITORY:latest
          docker push $ECR_REGISTRY/$ECR_REPOSITORY:latest

      - name: Run database migrations
        env:
          DATABASE_URL: ${{ secrets.PRODUCTION_DATABASE_URL }}
        run: |
          docker run --rm \
            -e DATABASE_URL=$DATABASE_URL \
            ${{ steps.login-ecr.outputs.registry }}/$ECR_REPOSITORY:${{ github.sha }} \
            alembic upgrade head

      - name: Deploy to ECS
        run: |
          aws ecs update-service \
            --cluster fullstack-app-prod \
            --service backend-service \
            --force-new-deployment \
            --region ${{ env.AWS_REGION }}

      - name: Wait for deployment
        run: |
          aws ecs wait services-stable \
            --cluster fullstack-app-prod \
            --services backend-service \
            --region ${{ env.AWS_REGION }}
```

## Step 5: Configure Secrets

### AWS Secrets Manager

```bash
# Create database URL secret
aws secretsmanager create-secret \
  --name fullstack-app/database-url \
  --description "Database connection string" \
  --secret-string "postgresql://username:password@rds-endpoint:5432/app_db"

# Create application secret key
aws secretsmanager create-secret \
  --name fullstack-app/secret-key \
  --description "Application secret key" \
  --secret-string "your-super-secret-key-here"

# Get secret ARNs for ECS task definition
aws secretsmanager describe-secret --secret-id fullstack-app/database-url --query ARN
```

### GitHub Secrets

Add these secrets to GitHub repository (Settings → Secrets and variables → Actions):

- `AWS_ACCESS_KEY_ID`: AWS access key for deployment
- `AWS_SECRET_ACCESS_KEY`: AWS secret key for deployment
- `PRODUCTION_DATABASE_URL`: Database URL for migrations

## Step 6: Deploy Infrastructure

```bash
# Navigate to terraform directory
cd terraform

# Initialize Terraform
terraform init

# Preview changes
terraform plan -var="backend_docker_image=YOUR_ECR_IMAGE_URI"

# Apply infrastructure
terraform apply -var="backend_docker_image=YOUR_ECR_IMAGE_URI"

# Note the outputs (ALB DNS, RDS endpoint)
```

## Step 7: Deploy Application

```bash
# Push code to main branch
git add .
git commit -m "Deploy to production"
git push origin main

# GitHub Actions will automatically:
# 1. Run tests
# 2. Build Docker images
# 3. Push to ECR
# 4. Run database migrations
# 5. Deploy to ECS
# 6. Wait for healthy deployment

# Monitor deployment
# Visit: https://github.com/YOUR_USERNAME/YOUR_REPO/actions
```

## Step 8: Configure Domain (Optional)

```bash
# Create Route 53 hosted zone
aws route53 create-hosted-zone --name yourdomain.com --caller-reference $(date +%s)

# Request SSL certificate
aws acm request-certificate \
  --domain-name yourdomain.com \
  --subject-alternative-names www.yourdomain.com \
  --validation-method DNS

# Create A record pointing to ALB
# (Use Route 53 console or CLI)
```

## Step 9: Verify Deployment

```bash
# Get ALB DNS name
terraform output alb_dns_name

# Test health endpoint
curl https://YOUR_ALB_DNS/health

# Check ECS tasks are running
aws ecs list-tasks --cluster fullstack-app-prod --service-name backend-service

# View CloudWatch logs
aws logs tail /ecs/fullstack-backend --follow
```

## Monitoring and Maintenance

### CloudWatch Alarms

```bash
# Create CPU alarm
aws cloudwatch put-metric-alarm \
  --alarm-name backend-high-cpu \
  --alarm-description "Alert when CPU exceeds 80%" \
  --metric-name CPUUtilization \
  --namespace AWS/ECS \
  --statistic Average \
  --period 300 \
  --threshold 80 \
  --comparison-operator GreaterThanThreshold \
  --evaluation-periods 2
```

### View Logs

```bash
# Backend logs
aws logs tail /ecs/fullstack-backend --follow

# Database logs
aws rds describe-db-log-files --db-instance-identifier fullstack-app-prod-db
```

### Scaling

```bash
# Manual scaling
aws ecs update-service \
  --cluster fullstack-app-prod \
  --service backend-service \
  --desired-count 4

# Auto-scaling (configured in Terraform)
# Will automatically scale based on CPU/memory metrics
```

## Rollback Procedure

```bash
# List previous task definitions
aws ecs list-task-definitions --family-prefix fullstack-backend

# Update service to previous version
aws ecs update-service \
  --cluster fullstack-app-prod \
  --service backend-service \
  --task-definition fullstack-backend:PREVIOUS_VERSION

# Or use git to rollback code and re-deploy
git revert HEAD
git push origin main
```

## Cost Optimization

- **ECS Fargate**: ~$30-50/month for 2 tasks
- **RDS t3.micro**: ~$15/month
- **ALB**: ~$20/month
- **Data transfer**: Variable
- **Total**: ~$65-85/month for small application

**Tips**:
- Use Fargate Spot for non-critical environments
- Enable RDS automated backups retention (7 days)
- Use S3 lifecycle policies for log retention
- Monitor with AWS Cost Explorer

## Troubleshooting

### Deployment Fails

```bash
# Check ECS service events
aws ecs describe-services \
  --cluster fullstack-app-prod \
  --services backend-service

# Check task status
aws ecs describe-tasks \
  --cluster fullstack-app-prod \
  --tasks TASK_ARN
```

### Database Connection Issues

- Verify security groups allow ECS → RDS traffic
- Check DATABASE_URL secret is correct
- Verify RDS instance is in private subnet
- Check VPC routing and NAT gateway

### SSL Certificate Issues

- Ensure domain DNS points to ALB
- Wait for certificate validation (can take minutes)
- Check ACM certificate status

## Validation

✅ **Success Criteria**:
- [ ] Terraform infrastructure deployed successfully
- [ ] ECS tasks running and healthy
- [ ] RDS database accessible from ECS
- [ ] ALB health checks passing
- [ ] Application accessible via ALB DNS
- [ ] GitHub Actions pipeline working
- [ ] Database migrations run successfully
- [ ] CloudWatch logs collecting data
- [ ] Secrets stored in Secrets Manager
- [ ] Monitoring alarms configured

## Next Steps

1. **Custom domain**: Configure Route 53 and SSL certificate
2. **Frontend deployment**: Deploy React app to S3 + CloudFront
3. **Monitoring**: Set up CloudWatch dashboards and alerts
4. **Backups**: Configure RDS automated backups
5. **DR plan**: Document disaster recovery procedures
6. **Performance testing**: Load test the deployment
7. **Cost optimization**: Review and optimize AWS resources

---

**Congratulations!** Your full-stack application is now running in production on AWS with automated CI/CD!
