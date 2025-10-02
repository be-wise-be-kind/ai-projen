# How-To: Add AWS Deployment Workflow

**Purpose**: Configure automated deployment to AWS ECS with ECR image building

**Scope**: Complete AWS deployment setup from Docker build to ECS deployment

**Prerequisites**:
- GitHub Actions plugin installed
- AWS account with ECS infrastructure deployed
- Docker plugin installed (for building images)
- AWS OIDC authentication configured
- ECR repositories created
- ECS cluster and services created

**Estimated Time**: 60-90 minutes

**Difficulty**: Advanced

## Overview

This guide walks through setting up automated deployment to AWS ECS (Elastic Container Service). You'll configure:
- Docker image building
- ECR (Elastic Container Registry) push
- ECS task definition updates
- Zero-downtime deployments
- Multi-environment support

## Step 1: Verify AWS Infrastructure

### Required AWS Resources

Before starting, ensure these resources exist:

```bash
# ECR Repositories
aws ecr describe-repositories --repository-names your-app-backend your-app-frontend

# ECS Cluster
aws ecs describe-clusters --clusters your-app-cluster

# ECS Services
aws ecs describe-services --cluster your-app-cluster --services your-app-backend your-app-frontend

# Task Definitions
aws ecs describe-task-definition --task-definition your-app-backend
```

If these don't exist, you need to deploy your infrastructure first (typically using Terraform or CloudFormation).

## Step 2: Configure AWS OIDC Authentication

### Why OIDC?

OIDC (OpenID Connect) allows GitHub Actions to authenticate with AWS without storing long-lived credentials. This is more secure and follows AWS best practices.

### Create OIDC Provider (One-Time Setup)

```bash
# Check if provider already exists
aws iam list-open-id-connect-providers

# Create provider if it doesn't exist
aws iam create-open-id-connect-provider \
  --url https://token.actions.githubusercontent.com \
  --client-id-list sts.amazonaws.com \
  --thumbprint-list 6938fd4d98bab03faadb97b34396831e3780aea1
```

### Create IAM Role for GitHub Actions

Create a trust policy file `github-trust-policy.json`:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "arn:aws:iam::YOUR_ACCOUNT_ID:oidc-provider/token.actions.githubusercontent.com"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "token.actions.githubusercontent.com:aud": "sts.amazonaws.com"
        },
        "StringLike": {
          "token.actions.githubusercontent.com:sub": "repo:YOUR_ORG/YOUR_REPO:*"
        }
      }
    }
  ]
}
```

Create the role:

```bash
aws iam create-role \
  --role-name GitHubActionsDeploymentRole \
  --assume-role-policy-document file://github-trust-policy.json
```

### Attach Required Permissions

Create a permissions policy `github-permissions-policy.json`:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ecr:GetAuthorizationToken",
        "ecr:BatchCheckLayerAvailability",
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage",
        "ecr:PutImage",
        "ecr:InitiateLayerUpload",
        "ecr:UploadLayerPart",
        "ecr:CompleteLayerUpload"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "ecs:DescribeServices",
        "ecs:DescribeTaskDefinition",
        "ecs:DescribeTasks",
        "ecs:ListTasks",
        "ecs:RegisterTaskDefinition",
        "ecs:UpdateService"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "iam:PassRole"
      ],
      "Resource": "arn:aws:iam::YOUR_ACCOUNT_ID:role/ecsTaskExecutionRole"
    }
  ]
}
```

Attach the policy:

```bash
aws iam put-role-policy \
  --role-name GitHubActionsDeploymentRole \
  --policy-name GitHubActionsDeploymentPolicy \
  --policy-document file://github-permissions-policy.json
```

Get the role ARN:

```bash
aws iam get-role \
  --role-name GitHubActionsDeploymentRole \
  --query 'Role.Arn' \
  --output text
```

## Step 3: Configure GitHub Secrets

Add these secrets to your GitHub repository:

1. Go to Settings → Secrets and variables → Actions
2. Click "New repository secret"

**Add AWS_ROLE_ARN**:
- Name: `AWS_ROLE_ARN`
- Value: `arn:aws:iam::123456789012:role/GitHubActionsDeploymentRole`

**Add AWS_REGION**:
- Name: `AWS_REGION`
- Value: `us-west-2` (or your region)

**Optional - Add API_URL** (for frontend builds):
- Name: `API_URL`
- Value: `https://api.example.com`

See [How to Configure Secrets](how-to-configure-secrets.md) for detailed instructions.

## Step 4: Copy Build Workflow Template

Copy the ECR build workflow:

```bash
cp plugins/infrastructure/ci-cd/github-actions/templates/build-ecr.yml \
   .github/workflows/build-and-push.yml
```

### Customize Build Workflow

Edit `.github/workflows/build-and-push.yml`:

