# How-To: Manage Terraform Infrastructure

**Purpose**: Guide for managing AWS infrastructure using Terraform with Docker-based execution

**Scope**: Infrastructure lifecycle management, workspace operations, and state management

**Overview**: Complete guide for managing AWS infrastructure using the provided Terraform configuration
    and Makefile targets. All operations use Docker containers, eliminating the need for local Terraform
    installation. Covers bootstrap setup, multi-environment deployment, and common operational tasks.

**Dependencies**: Docker installed and running, AWS credentials configured (`~/.aws/credentials`)

**Exports**: Managed AWS infrastructure across multiple environments (dev, staging, prod)

**Related**: how-to-deploy-to-aws.md, how-to-setup-terraform-workspaces.md, TERRAFORM_ARCHITECTURE.md

**Implementation**: Docker-based Terraform execution via Makefile targets

**Difficulty**: intermediate

**Estimated Time**: 30min

---

## Prerequisites

Before managing infrastructure, ensure:

- [ ] Docker installed and running
- [ ] AWS credentials configured in `~/.aws/credentials`
- [ ] AWS CLI configured with `aws configure`
- [ ] Terraform infrastructure files copied to `infra/terraform/`
- [ ] Makefile.infra copied to `infra/Makefile.infra`

**Validate Prerequisites**:
```bash
# Check Docker
docker --version
docker ps

# Check AWS credentials
aws sts get-caller-identity

# Check infrastructure files
test -d infra/terraform/workspaces && echo "✅ Terraform files present" || echo "❌ Missing files"
test -f infra/Makefile.infra && echo "✅ Makefile present" || echo "❌ Missing Makefile"
```

## Overview

The Terraform infrastructure is organized into workspaces:

1. **Bootstrap Workspace** - Creates S3 backend, DynamoDB table, GitHub OIDC provider (run once)
2. **Base Workspace** - Creates VPC, subnets, ECR, ALB, security groups (per environment)
3. **Modules** - Reusable components for ECS services, RDS databases

All Terraform operations run via Docker using the official HashiCorp Terraform image, ensuring consistent
execution across all environments without requiring local Terraform installation.

## Steps

### Step 1: Bootstrap Terraform Backend (First Time Only)

The bootstrap workspace creates the S3 bucket and DynamoDB table for remote state storage. Run this once
before any other infrastructure operations.

```bash
cd infra
make -f Makefile.infra infra-bootstrap
```

**Interactive Prompts**:
- Project name: Enter your project name (e.g., `my-fullstack-app`)
- GitHub org/username: Your GitHub organization or username
- GitHub repository: Your repository name

**What Gets Created**:
- S3 bucket: `{project-name}-terraform-state` (versioned, encrypted)
- DynamoDB table: `{project-name}-terraform-locks` (for state locking)
- GitHub OIDC provider: For secure CI/CD authentication
- IAM role: For GitHub Actions deployments

**Expected Output**:
```
✅ Bootstrap complete!

📝 Next steps:
  1. Update backend-config files with bucket name: my-fullstack-app-terraform-state
  2. Run: make -f Makefile.infra infra-init ENV=dev

Outputs:
terraform_state_bucket = "my-fullstack-app-terraform-state"
terraform_locks_table = "my-fullstack-app-terraform-locks"
github_actions_role_arn = "arn:aws:iam::123456789012:role/my-fullstack-app-github-actions"
```

### Step 2: Update Backend Configuration Files

After bootstrap, update the backend configuration files with your actual project name.

```bash
# Replace {{PROJECT_NAME}} in all backend config files
cd infra/terraform/backend-config
sed -i 's/{{PROJECT_NAME}}/my-fullstack-app/g' *.tfbackend

# Verify changes
cat dev.tfbackend
# Should show: bucket = "my-fullstack-app-terraform-state"
```

### Step 3: Initialize Development Environment

Initialize the base workspace for the development environment.

```bash
cd infra
make -f Makefile.infra infra-init ENV=dev
```

**What This Does**:
- Configures S3 backend for dev environment state
- Downloads Terraform providers (AWS)
- Initializes workspace modules

**Expected Output**:
```
🔧 Initializing dev environment...
Terraform has been successfully initialized!
✅ dev environment initialized
```

### Step 4: Plan Infrastructure Changes

