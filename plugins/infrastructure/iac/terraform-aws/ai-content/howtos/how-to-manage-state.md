# How-To: Manage Terraform State

**Purpose**: Set up and manage Terraform state using AWS S3 and DynamoDB

**Scope**: Backend configuration, state file management, and locking

**Prerequisites**:
- AWS CLI configured
- AWS account with appropriate permissions
- Terraform >= 1.0 installed

**Estimated Time**: 10-15 minutes

**Difficulty**: Beginner

---

## Overview

Terraform state is a critical component that tracks your infrastructure. This guide covers
setting up remote state storage in AWS S3 with DynamoDB locking, managing state files,
and handling common state-related issues.

---

## Steps

### Step 1: Create S3 Bucket for State Storage

Create an S3 bucket with versioning and encryption enabled:

```bash
# Set variables
PROJECT_NAME="myproject"
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
AWS_REGION="us-west-2"
BUCKET_NAME="${PROJECT_NAME}-${AWS_ACCOUNT_ID}-terraform-state"

# Create bucket
aws s3api create-bucket \
  --bucket $BUCKET_NAME \
  --region $AWS_REGION \
  --create-bucket-configuration LocationConstraint=$AWS_REGION

# Enable versioning
aws s3api put-bucket-versioning \
  --bucket $BUCKET_NAME \
  --versioning-configuration Status=Enabled

# Enable encryption
aws s3api put-bucket-encryption \
  --bucket $BUCKET_NAME \
  --server-side-encryption-configuration '{
    "Rules": [{
      "ApplyServerSideEncryptionByDefault": {
        "SSEAlgorithm": "AES256"
      }
    }]
  }'

# Block public access
aws s3api put-public-access-block \
  --bucket $BUCKET_NAME \
  --public-access-block-configuration \
    BlockPublicAcls=true,\
    IgnorePublicAcls=true,\
    BlockPublicPolicy=true,\
    RestrictPublicBuckets=true

# Enable lifecycle policy for cost optimization
aws s3api put-bucket-lifecycle-configuration \
  --bucket $BUCKET_NAME \
  --lifecycle-configuration '{
    "Rules": [{
      "Id": "DeleteOldVersions",
      "Status": "Enabled",
      "NoncurrentVersionExpiration": {
        "NoncurrentDays": 90
      }
    }]
  }'
```

### Step 2: Create DynamoDB Table for State Locking

Create a DynamoDB table for state locking:

```bash
# Set table name
TABLE_NAME="${PROJECT_NAME}-terraform-locks"

# Create table
aws dynamodb create-table \
  --table-name $TABLE_NAME \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST \
  --region $AWS_REGION

# Wait for table to be active
aws dynamodb wait table-exists --table-name $TABLE_NAME --region $AWS_REGION

# Enable point-in-time recovery
aws dynamodb update-continuous-backups \
  --table-name $TABLE_NAME \
  --point-in-time-recovery-specification PointInTimeRecoveryEnabled=true \
  --region $AWS_REGION
```

### Step 3: Verify Backend Resources

```bash
# Verify S3 bucket
aws s3api get-bucket-versioning --bucket $BUCKET_NAME
aws s3api get-bucket-encryption --bucket $BUCKET_NAME

# Verify DynamoDB table
aws dynamodb describe-table --table-name $TABLE_NAME --query 'Table.{Name:TableName,Status:TableStatus}'
```

### Step 4: Configure Terraform Backend

Create or update `backend.tf` in each workspace:

```hcl
terraform {
  backend "s3" {
    bucket         = "myproject-123456789012-terraform-state"
    key            = "vpc/dev/terraform.tfstate"  # Unique per workspace
    region         = "us-west-2"
    encrypt        = true
    dynamodb_table = "myproject-terraform-locks"
  }
}
```

**Key Naming Convention**:
- VPC: `vpc/${environment}/terraform.tfstate`
- ECS: `ecs/${environment}/terraform.tfstate`
- ALB: `alb/${environment}/terraform.tfstate`

