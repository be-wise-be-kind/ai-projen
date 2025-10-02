# How-To: Deploy to AWS with Terraform

**Purpose**: Deploy infrastructure to AWS using Terraform workspaces

**Scope**: Full deployment workflow from initialization through production

**Prerequisites**:
- All workspaces created (VPC, ECS, ALB)
- AWS credentials configured
- Container images built and pushed to ECR
- State management configured

**Estimated Time**: 30-45 minutes (full stack)

**Difficulty**: Intermediate

---

## Overview

This guide covers the complete deployment workflow for AWS infrastructure using Terraform
workspaces. We'll deploy the VPC, ECS, and ALB workspaces in order, configure environment-
specific settings, and verify the deployment.

---

## Steps

### Step 1: Pre-Deployment Checklist

Before deploying, ensure:

- [ ] AWS credentials are configured (`aws configure`)
- [ ] AWS account ID is known
- [ ] S3 backend bucket exists
- [ ] DynamoDB lock table exists
- [ ] Container images are built (for ECS)
- [ ] ECR repositories exist (for ECS)

Verify AWS credentials:
```bash
aws sts get-caller-identity
```

### Step 2: Deploy VPC Workspace

Navigate to VPC workspace:
```bash
cd terraform/workspaces/vpc
```

Initialize (first time only):
```bash
terraform init
```

Review and apply:
```bash
# Format and validate
terraform fmt
terraform validate

# Review plan
terraform plan

# Apply
terraform apply
```

**Important**: Note the outputs - you'll need them for other workspaces:
```bash
terraform output vpc_id
terraform output private_subnet_ids
terraform output alb_security_group_id
```

**Deployment Time**: ~2-3 minutes

### Step 3: Deploy ECS Workspace

Navigate to ECS workspace:
```bash
cd ../ecs
```

**Before deploying**, ensure:
1. Container image exists in ECR
2. `terraform_state_bucket` variable matches your S3 bucket
3. VPC workspace outputs are accessible

Initialize (first time only):
```bash
terraform init
```

Review and apply:
```bash
terraform fmt
terraform validate
terraform plan
terraform apply
```

Note the target group ARN if deploying with ALB:
```bash
terraform output cluster_name
terraform output service_name
```

**Deployment Time**: ~3-5 minutes

### Step 4: Deploy ALB Workspace

Navigate to ALB workspace:
```bash
cd ../alb
```

Initialize (first time only):
```bash
terraform init
```

Review and apply:
```bash
terraform fmt
terraform validate
terraform plan
terraform apply
```

Get the ALB DNS name:
```bash
terraform output alb_dns_name
```

**Deployment Time**: ~2-3 minutes

### Step 5: Update ECS Service with Target Group

If you deployed ECS before ALB, update ECS to attach to the target group:

```bash
cd ../ecs
```

Edit `terraform.tfvars` and add:
```hcl
target_group_arn = "<alb-target-group-arn-from-step-4>"
```

Apply the update:
```bash
terraform apply
```

### Step 6: Verify Deployment

Test the full stack:

```bash
# Get ALB DNS name
cd ../alb
ALB_DNS=$(terraform output -raw alb_dns_name)

# Test HTTP endpoint
curl http://$ALB_DNS/health

# Expected: {"status": "healthy"}
```

Check AWS Console:
- **VPC**: Verify VPC, subnets, route tables, security groups
- **ECS**: Verify cluster, services, tasks are running
- **ALB**: Verify load balancer is active, targets are healthy

### Step 7: Configure DNS (Optional)

If you have a domain:

1. Get ALB DNS name and zone ID:
```bash
cd terraform/workspaces/alb
terraform output alb_dns_name
terraform output alb_zone_id
```

2. Create Route53 alias record (manual or via Terraform):
```hcl
resource "aws_route53_record" "app" {
  zone_id = var.route53_zone_id
  name    = "app.example.com"
  type    = "A"

  alias {
    name                   = data.terraform_remote_state.alb.outputs.alb_dns_name
    zone_id                = data.terraform_remote_state.alb.outputs.alb_zone_id
    evaluate_target_health = true
  }
}
```

3. Test with domain:
```bash
curl http://app.example.com/health
```

### Step 8: Environment-Specific Deployment

For staging or production, create environment-specific tfvars:

**staging.tfvars**:
```hcl
environment = "staging"
desired_count = 2
task_cpu = "512"
task_memory = "1024"
```

**prod.tfvars**:
```hcl
environment = "prod"
desired_count = 3
task_cpu = "1024"
task_memory = "2048"
enable_autoscaling = true
enable_https = true
certificate_arn = "arn:aws:acm:..."
```

Deploy to each environment:
```bash
# Staging
terraform apply -var-file=staging.tfvars

# Production (with confirmation)
terraform plan -var-file=prod.tfvars
terraform apply -var-file=prod.tfvars
```

---

## Deployment Patterns

### Blue-Green Deployment