Preview what infrastructure will be created before applying.

```bash
make -f Makefile.infra infra-plan ENV=dev
```

**What This Shows**:
- VPC and subnets (public + private across 2 AZs)
- Internet Gateway and NAT Gateways
- ECR repositories (backend + frontend)
- Application Load Balancer
- Security groups
- Target groups

**Expected Output**:
```
📋 Planning dev infrastructure changes...

Terraform will perform the following actions:
  # aws_vpc.main will be created
  # aws_subnet.public[0] will be created
  # aws_subnet.public[1] will be created
  # aws_subnet.private[0] will be created
  # aws_subnet.private[1] will be created
  # ... (more resources)

Plan: 25 to add, 0 to change, 0 to destroy.
```

### Step 5: Apply Infrastructure

Apply the planned changes to create actual AWS resources.

```bash
make -f Makefile.infra infra-apply ENV=dev
```

**Confirmation Required**:
The Makefile will automatically check for a plan file. If found, it applies it.

**What Gets Created**:
- VPC with CIDR 10.0.0.0/16
- 2 public subnets (one per AZ)
- 2 private subnets (one per AZ)
- Internet Gateway
- 2 NAT Gateways (one per AZ for HA)
- ECR repositories for backend and frontend
- Application Load Balancer
- Security groups for ALB and ECS tasks
- Target groups for backend (port 8000) and frontend (port 80)

**Expected Output**:
```
🚀 Applying dev infrastructure...
Apply complete! Resources: 25 added, 0 changed, 0 destroyed.

✅ dev infrastructure applied successfully

📊 Infrastructure outputs:
alb_dns_name = "my-fullstack-app-dev-alb-123456789.us-east-1.elb.amazonaws.com"
backend_ecr_repository_url = "123456789012.dkr.ecr.us-east-1.amazonaws.com/my-fullstack-app-dev-backend"
frontend_ecr_repository_url = "123456789012.dkr.ecr.us-east-1.amazonaws.com/my-fullstack-app-dev-frontend"
vpc_id = "vpc-0123456789abcdef0"
```

### Step 6: View Infrastructure Outputs

View the outputs from the applied infrastructure.

```bash
make -f Makefile.infra infra-output ENV=dev
```

**Expected Output**:
```
📊 Outputs for dev:
alb_arn = "arn:aws:elasticloadbalancing:us-east-1:..."
alb_dns_name = "my-fullstack-app-dev-alb-123456789.us-east-1.elb.amazonaws.com"
backend_ecr_repository_url = "123456789012.dkr.ecr.us-east-1.amazonaws.com/my-fullstack-app-dev-backend"
backend_target_group_arn = "arn:aws:elasticloadbalancing:us-east-1:..."
ecs_tasks_security_group_id = "sg-0123456789abcdef0"
frontend_ecr_repository_url = "123456789012.dkr.ecr.us-east-1.amazonaws.com/my-fullstack-app-dev-frontend"
frontend_target_group_arn = "arn:aws:elasticloadbalancing:us-east-1:..."
private_subnet_ids = ["subnet-0123...", "subnet-0456..."]
public_subnet_ids = ["subnet-0789...", "subnet-0abc..."]
vpc_id = "vpc-0123456789abcdef0"
```

### Step 7: Deploy to Additional Environments

Repeat steps 3-6 for staging and production environments.

**Staging**:
```bash
make -f Makefile.infra infra-init ENV=staging
make -f Makefile.infra infra-plan ENV=staging
make -f Makefile.infra infra-apply ENV=staging
```

**Production**:
```bash
make -f Makefile.infra infra-init ENV=prod
make -f Makefile.infra infra-plan ENV=prod
make -f Makefile.infra infra-apply ENV=prod
```

### Step 8: View All Workspaces

List all Terraform workspaces to see which environments exist.

```bash
make -f Makefile.infra infra-workspaces
```

**Expected Output**:
```
📁 Available workspaces:
  default
* dev
  staging
  prod
```

The `*` indicates the currently selected workspace.

## Verification

Verify infrastructure is correctly deployed:

**1. Check VPC Created**:
```bash
aws ec2 describe-vpcs --filters "Name=tag:Project,Values=my-fullstack-app"
# Should show VPC with CIDR 10.0.0.0/16
```