```yaml
env:
  AWS_REGION: us-west-2  # Your AWS region
  ECR_REPOSITORY_FRONTEND: my-app-frontend  # Your ECR repo
  ECR_REPOSITORY_BACKEND: my-app-backend    # Your ECR repo
```

Update Dockerfile paths if needed:

```yaml
- name: Build and push backend image
  uses: docker/build-push-action@v5
  with:
    context: .
    file: ./.docker/dockerfiles/Dockerfile.backend  # Your Dockerfile path
    # ... rest of config
```

**Template**: `templates/build-ecr.yml`

## Step 5: Copy Deployment Workflow Template

Copy the ECS deployment workflow:

```bash
cp plugins/infrastructure/ci-cd/github-actions/templates/deploy-aws.yml \
   .github/workflows/deploy.yml
```

### Customize Deployment Workflow

Edit `.github/workflows/deploy.yml`:

```yaml
env:
  AWS_REGION: us-west-2
  ECR_REPOSITORY_FRONTEND: my-app-frontend
  ECR_REPOSITORY_BACKEND: my-app-backend
  ECS_CLUSTER: my-app-cluster  # Your ECS cluster name
  ECS_SERVICE_FRONTEND: my-app-frontend  # Your frontend service name
  ECS_SERVICE_BACKEND: my-app-backend    # Your backend service name
  TASK_DEFINITION_FRONTEND: my-app-frontend  # Your task definition name
  TASK_DEFINITION_BACKEND: my-app-backend    # Your task definition name
```

**Template**: `templates/deploy-aws.yml`

## Step 6: Configure Environment Variables for Deployment

### Backend Environment Variables

Update the deploy workflow to include your backend environment variables:

```yaml
- name: Update backend task definition
  id: backend-task-def
  uses: aws-actions/amazon-ecs-render-task-definition@v1
  with:
    task-definition: backend-task-definition.json
    container-name: backend
    image: ${{ steps.login-ecr.outputs.registry }}/${{ env.ECR_REPOSITORY_BACKEND }}:${{ steps.sha.outputs.sha_short }}
    environment-variables: |
      LOG_LEVEL=INFO
      ENVIRONMENT=${{ github.event.inputs.environment || 'dev' }}
      DATABASE_URL=${{ secrets.DATABASE_URL }}
      REDIS_URL=${{ secrets.REDIS_URL }}
      API_KEY=${{ secrets.API_KEY }}
```

### Frontend Environment Variables

For frontend (build-time environment variables):

```yaml
- name: Build and push frontend image
  uses: docker/build-push-action@v5
  with:
    build-args: |
      VITE_API_URL=${{ secrets.API_URL || 'https://api.example.com' }}
      VITE_ENVIRONMENT=production
```

## Step 7: Test the Deployment Workflow

### Test Manually First

```bash
# 1. Trigger build workflow manually
gh workflow run build-and-push.yml

# 2. Wait for it to complete
gh run list --workflow=build-and-push.yml

# 3. Trigger deployment manually
gh workflow run deploy.yml
```

Or use GitHub web interface:
1. Go to Actions tab
2. Select "Build and Push to ECR"
3. Click "Run workflow"
4. Wait for completion
5. Select "Deploy to AWS ECS"
6. Click "Run workflow" → Select environment (dev)

### Verify Deployment

```bash
# Check ECS service status
aws ecs describe-services \
  --cluster my-app-cluster \
  --services my-app-backend my-app-frontend \
  --query 'services[*].{Name:serviceName,Status:status,Running:runningCount,Desired:desiredCount}' \
  --output table

# Check running tasks
aws ecs list-tasks \
  --cluster my-app-cluster \
  --service-name my-app-backend

# View task logs
aws logs tail /aws/ecs/my-app-backend --follow
```

## Step 8: Configure Automatic Deployment

### Deploy on Push to Main

The deployment workflow is already configured to deploy automatically when you push to main:

```yaml
on:
  push:
    branches: [main]
    paths:
      - 'backend/**'
      - 'frontend/**'
```

This means:
1. Push to main branch
2. Build workflow runs (creates Docker images)
3. Deploy workflow runs (deploys to dev environment)

### Multi-Environment Deployment

For staging and production, use manual workflow dispatch:

```yaml
on:
  workflow_dispatch:
    inputs:
      environment:
        description: 'Environment to deploy'
        required: true
        default: 'dev'
        type: choice
        options:
          - dev
          - staging
          - prod
```

To deploy to production:
1. Go to Actions tab
2. Select "Deploy to AWS ECS"
3. Click "Run workflow"
4. Select "prod" from environment dropdown
5. Click "Run workflow"

## Verification

### Deployment Checklist

- [ ] AWS OIDC provider created
- [ ] IAM role created with correct trust policy
- [ ] IAM role has required permissions (ECR, ECS)
- [ ] GitHub secrets configured (AWS_ROLE_ARN, AWS_REGION)
- [ ] Build workflow customized with correct ECR repos
- [ ] Deploy workflow customized with correct ECS resources
- [ ] Environment variables configured for backend/frontend
- [ ] Test deployment successful
- [ ] Application accessible at expected URL

