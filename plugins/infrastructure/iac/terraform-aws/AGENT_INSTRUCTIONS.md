# Terraform/AWS Infrastructure Plugin - AI Agent Instructions

**Purpose**: Guide AI agents in setting up Terraform/AWS infrastructure using workspace pattern

**Plugin Type**: Infrastructure as Code (IaC)

**Scope**: VPC, ECS Fargate, and Application Load Balancer infrastructure on AWS

---

## Overview

This plugin provides Terraform configurations for deploying AWS infrastructure using a workspace
pattern. Infrastructure is separated into three composable workspaces: VPC (networking), ECS
(container orchestration), and ALB (load balancing). Each workspace can be deployed independently
and workspaces reference each other via Terraform remote state.

---

## Prerequisites

Before installing this plugin, ensure:

1. **AWS Account**: Active AWS account with appropriate permissions
2. **AWS CLI**: Installed and configured (`aws configure`)
3. **Terraform**: Version >= 1.0 installed
4. **State Backend**: S3 bucket and DynamoDB table for state management (or will create during installation)

---

## Installation Steps

### Step 1: Detect Requirements

Ask the user:
1. "Do you need VPC infrastructure?" (Usually yes for new projects)
2. "Do you need ECS Fargate for container orchestration?" (Yes if using containers)
3. "Do you need an Application Load Balancer?" (Yes if web application)
4. "What AWS region?" (Default: us-west-2)
5. "What is your project name?" (Used for resource naming)

### Step 2: Create Directory Structure

```bash
mkdir -p terraform/workspaces/{vpc,ecs,alb}
```

### Step 3: Set Up State Management Backend

**Check if backend exists**:
```bash
PROJECT_NAME="<from-user>"
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
BUCKET_NAME="${PROJECT_NAME}-${AWS_ACCOUNT_ID}-terraform-state"

# Check if bucket exists
aws s3 ls s3://$BUCKET_NAME 2>/dev/null || echo "Bucket does not exist"
```

**If backend doesn't exist**, guide user through setup:
1. Reference `howtos/how-to-manage-state.md`
2. Create S3 bucket with versioning and encryption
3. Create DynamoDB table for locking
4. Verify resources created

### Step 4: Install VPC Workspace

**If user needs VPC**:

1. Copy VPC templates:
```bash
cp plugins/infrastructure/iac/terraform-aws/templates/workspaces/vpc/* terraform/workspaces/vpc/
cp plugins/infrastructure/iac/terraform-aws/templates/backend.tf terraform/workspaces/vpc/backend.tf
```

2. Configure backend.tf:
```hcl
# Edit terraform/workspaces/vpc/backend.tf
backend "s3" {
  bucket         = "<project>-<account-id>-terraform-state"
  key            = "vpc/dev/terraform.tfstate"
  region         = "<aws-region>"
  encrypt        = true
  dynamodb_table = "<project>-terraform-locks"
}
```

3. Create terraform.tfvars:
```hcl
# terraform/workspaces/vpc/terraform.tfvars
project_name = "<from-user>"
environment  = "dev"
aws_region   = "<from-user>"
vpc_cidr     = "10.0.0.0/16"
az_count     = 2
app_port     = 8000
```

4. Initialize and validate:
```bash
cd terraform/workspaces/vpc
terraform init
terraform fmt
terraform validate
terraform plan
```

5. Prompt user to review plan and apply:
```bash
terraform apply
```

6. Note VPC outputs for other workspaces:
```bash
terraform output -json > vpc_outputs.json
```

### Step 5: Install ECS Workspace

**If user needs ECS**:

1. Copy ECS templates:
```bash
cp plugins/infrastructure/iac/terraform-aws/templates/workspaces/ecs/* terraform/workspaces/ecs/
cp plugins/infrastructure/iac/terraform-aws/templates/backend.tf terraform/workspaces/ecs/backend.tf
```

2. Configure backend.tf:
```hcl
# Edit terraform/workspaces/ecs/backend.tf
backend "s3" {
  bucket         = "<project>-<account-id>-terraform-state"
  key            = "ecs/dev/terraform.tfstate"
  region         = "<aws-region>"
  encrypt        = true
  dynamodb_table = "<project>-terraform-locks"
}
```

3. Ask user for ECS configuration:
   - Service name (e.g., "backend", "api")
   - Container image (ECR URI or Docker Hub)
   - Container port
   - Task CPU and memory
   - Desired task count