**2. Check ECR Repositories**:
```bash
aws ecr describe-repositories --repository-names my-fullstack-app-dev-backend my-fullstack-app-dev-frontend
# Should show both repositories
```

**3. Check ALB**:
```bash
aws elbv2 describe-load-balancers --names my-fullstack-app-dev-alb
# Should show ALB with DNS name
```

**4. View Terraform State**:
```bash
make -f Makefile.infra infra-show
# Should display full state including all resources
```

## Common Issues

### Issue: Docker Not Running

**Symptoms**: Error "Cannot connect to the Docker daemon"

**Solution**:
```bash
# Start Docker
sudo systemctl start docker  # Linux
# OR open Docker Desktop      # macOS/Windows

# Verify
docker ps
```

### Issue: AWS Credentials Not Found

**Symptoms**: Error "Unable to locate credentials"

**Solution**:
```bash
# Configure AWS credentials
aws configure
# Enter: Access Key ID, Secret Access Key, Region, Output format

# Verify
aws sts get-caller-identity
```

### Issue: Backend Already Initialized

**Symptoms**: Error "Backend configuration changed"

**Solution**:
```bash
# Reconfigure backend
make -f Makefile.infra infra-init ENV=dev
# Terraform will detect changes and reconfigure automatically
```

### Issue: State Lock Conflict

**Symptoms**: Error "Error acquiring the state lock"

**Solution**:
```bash
# Check DynamoDB for existing locks
aws dynamodb scan --table-name my-fullstack-app-terraform-locks

# If lock is stale (>15 minutes old), force unlock (careful!)
cd infra/terraform/workspaces/base
docker run --rm -it \
  -v $(pwd):/workspace \
  -v ~/.aws:/root/.aws:ro \
  -w /workspace \
  hashicorp/terraform:1.6 force-unlock <LOCK_ID>
```

### Issue: Plan File Not Found

**Symptoms**: Error "No plan file found"

**Solution**:
```bash
# Always run plan before apply
make -f Makefile.infra infra-plan ENV=dev
make -f Makefile.infra infra-apply ENV=dev
```

## Best Practices

1. **Always Plan Before Apply**: Review changes before applying
   ```bash
   make -f Makefile.infra infra-plan ENV=dev
   # Review output carefully
   make -f Makefile.infra infra-apply ENV=dev
   ```

2. **Use Version Control**: Commit Terraform files to git
   ```bash
   git add infra/terraform/
   git commit -m "feat: Add Terraform infrastructure"
   ```

3. **Separate Environments**: Never mix dev and prod state
   ```bash
   # Each environment has isolated state
   make -f Makefile.infra infra-apply ENV=dev      # dev state
   make -f Makefile.infra infra-apply ENV=staging  # staging state
   make -f Makefile.infra infra-apply ENV=prod     # prod state
   ```

4. **Protect Production**: Enable deletion protection for prod
   ```bash
   # Production ALB has deletion protection enabled automatically
   # See: workspaces/base/main.tf - enable_deletion_protection = terraform.workspace == "prod"
   ```

5. **Regular Backups**: S3 versioning is enabled automatically
   ```bash
   # View state versions
   aws s3api list-object-versions \
     --bucket my-fullstack-app-terraform-state \
     --prefix dev/terraform.tfstate
   ```

## Checklist

- [ ] Docker installed and running
- [ ] AWS credentials configured
- [ ] Bootstrap workspace applied successfully
- [ ] Backend configuration files updated with project name
- [ ] Dev environment initialized and applied
- [ ] Infrastructure outputs verified
- [ ] Additional environments deployed (staging, prod)
- [ ] All Makefile targets tested
- [ ] Terraform state stored in S3
- [ ] State locking working via DynamoDB

## Related Resources

- [How to Deploy to AWS](how-to-deploy-to-aws.md) - Deploy applications to infrastructure
- [How to Setup Terraform Workspaces](how-to-setup-terraform-workspaces.md) - Advanced workspace management
- [Terraform Architecture](../../docs/react-python-fullstack/TERRAFORM_ARCHITECTURE.md) - Infrastructure design
- [Deployment Guide](../../docs/react-python-fullstack/DEPLOYMENT_GUIDE.md) - Complete deployment workflow
- [AWS Terraform Provider Docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs) - Official AWS provider