### Health Check

After deployment:

```bash
# Check application health
curl https://api.example.com/health

# Check frontend
curl https://example.com

# Check ECS service events
aws ecs describe-services \
  --cluster my-app-cluster \
  --services my-app-backend \
  --query 'services[0].events[0:5]'
```

## Common Issues

### Issue: "Access Denied" during ECR push

**Solution**: Verify IAM role has ECR permissions

```bash
# Check role policies
aws iam list-attached-role-policies --role-name GitHubActionsDeploymentRole
aws iam get-role-policy --role-name GitHubActionsDeploymentRole --policy-name GitHubActionsDeploymentPolicy
```

### Issue: OIDC authentication fails

**Solution**: Verify trust policy

```bash
# Get trust policy
aws iam get-role --role-name GitHubActionsDeploymentRole --query 'Role.AssumeRolePolicyDocument'

# Verify repository name matches exactly
```

### Issue: ECS deployment fails

**Solution**: Check service exists and task definition is valid

```bash
# List services
aws ecs list-services --cluster my-app-cluster

# Describe task definition
aws ecs describe-task-definition --task-definition my-app-backend

# Check service events for errors
aws ecs describe-services --cluster my-app-cluster --services my-app-backend --query 'services[0].events[0:10]'
```

### Issue: Container fails to start

**Solution**: Check CloudWatch logs

```bash
# Find log group
aws logs describe-log-groups | grep my-app

# Tail logs
aws logs tail /aws/ecs/my-app-backend --follow

# Check for errors
aws logs filter-log-events \
  --log-group-name /aws/ecs/my-app-backend \
  --filter-pattern "ERROR"
```

### Issue: Old tasks not draining

**Solution**: Check deployment configuration

```yaml
# In deploy workflow
wait-for-service-stability: true
wait-for-minutes: 10  # Increase if needed
```

## Advanced Configuration

### Blue/Green Deployment

For zero-downtime deployments, ECS rolling updates are configured by default. For blue/green:

1. Create CodeDeploy application
2. Update workflow to use CodeDeploy action
3. Configure traffic shifting in CodeDeploy

### Multi-Region Deployment

Deploy to multiple regions:

```yaml
strategy:
  matrix:
    region: [us-west-2, us-east-1, eu-west-1]

steps:
  - name: Deploy to ${{ matrix.region }}
    uses: aws-actions/amazon-ecs-deploy-task-definition@v1
    env:
      AWS_REGION: ${{ matrix.region }}
```

### Rollback on Failure

Automatic rollback is handled by ECS:
- Failed health checks stop new task deployment
- Old tasks remain running
- Service automatically reverts to previous task definition

Manual rollback:

```bash
# Get previous task definition
aws ecs describe-services --cluster my-app-cluster --services my-app-backend --query 'services[0].deployments[1].taskDefinition'

# Update service to use previous task definition
aws ecs update-service \
  --cluster my-app-cluster \
  --service my-app-backend \
  --task-definition my-app-backend:PREVIOUS_REVISION
```

## Monitoring

### CloudWatch Logs

View logs in CloudWatch:

```bash
aws logs tail /aws/ecs/my-app-backend --follow
```

### ECS Service Metrics

Monitor in CloudWatch:
- CPU utilization
- Memory utilization
- Running task count
- Deployment status

### Deployment Notifications

Add Slack notifications:

```yaml
- name: Notify deployment
  if: always()
  uses: slackapi/slack-github-action@v1
  with:
    webhook-url: ${{ secrets.SLACK_WEBHOOK_URL }}
    payload: |
      {
        "text": "Deployment to ${{ github.event.inputs.environment }} completed",
        "status": "${{ job.status }}"
      }
```

## Next Steps

After successful deployment:

1. **Set Up Monitoring**: Configure CloudWatch dashboards and alarms
2. **Configure Auto-Scaling**: Set up ECS auto-scaling based on metrics
3. **Add Health Checks**: Configure ALB health checks
4. **Enable Container Insights**: For detailed container metrics
5. **Set Up Backup**: Configure RDS backups if using database
6. **Document URLs**: Update README with deployment URLs

## Related How-Tos

- [How to Add a Workflow](how-to-add-workflow.md) - Create custom workflows
- [How to Configure Secrets](how-to-configure-secrets.md) - Set up GitHub Secrets

## References

- **Standards**: `standards/ci-cd-standards.md` - Deployment best practices
- **Templates**: `templates/build-ecr.yml`, `templates/deploy-aws.yml`
- **AWS Docs**: [ECS Deployments](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/deployment-types.html)
- **GitHub Docs**: [AWS OIDC](https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/configuring-openid-connect-in-amazon-web-services)