1. Deploy new version with different task definition
2. Update ECS service with new task definition
3. Monitor health checks
4. Roll back if issues detected

```bash
# Deploy new version
terraform apply -var="container_image=myapp:v2"

# ECS automatically performs rolling update
# Monitor in AWS Console or CLI
aws ecs describe-services --cluster myproject-dev-cluster --services myproject-dev-backend
```

### Canary Deployment

Use ECS deployment configuration:

```hcl
deployment_configuration {
  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 100
}
```

### Zero-Downtime Updates

1. Ensure `deployment_minimum_healthy_percent = 100`
2. Set `desired_count >= 2` in production
3. Use health checks to prevent unhealthy deployments
4. Enable circuit breaker for automatic rollback

---

## Monitoring and Validation

### Check ECS Service Health

```bash
aws ecs describe-services \
  --cluster myproject-dev-cluster \
  --services myproject-dev-backend \
  --query 'services[0].{Status:status,Running:runningCount,Desired:desiredCount}'
```

### Check ALB Target Health

```bash
aws elbv2 describe-target-health \
  --target-group-arn <target-group-arn> \
  --query 'TargetHealthDescriptions[*].{Target:Target.Id,Health:TargetHealth.State}'
```

### View CloudWatch Logs

```bash
aws logs tail /ecs/myproject-dev/backend --follow
```

### Check Auto-Scaling (Production)

```bash
aws application-autoscaling describe-scalable-targets \
  --service-namespace ecs \
  --resource-ids service/myproject-prod-cluster/myproject-prod-backend
```

---

## Verification

After deployment, verify:

1. **VPC**: All subnets in different AZs
2. **Security Groups**: Rules are correct and minimal
3. **ECS Tasks**: Running with correct count
4. **ALB**: Targets are healthy
5. **Health Checks**: Passing
6. **Logs**: Application logs visible in CloudWatch
7. **DNS**: Domain resolves to ALB (if configured)
8. **HTTPS**: Certificate valid (if configured)

---

## Common Issues

### Issue: ECS tasks fail to start

**Possible Causes**:
- Container image not found in ECR
- Insufficient IAM permissions
- Health check failing

**Solution**:
```bash
# Check task stopped reason
aws ecs describe-tasks --cluster <cluster> --tasks <task-arn>

# View logs
aws logs tail /ecs/myproject-dev/backend --since 5m
```

### Issue: ALB targets unhealthy

**Possible Causes**:
- Security group blocking traffic
- Health check path incorrect
- Application not listening on correct port

**Solution**:
```bash
# Check target health
aws elbv2 describe-target-health --target-group-arn <arn>

# Verify security group allows ALB -> ECS traffic
# Check health check configuration in ALB target group
```

### Issue: Cannot access application via ALB

**Possible Causes**:
- Security group blocking inbound traffic
- Listener rules incorrect
- DNS not configured

**Solution**:
```bash
# Test with curl
curl -v http://<alb-dns-name>

# Check ALB security group allows port 80/443 from 0.0.0.0/0
# Verify listener rules in AWS Console
```

### Issue: Terraform plan shows unwanted changes

**Possible Causes**:
- Resource drift from manual changes
- Ignored attributes being tracked

**Solution**:
```hcl
# Add lifecycle block to ignore changes
lifecycle {
  ignore_changes = [tags, desired_count]
}
```

---

## Rollback Procedures

### Rollback ECS Deployment

```bash
# Revert to previous task definition
aws ecs update-service \
  --cluster myproject-dev-cluster \
  --service myproject-dev-backend \
  --task-definition myproject-dev-backend:1  # Previous revision
```

### Rollback Terraform Changes

```bash
# Revert to previous state
terraform state pull > backup.tfstate
terraform apply -var="container_image=myapp:v1"
```

### Emergency Rollback

```bash
# Set desired count to 0
terraform apply -var="desired_count=0"

# Or destroy and redeploy
terraform destroy
terraform apply
```

---

## Cost Optimization Tips

1. **Use Fargate Spot**: 70% cost savings for non-production
2. **Right-size tasks**: Start small (256 CPU, 512 MB)
3. **Reduce log retention**: 7 days for dev, 30 days for prod
4. **Auto-scaling**: Scale down during off-hours
5. **Single instance**: Use `desired_count=1` for dev
6. **Disable Container Insights**: Only enable for production
7. **Cross-AZ traffic**: Minimize with proper subnet placement

---

## Next Steps

After successful deployment:

1. **Set up CI/CD**: Automate deployments with GitHub Actions
2. **Configure monitoring**: CloudWatch dashboards and alarms
3. **Enable auto-scaling**: For production environments
4. **Set up backups**: For stateful resources
5. **Document runbooks**: For common operations

---

## Related Guides

- [How-To: Create a Workspace](how-to-create-workspace.md)
- [How-To: Manage State](how-to-manage-state.md)
- [Terraform Standards](../standards/TERRAFORM_STANDARDS.md)