### Step 5: Initialize Backend

In each workspace directory:

```bash
terraform init
```

If migrating from local state:
```bash
terraform init -migrate-state
```

**Expected Output**:
```
Initializing the backend...

Successfully configured the backend "s3"!
```

### Step 6: Verify State Storage

```bash
# List state files in S3
aws s3 ls s3://$BUCKET_NAME/ --recursive

# Check state file exists
aws s3 ls s3://$BUCKET_NAME/vpc/dev/terraform.tfstate
```

---

## State Management Operations

### View Current State

```bash
# List all resources in state
terraform state list

# Show specific resource
terraform state show aws_vpc.main

# Pull current state (download)
terraform state pull > current.tfstate
```

### Backup State

```bash
# Create backup
terraform state pull > backup-$(date +%Y%m%d-%H%M%S).tfstate

# Restore from backup
terraform state push backup-20240101-120000.tfstate
```

### Move Resources Between States

```bash
# Move resource to different state file
terraform state mv aws_instance.example module.instances.aws_instance.example

# Remove resource from state (without destroying)
terraform state rm aws_instance.example
```

### Import Existing Resources

```bash
# Import existing AWS resource into state
terraform import aws_vpc.main vpc-12345678
terraform import aws_subnet.public[0] subnet-12345678
```

### Refresh State

```bash
# Update state to match real infrastructure
terraform refresh
```

---

## State Locking

### Understanding State Locks

Terraform automatically acquires a lock when running operations:
- `terraform plan`
- `terraform apply`
- `terraform destroy`

The lock prevents concurrent modifications.

### Viewing Active Locks

```bash
# Check DynamoDB for locks
aws dynamodb scan --table-name $TABLE_NAME --query 'Items[*].LockID.S'
```

### Force Unlock (Emergency Only)

```bash
# Get lock ID from error message
LOCK_ID="<lock-id-from-error>"

# Force unlock
terraform force-unlock $LOCK_ID

# OR manually delete from DynamoDB
aws dynamodb delete-item \
  --table-name $TABLE_NAME \
  --key "{\"LockID\": {\"S\": \"$LOCK_ID\"}}"
```

**Warning**: Only force unlock if you're certain no other process is running!

---

## State File Security

### Bucket Policy (Restrict Access)

```bash
# Create bucket policy
cat > policy.json << 'EOF'
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "DenyUnencryptedObjectUploads",
      "Effect": "Deny",
      "Principal": "*",
      "Action": "s3:PutObject",
      "Resource": "arn:aws:s3:::BUCKET_NAME/*",
      "Condition": {
        "StringNotEquals": {
          "s3:x-amz-server-side-encryption": "AES256"
        }
      }
    }
  ]
}
EOF

# Replace BUCKET_NAME
sed -i "s/BUCKET_NAME/$BUCKET_NAME/g" policy.json

# Apply policy
aws s3api put-bucket-policy --bucket $BUCKET_NAME --policy file://policy.json
```

### IAM Permissions

Create IAM policy for Terraform users:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:PutObject",
        "s3:DeleteObject"
      ],
      "Resource": "arn:aws:s3:::myproject-*-terraform-state/*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:ListBucket"
      ],
      "Resource": "arn:aws:s3:::myproject-*-terraform-state"
    },
    {
      "Effect": "Allow",
      "Action": [
        "dynamodb:GetItem",
        "dynamodb:PutItem",
        "dynamodb:DeleteItem"
      ],
      "Resource": "arn:aws:dynamodb:*:*:table/myproject-terraform-locks"
    }
  ]
}
```

---

## Multi-Environment State

### Separate State Files Per Environment

```
s3://bucket/
├── vpc/
│   ├── dev/terraform.tfstate
│   ├── staging/terraform.tfstate
│   └── prod/terraform.tfstate
├── ecs/
│   ├── dev/terraform.tfstate
│   ├── staging/terraform.tfstate
│   └── prod/terraform.tfstate
└── alb/
    ├── dev/terraform.tfstate
    ├── staging/terraform.tfstate
    └── prod/terraform.tfstate