4. Create terraform.tfvars:
```hcl
# terraform/workspaces/ecs/terraform.tfvars
project_name           = "<from-user>"
environment            = "dev"
aws_region             = "<from-user>"
terraform_state_bucket = "<project>-<account-id>-terraform-state"

service_name    = "<from-user>"
container_image = "<from-user>"
container_port  = <from-user>
task_cpu        = "256"
task_memory     = "512"
desired_count   = 1

container_environment = [
  {
    name  = "ENVIRONMENT"
    value = "dev"
  }
]

health_check_command = ["CMD-SHELL", "curl -f http://localhost:<port>/health || exit 1"]
```

5. Initialize and apply:
```bash
cd terraform/workspaces/ecs
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply
```

### Step 6: Install ALB Workspace

**If user needs ALB**:

1. Copy ALB templates:
```bash
cp plugins/infrastructure/iac/terraform-aws/templates/workspaces/alb/* terraform/workspaces/alb/
cp plugins/infrastructure/iac/terraform-aws/templates/backend.tf terraform/workspaces/alb/backend.tf
```

2. Configure backend.tf:
```hcl
# Edit terraform/workspaces/alb/backend.tf
backend "s3" {
  bucket         = "<project>-<account-id>-terraform-state"
  key            = "alb/dev/terraform.tfstate"
  region         = "<aws-region>"
  encrypt        = true
  dynamodb_table = "<project>-terraform-locks"
}
```

3. Create terraform.tfvars:
```hcl
# terraform/workspaces/alb/terraform.tfvars
project_name           = "<from-user>"
environment            = "dev"
aws_region             = "<from-user>"
terraform_state_bucket = "<project>-<account-id>-terraform-state"

service_name      = "<same-as-ecs>"
target_port       = <same-as-container-port>
health_check_path = "/health"

# Optional HTTPS configuration
enable_https          = false
enable_https_redirect = false
```

4. Initialize and apply:
```bash
cd terraform/workspaces/alb
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply
```

5. Get ALB DNS name:
```bash
terraform output alb_dns_name
```

### Step 7: Link ECS to ALB

**If both ECS and ALB are deployed**:

1. Get ALB target group ARN:
```bash
cd terraform/workspaces/alb
ALB_TG_ARN=$(terraform output -raw target_group_arn)
```

2. Update ECS terraform.tfvars:
```hcl
# Add to terraform/workspaces/ecs/terraform.tfvars
target_group_arn = "<alb-target-group-arn>"
```

3. Reapply ECS:
```bash
cd terraform/workspaces/ecs
terraform apply
```

### Step 8: Verify Deployment

Run verification checks:

```bash
# Test ALB endpoint
ALB_DNS=$(cd terraform/workspaces/alb && terraform output -raw alb_dns_name)
curl http://$ALB_DNS/health

# Check ECS service status
aws ecs describe-services \
  --cluster <project>-dev-cluster \
  --services <project>-dev-<service> \
  --query 'services[0].{Status:status,Running:runningCount,Desired:desiredCount}'

# Check ALB target health
aws elbv2 describe-target-health \
  --target-group-arn <target-group-arn> \
  --query 'TargetHealthDescriptions[*].TargetHealth.State'
```

---

## Post-Installation

### Update Project Documentation

Add to `.ai/index.yaml`:
```yaml
infrastructure:
  terraform:
    provider: aws
    workspaces:
      - vpc
      - ecs
      - alb
    state_backend: s3
    state_bucket: "<project>-<account-id>-terraform-state"
    state_lock_table: "<project>-terraform-locks"
```

### Provide User Guidance

Inform user about:
1. **ALB DNS name** for accessing application
2. **CloudWatch log groups** for viewing application logs
3. **State files location** in S3
4. **Next steps**: Configure DNS, enable HTTPS, set up CI/CD

### Reference Documentation

Point user to:
- `howtos/how-to-create-workspace.md` - Creating additional workspaces
- `howtos/how-to-deploy-to-aws.md` - Deployment workflows
- `howtos/how-to-manage-state.md` - State management
- `standards/TERRAFORM_STANDARDS.md` - Best practices

---

## Integration with Other Plugins

### Docker Plugin Integration

If Docker plugin is installed:
1. Build and push images to ECR before deploying ECS
2. Use ECR repository URLs in ECS configuration
3. Ensure Docker images expose correct ports

### CI/CD Plugin Integration

