# How-To: Configure GitHub Secrets

**Purpose**: Set up repository secrets for secure CI/CD operations

**Scope**: GitHub Secrets configuration, secret rotation, and best practices

**Prerequisites**:
- GitHub repository access
- Admin or maintain permissions on repository
- Understanding of what secrets you need

**Estimated Time**: 15-20 minutes

**Difficulty**: Beginner

## Overview

GitHub Secrets securely store sensitive information like API keys, passwords, and credentials for use in GitHub Actions workflows. This guide shows you how to configure and manage secrets properly.

## Step 1: Identify Required Secrets

### For AWS Deployment

**Required**:
```
AWS_ROLE_ARN              # IAM role ARN for OIDC authentication
AWS_REGION                # AWS region (e.g., us-west-2)
```

**Optional**:
```
AWS_ACCOUNT_ID            # AWS account number
```

### For Build Workflows

**Optional**:
```
GITHUB_TOKEN              # Automatically provided (no setup needed)
API_URL                   # Backend API URL for frontend builds
NPM_TOKEN                 # For private npm packages
PYPI_TOKEN                # For private PyPI packages
```

### For Notifications

**Optional**:
```
SLACK_WEBHOOK_URL         # For Slack notifications
DISCORD_WEBHOOK_URL       # For Discord notifications
EMAIL_PASSWORD            # For email notifications
```

### For External Services

**As Needed**:
```
DATABASE_URL              # Database connection string
REDIS_URL                 # Redis connection string
SENTRY_DSN                # Error tracking
DATADOG_API_KEY           # Monitoring
```

## Step 2: Access GitHub Secrets Settings

### Via GitHub Web Interface

1. Go to your repository on GitHub
2. Click **Settings** (requires admin access)
3. In left sidebar, click **Secrets and variables**
4. Click **Actions**
5. You'll see the secrets management page

### Via GitHub CLI (Optional)

```bash
# List secrets
gh secret list

# Set a secret
gh secret set SECRET_NAME

# Delete a secret
gh secret delete SECRET_NAME
```

## Step 3: Create AWS OIDC Secrets (For AWS Deployment)

### Background: Why OIDC?

OIDC (OpenID Connect) allows GitHub Actions to authenticate with AWS without long-lived credentials. This is more secure than storing AWS access keys.

### Get Your AWS Role ARN

First, create an OIDC role in AWS (if not already done):

```bash
# 1. Create OIDC provider in AWS (one-time setup)
aws iam create-open-id-connect-provider \
  --url https://token.actions.githubusercontent.com \
  --client-id-list sts.amazonaws.com \
  --thumbprint-list 6938fd4d98bab03faadb97b34396831e3780aea1
```

Create IAM role with trust policy:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "arn:aws:iam::ACCOUNT_ID:oidc-provider/token.actions.githubusercontent.com"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "token.actions.githubusercontent.com:aud": "sts.amazonaws.com"
        },
        "StringLike": {
          "token.actions.githubusercontent.com:sub": "repo:OWNER/REPO:*"
        }
      }
    }
  ]
}
```

Attach policies for permissions (ECR, ECS, etc.):

```bash
aws iam attach-role-policy \
  --role-name GitHubActionsRole \
  --policy-arn arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser

aws iam attach-role-policy \
  --role-name GitHubActionsRole \
  --policy-arn arn:aws:iam::aws:policy/AmazonECS_FullAccess
```

Get the role ARN:

```bash
aws iam get-role --role-name GitHubActionsRole --query 'Role.Arn' --output text
```

### Add AWS Secrets to GitHub

1. Go to repository Settings → Secrets and variables → Actions
2. Click **New repository secret**

**Add AWS_ROLE_ARN**:
- Name: `AWS_ROLE_ARN`
- Value: `arn:aws:iam::123456789012:role/GitHubActionsRole`
- Click **Add secret**

**Add AWS_REGION**:
- Name: `AWS_REGION`
- Value: `us-west-2` (or your region)
- Click **Add secret**

## Step 4: Add Application Secrets

### API URLs

For frontend builds that need backend API URLs:

1. Click **New repository secret**
2. Name: `API_URL`
3. Value: `https://api.example.com`
4. Click **Add secret**

### Third-Party Services

For external services (Slack, Sentry, etc.):

1. Get the secret from the service provider
2. Click **New repository secret**
3. Name: `SLACK_WEBHOOK_URL` (or appropriate name)
4. Value: The webhook URL or API key
5. Click **Add secret**

## Step 5: Use Secrets in Workflows

### Basic Usage

```yaml
jobs:
  deploy:
    steps:
      - name: Use secret
        run: |
          echo "Using secret (not exposed in logs)"
        env:
          MY_SECRET: ${{ secrets.MY_SECRET }}
```

### AWS OIDC Authentication

```yaml
- name: Configure AWS credentials
  uses: aws-actions/configure-aws-credentials@v4
  with:
    role-to-assume: ${{ secrets.AWS_ROLE_ARN }}
    role-session-name: GitHub-Actions-${{ github.run_id }}
    aws-region: ${{ secrets.AWS_REGION }}
```

### Build Arguments

```yaml
- name: Build with secret
  uses: docker/build-push-action@v5
  with:
    build-args: |
      API_URL=${{ secrets.API_URL }}
      ENVIRONMENT=production
```

