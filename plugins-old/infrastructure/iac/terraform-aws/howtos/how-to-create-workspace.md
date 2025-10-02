# How-To: Create a Terraform Workspace

**Purpose**: Create a new Terraform workspace for AWS infrastructure

**Scope**: Setting up VPC, ECS, or ALB workspaces from templates

**Prerequisites**:
- Terraform >= 1.0 installed
- AWS CLI configured with appropriate credentials
- S3 bucket and DynamoDB table for state management (see how-to-manage-state.md)

**Estimated Time**: 15-20 minutes

**Difficulty**: Beginner

---

## Overview

This guide walks through creating a new Terraform workspace for AWS infrastructure. Workspaces are
logical units of infrastructure that can be deployed independently. We support three workspace types:
VPC (networking), ECS (container orchestration), and ALB (load balancing).

---

## Steps

### Step 1: Choose Your Workspace Type

Decide which workspace you need:

- **VPC Workspace**: Foundation networking (VPC, subnets, security groups)
- **ECS Workspace**: Container orchestration (ECS cluster, services, tasks)
- **ALB Workspace**: Load balancing (Application Load Balancer, target groups)

**Deployment Order**: Always deploy VPC first, then ECS, then ALB.

### Step 2: Create Workspace Directory

```bash
# Create workspace directory structure
mkdir -p terraform/workspaces/<workspace-type>
cd terraform/workspaces/<workspace-type>
```

Example for VPC workspace:
```bash
mkdir -p terraform/workspaces/vpc
cd terraform/workspaces/vpc
```

### Step 3: Copy Template Files

Copy the template files from the plugin to your workspace:

**For VPC Workspace**:
```bash
cp plugins/infrastructure/iac/terraform-aws/templates/workspaces/vpc/* terraform/workspaces/vpc/
cp plugins/infrastructure/iac/terraform-aws/templates/backend.tf terraform/workspaces/vpc/
```

**For ECS Workspace**:
```bash
cp plugins/infrastructure/iac/terraform-aws/templates/workspaces/ecs/* terraform/workspaces/ecs/
cp plugins/infrastructure/iac/terraform-aws/templates/backend.tf terraform/workspaces/ecs/
```

**For ALB Workspace**:
```bash
cp plugins/infrastructure/iac/terraform-aws/templates/workspaces/alb/* terraform/workspaces/alb/
cp plugins/infrastructure/iac/terraform-aws/templates/backend.tf terraform/workspaces/alb/
```

### Step 4: Configure Backend

Edit `backend.tf` to configure your state management:

```hcl
terraform {
  backend "s3" {
    bucket         = "myproject-123456789012-terraform-state"
    key            = "vpc/dev/terraform.tfstate"  # Change based on workspace
    region         = "us-west-2"
    encrypt        = true
    dynamodb_table = "myproject-terraform-locks"
  }
}
```

**Key Paths by Workspace**:
- VPC: `vpc/${environment}/terraform.tfstate`
- ECS: `ecs/${environment}/terraform.tfstate`
- ALB: `alb/${environment}/terraform.tfstate`

### Step 5: Create terraform.tfvars

Copy the example and customize for your environment:

```bash
cp plugins/infrastructure/iac/terraform-aws/templates/terraform.tfvars.example terraform.tfvars
```

Edit `terraform.tfvars`:

**VPC Workspace**:
```hcl
project_name = "myproject"
environment  = "dev"
aws_region   = "us-west-2"

vpc_cidr = "10.0.0.0/16"
az_count = 2
app_port = 8000
```

**ECS Workspace**:
```hcl
project_name           = "myproject"
environment            = "dev"
aws_region             = "us-west-2"
terraform_state_bucket = "myproject-123456789012-terraform-state"

service_name    = "backend"
container_image = "123456789012.dkr.ecr.us-west-2.amazonaws.com/myproject-backend:latest"
container_port  = 8000
task_cpu        = "256"
task_memory     = "512"
desired_count   = 1

container_environment = [
  {
    name  = "ENVIRONMENT"
    value = "dev"
  }
]
```

**ALB Workspace**:
```hcl
project_name           = "myproject"
environment            = "dev"
aws_region             = "us-west-2"
terraform_state_bucket = "myproject-123456789012-terraform-state"

service_name      = "api"
target_port       = 8000
health_check_path = "/health"
```

### Step 6: Initialize Terraform

```bash
terraform init
```

This will:
- Download required providers
- Configure the S3 backend
- Initialize state management

**Expected Output**:
```
Terraform has been successfully initialized!
```

### Step 7: Validate Configuration

```bash
# Format code
terraform fmt

# Validate syntax
terraform validate
```

### Step 8: Review Plan

```bash
terraform plan
```

Review the planned changes carefully:
- Check resource names
- Verify CIDR blocks
- Confirm tags are correct
- Ensure security group rules are appropriate

### Step 9: Apply Configuration

```bash
# Development
terraform apply

# Staging
terraform apply -var-file=staging.tfvars

# Production
terraform apply -var-file=prod.tfvars
```

Type `yes` when prompted to confirm.

### Step 10: Verify Deployment

Check that resources were created:

**VPC Workspace**:
```bash
# List outputs
terraform output

# Check VPC
aws ec2 describe-vpcs --filters "Name=tag:Name,Values=myproject-dev-vpc"
```

**ECS Workspace**:
```bash
# List outputs
terraform output

# Check cluster
aws ecs describe-clusters --clusters myproject-dev-cluster
```

**ALB Workspace**:
```bash
# List outputs
terraform output

# Get ALB DNS name
aws elbv2 describe-load-balancers --names myproject-dev-alb
```

---

## Verification

After deployment, verify:

1. **State File Created**: Check S3 bucket for state file
2. **Lock Table**: Confirm DynamoDB lock table exists
3. **Resources Created**: Verify in AWS Console
4. **Outputs Available**: Run `terraform output` successfully
5. **Tags Applied**: Check resources have correct tags

---

## Common Issues

### Issue: Backend initialization fails

**Cause**: S3 bucket or DynamoDB table doesn't exist

**Solution**: Create backend resources first (see how-to-manage-state.md)

### Issue: VPC outputs not found in ECS workspace

**Cause**: VPC state file path incorrect in data source

**Solution**: Verify `terraform_state_bucket` and key path match VPC backend config

### Issue: Resource already exists

**Cause**: Previous deployment wasn't cleaned up

**Solution**:
```bash
terraform import aws_vpc.main vpc-xxxxx  # Import existing resource
# OR
terraform destroy  # Clean up old resources
```

### Issue: Permission denied

**Cause**: AWS credentials lack required permissions

**Solution**: Ensure IAM user/role has:
- EC2 full access (VPC)
- ECS full access (ECS)
- ElasticLoadBalancing full access (ALB)
- S3 read/write (state)
- DynamoDB read/write (locking)

---

## Next Steps

After creating your workspace:

1. **VPC Created**: Proceed to create ECS workspace
2. **ECS Created**: Proceed to create ALB workspace
3. **ALB Created**: Configure DNS and deploy applications
4. **All Workspaces Ready**: Set up CI/CD pipeline (see how-to-deploy-to-aws.md)

---

## Related Guides

- [How-To: Manage Terraform State](how-to-manage-state.md)
- [How-To: Deploy to AWS](how-to-deploy-to-aws.md)
- [Terraform Standards](../standards/TERRAFORM_STANDARDS.md)