```

### Environment-Specific Backend Configuration

Use backend configuration files:

**backend-dev.hcl**:
```hcl
bucket = "myproject-123456789012-terraform-state"
key    = "vpc/dev/terraform.tfstate"
region = "us-west-2"
```

**backend-prod.hcl**:
```hcl
bucket = "myproject-123456789012-terraform-state"
key    = "vpc/prod/terraform.tfstate"
region = "us-west-2"
```

Initialize with:
```bash
terraform init -backend-config=backend-dev.hcl
```

---

## Cross-Workspace References

### Reference Another Workspace's State

In dependent workspaces (ECS, ALB), reference VPC state:

```hcl
data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = var.terraform_state_bucket
    key    = "vpc/${var.environment}/terraform.tfstate"
    region = var.aws_region
  }
}

# Use outputs from VPC workspace
locals {
  vpc_id             = data.terraform_remote_state.vpc.outputs.vpc_id
  private_subnet_ids = data.terraform_remote_state.vpc.outputs.private_subnet_ids
}
```

---

## Verification

After setting up state management:

1. **S3 Bucket**: Verify versioning and encryption enabled
2. **DynamoDB Table**: Verify table exists and has PITR enabled
3. **State Files**: Confirm state files are created after `terraform apply`
4. **Locking Works**: Run concurrent `terraform plan` commands (one should wait)
5. **Backup Strategy**: Test state pull and restore

---

## Common Issues

### Issue: Backend initialization fails

**Error**: "Error loading state: AccessDenied"

**Cause**: Insufficient IAM permissions

**Solution**: Ensure IAM user/role has S3 and DynamoDB permissions

### Issue: State lock timeout

**Error**: "Error acquiring the state lock"

**Cause**: Another process is running or crashed with lock held

**Solution**:
```bash
# Check for running processes
ps aux | grep terraform

# If no processes running, force unlock
terraform force-unlock <lock-id>
```

### Issue: State file not found

**Error**: "Failed to load state: NoSuchKey"

**Cause**: State file doesn't exist or wrong key path

**Solution**:
```bash
# Verify key path in backend.tf matches expected location
# Initialize with -reconfigure if needed
terraform init -reconfigure
```

### Issue: State drift detected

**Error**: "Terraform will perform the following actions..."

**Cause**: Manual changes made outside Terraform

**Solution**:
```bash
# Review changes
terraform plan

# Import manually created resources
terraform import <resource-type>.<name> <resource-id>

# Or refresh state
terraform refresh
```

---

## Best Practices

1. **Never commit state files** to version control
2. **Always use remote state** for team collaboration
3. **Enable versioning** on S3 bucket for rollback capability
4. **Use separate states** per environment (dev, staging, prod)
5. **Limit access** to state files (contain sensitive data)
6. **Regular backups** using `terraform state pull`
7. **State locking** always enabled in production
8. **Encrypt state files** at rest and in transit
9. **Monitor state access** with CloudTrail
10. **Document state structure** for team members

---

## Cleanup

To remove backend resources (DANGER):

```bash
# Delete all state files first
aws s3 rm s3://$BUCKET_NAME --recursive

# Delete bucket
aws s3api delete-bucket --bucket $BUCKET_NAME

# Delete DynamoDB table
aws dynamodb delete-table --table-name $TABLE_NAME
```

**Warning**: Only do this when completely decommissioning infrastructure!

---

## Next Steps

After setting up state management:

1. **Create Workspaces**: Use state backend in all workspaces
2. **Set Up Team Access**: Configure IAM permissions for team
3. **Document State Keys**: Maintain documentation of state file locations
4. **Implement CI/CD**: Automate state management in pipelines

---

## Related Guides

- [How-To: Create a Workspace](how-to-create-workspace.md)
- [How-To: Deploy to AWS](how-to-deploy-to-aws.md)
- [Terraform Standards](../standards/terraform-standards.md)