### Environment Variables

```yaml
- name: Run with secrets
  env:
    DATABASE_URL: ${{ secrets.DATABASE_URL }}
    API_KEY: ${{ secrets.API_KEY }}
  run: |
    # Scripts can access these as environment variables
    python deploy.py
```

## Step 6: Verify Secrets Configuration

### Test Workflow

Create a test workflow to verify secrets are accessible:

```yaml
name: Test Secrets

on:
  workflow_dispatch:

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - name: Check AWS secrets
        run: |
          if [ -z "${{ secrets.AWS_ROLE_ARN }}" ]; then
            echo "::error::AWS_ROLE_ARN not configured"
            exit 1
          fi
          echo "AWS_ROLE_ARN is configured"

      - name: Test AWS OIDC
        uses: aws-actions/configure-aws-credentials@v4
        with:
          role-to-assume: ${{ secrets.AWS_ROLE_ARN }}
          aws-region: ${{ secrets.AWS_REGION }}

      - name: Verify AWS access
        run: |
          aws sts get-caller-identity
          echo "AWS authentication successful!"
```

Run this workflow manually to verify:
1. Go to Actions tab
2. Select "Test Secrets" workflow
3. Click "Run workflow"
4. Verify it completes successfully

## Verification

### Checklist

- [ ] All required secrets added to GitHub
- [ ] AWS OIDC configured (if using AWS)
- [ ] Test workflow runs successfully
- [ ] Secrets not exposed in workflow logs
- [ ] Secret names match workflow references

### Security Checks

- [ ] No secrets in code or workflow files
- [ ] Secrets have minimal necessary permissions
- [ ] OIDC used instead of long-lived credentials (for AWS)
- [ ] Secrets are repository secrets (not environment variables)
- [ ] Access to secrets is limited to necessary jobs

## Common Issues

### Issue: "AWS_ROLE_ARN not found"

**Solution**: Check that secret name exactly matches what's in workflow

```yaml
# Secret name must match exactly (case-sensitive)
role-to-assume: ${{ secrets.AWS_ROLE_ARN }}
```

### Issue: OIDC authentication fails

**Solution**: Verify trust policy in AWS role

1. Check that repository owner/name is correct
2. Verify OIDC provider is configured in AWS
3. Confirm role permissions are correct

### Issue: Secret appears in logs

**Solution**: GitHub automatically redacts secret values, but be careful:

```yaml
# DON'T: This might expose secret structure
- run: echo "API key is: ${{ secrets.API_KEY }}"

# DO: Use without exposing
- env:
    API_KEY: ${{ secrets.API_KEY }}
  run: curl -H "Authorization: Bearer $API_KEY" https://api.example.com
```

## Secret Management Best Practices

### 1. Use Descriptive Names

```
Good: AWS_ROLE_ARN, PRODUCTION_API_URL, SLACK_WEBHOOK_URL
Bad: SECRET1, KEY, TOKEN
```

### 2. Separate by Environment

For multi-environment setups:

```
DEV_DATABASE_URL
STAGING_DATABASE_URL
PROD_DATABASE_URL
```

Or use GitHub Environments for better isolation.

### 3. Minimal Permissions

AWS role should have minimal required permissions:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ecr:GetAuthorizationToken",
        "ecr:BatchCheckLayerAvailability",
        "ecr:PutImage"
      ],
      "Resource": "*"
    }
  ]
}
```

### 4. Regular Rotation

Rotate secrets periodically:
- API keys: Every 90 days
- OIDC roles: Review permissions quarterly
- Service tokens: On team member changes

### 5. Document Required Secrets

Keep documentation of required secrets:

```markdown
## Required GitHub Secrets

### AWS Deployment
- `AWS_ROLE_ARN`: IAM role for OIDC auth
- `AWS_REGION`: Deployment region

### Application
- `API_URL`: Backend API endpoint
```

## Advanced: Using GitHub Environments

For projects with multiple deployment environments:

1. Go to Settings → Environments
2. Create environment (e.g., "production")
3. Add environment-specific secrets
4. Add required reviewers for protection

Use in workflows:

```yaml
jobs:
  deploy:
    environment: production  # Uses production environment secrets
    steps:
      - name: Deploy
        env:
          API_URL: ${{ secrets.API_URL }}  # Environment-specific
        run: make deploy
```

## Secret Rotation

When rotating secrets:

1. **Generate new secret** in the service
2. **Update GitHub secret** with new value
3. **Test workflow** to verify it works
4. **Revoke old secret** in the service
5. **Document** the rotation in team log

## Next Steps

After configuring secrets:

1. **Test Workflows**: Run workflows that use secrets
2. **Document**: Update project README with secret requirements
3. **Audit**: Review who has access to repository secrets
4. **Monitor**: Set up alerts for failed authentications

## Related How-Tos

- [How to Add a Workflow](how-to-add-workflow.md) - Create workflows that use secrets
- [How to Add AWS Deployment](how-to-add-deployment.md) - Deploy to AWS with OIDC

## References

- **Standards**: `standards/ci-cd-standards.md` - Security best practices
- **GitHub Docs**: [Encrypted secrets](https://docs.github.com/en/actions/security-guides/encrypted-secrets)
- **AWS Docs**: [OIDC with GitHub Actions](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_providers_create_oidc.html)
