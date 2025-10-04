# How-To: Deploy to AWS

**Purpose**: Guide for deploying fullstack application to AWS ECS using Terraform-provisioned infrastructure

**Scope**: Building Docker images, pushing to ECR, deploying ECS services, and configuring ALB

**Overview**: Complete guide for deploying the React-Python fullstack application to AWS using the
    Terraform-provisioned infrastructure. Covers Docker image building, ECR push, ECS task definitions,
    service deployment, and load balancer configuration for production-ready deployment.

**Dependencies**: Terraform infrastructure applied, Docker installed, AWS CLI configured

**Exports**: Running application on AWS ECS with ALB frontend

**Related**: how-to-manage-terraform-infrastructure.md, DEPLOYMENT_GUIDE.md

**Implementation**: Docker multi-stage builds, ECR registry, ECS Fargate deployment

**Difficulty**: advanced

**Estimated Time**: 45min

---

## Prerequisites

- [ ] Terraform base infrastructure applied (`make infra-apply ENV=dev`)
- [ ] Docker installed and running
- [ ] AWS CLI configured with credentials
- [ ] ECR login credentials obtained

**Validate Prerequisites**:
```bash
# Check infrastructure exists
aws ec2 describe-vpcs --filters "Name=tag:Project,Values=$(PROJECT_NAME)"

# Check ECR repositories
aws ecr describe-repositories --repository-names $(PROJECT_NAME)-dev-backend

# Check Docker
docker --version && docker ps
```

## Overview

Deployment workflow:
1. Build Docker images (backend + frontend)
2. Authenticate with ECR
3. Tag and push images to ECR
4. Create ECS cluster and task definitions
5. Deploy ECS services
6. Configure ALB routing
7. Verify deployment

## Steps

### Step 1: Get ECR Repository URLs

```bash
# Get ECR URLs from Terraform outputs
cd infra
ECR_BACKEND=$(make -f Makefile.infra infra-output ENV=dev | grep backend_ecr | cut -d'"' -f2)
ECR_FRONTEND=$(make -f Makefile.infra infra-output ENV=dev | grep frontend_ecr | cut -d'"' -f2)

echo "Backend ECR: $ECR_BACKEND"
echo "Frontend ECR: $ECR_FRONTEND"
```

### Step 2: Authenticate with ECR

```bash
# Login to ECR
aws ecr get-login-password --region us-east-1 | \
  docker login --username AWS --password-stdin $ECR_BACKEND

# Expected output: Login Succeeded
```

### Step 3: Build and Push Backend Image

```bash
# Build backend image
cd backend
docker build -t $(PROJECT_NAME)-backend:latest .

# Tag for ECR
docker tag $(PROJECT_NAME)-backend:latest $ECR_BACKEND:latest
docker tag $(PROJECT_NAME)-backend:latest $ECR_BACKEND:$(git rev-parse --short HEAD)

# Push to ECR
docker push $ECR_BACKEND:latest
docker push $ECR_BACKEND:$(git rev-parse --short HEAD)
```

### Step 4: Build and Push Frontend Image

```bash
# Build frontend image
cd ../frontend
docker build -t $(PROJECT_NAME)-frontend:latest .

# Tag for ECR
docker tag $(PROJECT_NAME)-frontend:latest $ECR_FRONTEND:latest
docker tag $(PROJECT_NAME)-frontend:latest $ECR_FRONTEND:$(git rev-parse --short HEAD)

# Push to ECR
docker push $ECR_FRONTEND:latest
docker push $ECR_FRONTEND:$(git rev-parse --short HEAD)
```

### Step 5: Deploy Using ECS Module

Create application workspace using the ECS service module:

```bash
cd infra/terraform
mkdir -p workspaces/app
cat > workspaces/app/main.tf <<EOF
module "backend_service" {
  source = "../../modules/ecs-service"

  aws_region         = "us-east-1"
  cluster_name       = "\${var.project_name}-\${terraform.workspace}"
  service_name       = "backend"
  container_image    = "\${var.backend_ecr_url}:latest"
  container_port     = 8000
  task_cpu           = "512"
  task_memory        = "1024"
  desired_count      = 2
  private_subnet_ids = var.private_subnet_ids
  security_group_id  = var.ecs_security_group_id
  target_group_arn   = var.backend_target_group_arn

  environment_variables = {
    DATABASE_URL = var.database_url
    ENVIRONMENT  = terraform.workspace
  }
}

module "frontend_service" {
  source = "../../modules/ecs-service"

  aws_region         = "us-east-1"
  cluster_name       = "\${var.project_name}-\${terraform.workspace}"
  service_name       = "frontend"
  container_image    = "\${var.frontend_ecr_url}:latest"
  container_port     = 80
  task_cpu           = "256"
  task_memory        = "512"
  desired_count      = 2
  private_subnet_ids = var.private_subnet_ids
  security_group_id  = var.ecs_security_group_id
  target_group_arn   = var.frontend_target_group_arn

  environment_variables = {
    API_URL     = "http://\${var.alb_dns_name}"
    ENVIRONMENT = terraform.workspace
  }
}
EOF
```

### Step 6: Apply Application Infrastructure

```bash
cd infra
make -f Makefile.infra init-app ENV=dev
make -f Makefile.infra plan-app ENV=dev
make -f Makefile.infra apply-app ENV=dev
```

### Step 7: Verify Deployment

```bash
# Check ECS services
aws ecs list-services --cluster $(PROJECT_NAME)-dev

# Check running tasks
aws ecs list-tasks --cluster $(PROJECT_NAME)-dev --service-name backend
aws ecs list-tasks --cluster $(PROJECT_NAME)-dev --service-name frontend

# Get ALB DNS
ALB_DNS=$(make -f Makefile.infra infra-output ENV=dev | grep alb_dns_name | cut -d'"' -f2)

# Test backend health
curl http://$ALB_DNS/health

# Test frontend (should return HTML)
curl http://$ALB_DNS/
```

## Verification

1. **Check ECS Cluster**: `aws ecs describe-clusters --clusters $(PROJECT_NAME)-dev`
2. **Check Services Running**: `aws ecs describe-services --cluster $(PROJECT_NAME)-dev --services backend frontend`
3. **Check Tasks**: `aws ecs list-tasks --cluster $(PROJECT_NAME)-dev`
4. **Test Application**: `curl http://$ALB_DNS/`

## Common Issues

### Issue: ECR Push Denied

**Solution**: Re-authenticate with ECR
```bash
aws ecr get-login-password --region us-east-1 | \
  docker login --username AWS --password-stdin $ECR_BACKEND
```

### Issue: ECS Task Failing to Start

**Solution**: Check CloudWatch logs
```bash
aws logs tail /ecs/$(PROJECT_NAME)-dev/backend --follow
```

### Issue: ALB Health Check Failing

**Solution**: Verify health endpoint
```bash
# SSH into task (if needed) or check logs
aws ecs execute-command --cluster $(PROJECT_NAME)-dev \
  --task <task-id> --command "/bin/sh" --interactive
```

## Best Practices

1. **Tag Images with Git SHA**: Always tag with commit hash for traceability
2. **Use Multi-Stage Builds**: Minimize image size
3. **Run Security Scans**: Use ECR image scanning
4. **Monitor Logs**: Set up CloudWatch alarms
5. **Use Blue/Green Deployment**: For zero-downtime deployments

## Checklist

- [ ] ECR repositories created
- [ ] Docker images built
- [ ] Images pushed to ECR
- [ ] ECS cluster created
- [ ] Services deployed
- [ ] Health checks passing
- [ ] ALB routing configured
- [ ] Application accessible via ALB DNS

## Related Resources

- [Terraform Architecture](../../docs/react-python-fullstack/TERRAFORM_ARCHITECTURE.md)
- [Deployment Guide](../../docs/react-python-fullstack/DEPLOYMENT_GUIDE.md)
- [AWS ECS Documentation](https://docs.aws.amazon.com/ecs/)
