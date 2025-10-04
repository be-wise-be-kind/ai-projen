# Deployment Guide

**Purpose**: Complete deployment guide for React-Python fullstack application to AWS

**Scope**: End-to-end deployment workflow from local development to production

**Overview**: Comprehensive guide covering infrastructure setup, application deployment, monitoring,
    and operational procedures for running the fullstack application on AWS ECS with Terraform.

**Dependencies**: Terraform infrastructure, Docker, AWS CLI, application code

**Exports**: Deployment procedures and operational runbooks

**Related**: how-to-deploy-to-aws.md, TERRAFORM_ARCHITECTURE.md

**Implementation**: Infrastructure as Code with ECS Fargate deployment

---

## Deployment Overview

The deployment workflow consists of four main phases:

1. **Infrastructure Bootstrapping** - Setup Terraform backend (one-time)
2. **Environment Provisioning** - Create VPC, ECR, ALB per environment
3. **Application Deployment** - Build, push, and deploy containers
4. **Monitoring & Operations** - CloudWatch, logging, scaling

## Prerequisites

- AWS account with appropriate permissions
- Docker installed and running
- AWS CLI configured
- Git repository with application code
- Terraform infrastructure files copied

## Phase 1: Infrastructure Bootstrap

**Run Once per AWS Account**:

```bash
cd infra
make -f Makefile.infra infra-bootstrap
# Enter project name, GitHub org, GitHub repo
```

Creates:
- S3 bucket: `{project}-terraform-state`
- DynamoDB table: `{project}-terraform-locks`
- GitHub OIDC provider for CI/CD
- IAM role for GitHub Actions

## Phase 2: Environment Provisioning

### Development Environment

```bash
# Initialize
make -f Makefile.infra infra-init ENV=dev

# Plan changes
make -f Makefile.infra infra-plan ENV=dev

# Apply infrastructure
make -f Makefile.infra infra-apply ENV=dev
```

### Staging Environment

```bash
make -f Makefile.infra infra-init ENV=staging
make -f Makefile.infra infra-plan ENV=staging
make -f Makefile.infra infra-apply ENV=staging
```

### Production Environment

```bash
make -f Makefile.infra infra-init ENV=prod
make -f Makefile.infra infra-plan ENV=prod
make -f Makefile.infra infra-apply ENV=prod
```

## Phase 3: Application Deployment

### Step 1: Build Docker Images

```bash
# Backend
cd backend
docker build -t my-backend:latest .

# Frontend
cd ../frontend
docker build -t my-frontend:latest .
```

### Step 2: Push to ECR

```bash
# Get ECR URLs
ECR_BACKEND=$(aws ecr describe-repositories --repository-names my-app-dev-backend --query 'repositories[0].repositoryUri' --output text)
ECR_FRONTEND=$(aws ecr describe-repositories --repository-names my-app-dev-frontend --query 'repositories[0].repositoryUri' --output text)

# Login to ECR
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin $ECR_BACKEND

# Tag and push backend
docker tag my-backend:latest $ECR_BACKEND:latest
docker push $ECR_BACKEND:latest

# Tag and push frontend
docker tag my-frontend:latest $ECR_FRONTEND:latest
docker push $ECR_FRONTEND:latest
```

### Step 3: Deploy ECS Services

Use the ECS module to deploy services:

```bash
# See how-to-deploy-to-aws.md for complete ECS deployment steps
```

## Phase 4: Monitoring & Operations

### CloudWatch Logs

```bash
# View backend logs
aws logs tail /ecs/my-app-dev/backend --follow

# View frontend logs
aws logs tail /ecs/my-app-dev/frontend --follow
```

### Scaling Operations

```bash
# Update desired count
aws ecs update-service \
  --cluster my-app-dev \
  --service backend \
  --desired-count 4
```

### Rolling Updates

```bash
# Update task definition with new image
# ECS will perform rolling update automatically
```

## Deployment Checklist

### Pre-Deployment
- [ ] Terraform infrastructure applied
- [ ] ECR repositories created
- [ ] Docker images built and tested locally
- [ ] Environment variables configured
- [ ] Database migrations prepared

### Deployment
- [ ] Images pushed to ECR
- [ ] ECS task definitions updated
- [ ] Services deployed or updated
- [ ] Health checks passing
- [ ] ALB routing configured

### Post-Deployment
- [ ] Application accessible via ALB DNS
- [ ] Logs flowing to CloudWatch
- [ ] Metrics visible in Container Insights
- [ ] Auto-scaling policies active
- [ ] Monitoring alarms configured

## Rollback Procedures

### Rollback ECS Service

```bash
# Revert to previous task definition
aws ecs update-service \
  --cluster my-app-dev \
  --service backend \
  --task-definition my-app-dev-backend:123  # Previous revision
```

### Rollback Infrastructure

```bash
# Use S3 state versioning
aws s3api list-object-versions \
  --bucket my-app-terraform-state \
  --prefix dev/terraform.tfstate

# Restore previous version
aws s3api get-object \
  --bucket my-app-terraform-state \
  --key dev/terraform.tfstate \
  --version-id <VERSION_ID> \
  terraform.tfstate.backup
```

## Troubleshooting

### ECS Task Won't Start

1. Check CloudWatch logs for errors
2. Verify IAM role permissions
3. Check security group rules
4. Validate task definition

### ALB Health Checks Failing

1. Verify health endpoint exists
2. Check security group allows ALB → ECS
3. Validate health check path and port
4. Review application logs

### High Latency

1. Check ECS task CPU/memory utilization
2. Review RDS performance metrics
3. Verify auto-scaling policies
4. Check NAT Gateway bandwidth

## Best Practices

1. **Blue/Green Deployments**: Use ECS blue/green for zero downtime
2. **Automated Rollbacks**: Configure CloudWatch alarms for auto-rollback
3. **Secrets Management**: Use AWS Secrets Manager for sensitive data
4. **Tagging Strategy**: Tag all resources for cost allocation
5. **Backup Strategy**: Regular database backups, state file versioning
6. **Security Scanning**: Enable ECR image scanning
7. **Cost Monitoring**: Use AWS Cost Explorer and budgets
8. **Infrastructure Updates**: Always plan before apply

## Related Resources

- [How to Deploy to AWS](../howtos/react-python-fullstack/how-to-deploy-to-aws.md)
- [Terraform Architecture](TERRAFORM_ARCHITECTURE.md)
- [Infrastructure Principles](INFRASTRUCTURE_PRINCIPLES.md)
- [AWS ECS Best Practices](https://docs.aws.amazon.com/AmazonECS/latest/bestpracticesguide/)