If GitHub Actions plugin is installed:
1. Add Terraform workflows for automated deployments
2. Use AWS credentials from GitHub secrets
3. Run `terraform plan` on PRs, `apply` on merge

### Python/TypeScript Plugin Integration

Application code should:
1. Expose health check endpoint (e.g., `/health`)
2. Listen on port specified in ECS configuration
3. Handle graceful shutdown for zero-downtime deploys

---

## Environment-Specific Configuration

### Development Environment

```hcl
environment   = "dev"
desired_count = 1
task_cpu      = "256"
task_memory   = "512"
enable_autoscaling = false
```

### Staging Environment

```hcl
environment   = "staging"
desired_count = 2
task_cpu      = "512"
task_memory   = "1024"
enable_autoscaling = false
```

### Production Environment

```hcl
environment   = "prod"
desired_count = 3
task_cpu      = "1024"
task_memory   = "2048"
enable_autoscaling = true
autoscaling_min_capacity = 2
autoscaling_max_capacity = 10
autoscaling_cpu_target   = 60.0
enable_https = true
certificate_arn = "<acm-certificate-arn>"
```

---

## Common User Questions

### Q: How much will this cost?

**A**: Development environment costs approximately:
- VPC: $0 (free tier)
- NAT Gateway: $0 (not deployed in dev)
- ECS Fargate Spot: ~$5-10/month (single task)
- ALB: ~$16/month
- **Total**: ~$20-30/month for dev

Production costs vary based on:
- Number of tasks
- Task size (CPU/memory)
- Data transfer
- Auto-scaling activity

### Q: Can I use my own VPC?

**A**: Yes. Skip VPC workspace and manually configure data sources in ECS/ALB workspaces
to reference your existing VPC ID, subnet IDs, and security group IDs.

### Q: How do I enable HTTPS?

**A**:
1. Request ACM certificate in AWS Console
2. Add certificate ARN to ALB terraform.tfvars
3. Set `enable_https = true` and `enable_https_redirect = true`
4. Reapply ALB workspace

### Q: How do I add more services?

**A**: Create additional ECS workspaces:
```bash
mkdir terraform/workspaces/ecs-frontend
# Copy templates and configure for frontend service
```

Or duplicate ECS configuration within same workspace using modules.

### Q: How do I update container images?

**A**:
1. Build and push new image to ECR
2. Update `container_image` in ecs/terraform.tfvars
3. Run `terraform apply` in ECS workspace
4. ECS performs rolling update automatically

---

## Troubleshooting

### Issue: State file not found

**Check**: Backend configuration in backend.tf matches S3 bucket/key
**Fix**: Verify bucket name and key path, run `terraform init -reconfigure`

### Issue: ECS tasks fail to start

**Check**: CloudWatch logs, task stopped reason
**Fix**: Common causes:
- Container image not found (check ECR URL)
- Health check failing (verify endpoint)
- Insufficient permissions (check IAM roles)

### Issue: ALB targets unhealthy

**Check**: Target health in AWS Console
**Fix**: Common causes:
- Security group blocking ALB → ECS traffic
- Health check path incorrect
- Application not ready (increase health check start period)

### Issue: Terraform lock timeout

**Check**: DynamoDB table for locks
**Fix**: Run `terraform force-unlock <lock-id>` if no other process running

---

## Validation Checklist

After installation, verify:

- [ ] S3 bucket exists with versioning enabled
- [ ] DynamoDB table exists for state locking
- [ ] VPC created with correct CIDR and subnets
- [ ] Security groups allow ALB → ECS traffic
- [ ] ECS cluster created and tasks running
- [ ] ALB created and targets healthy
- [ ] Health checks passing
- [ ] Application accessible via ALB DNS
- [ ] CloudWatch logs visible
- [ ] Terraform state files in S3

---

## Success Criteria

Plugin installation is successful when:

1. All requested workspaces deployed without errors
2. `terraform plan` shows no changes (infrastructure stable)
3. Application accessible via ALB DNS name
4. ECS tasks running with desired count
5. ALB health checks passing
6. CloudWatch logs showing application output
7. User can access application and verify functionality

---

## References

- Templates: `templates/workspaces/{vpc,ecs,alb}/`
- Backend template: `templates/backend.tf`
- Example variables: `templates/terraform.tfvars.example`
- Standards: `standards/TERRAFORM_STANDARDS.md`
- How-tos: `howtos/*.md`
