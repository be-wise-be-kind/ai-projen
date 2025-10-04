# How-To: Setup Terraform Workspaces

**Purpose**: Guide for managing multiple environments using Terraform workspaces

**Scope**: Workspace creation, switching, and environment-specific configuration

**Overview**: Complete guide for using Terraform workspaces to manage multiple environments (dev,
    staging, prod) with isolated state and environment-specific configurations.

**Dependencies**: Terraform infrastructure initialized

**Exports**: Multi-environment Terraform setup with isolated state

**Related**: how-to-manage-terraform-infrastructure.md, TERRAFORM_ARCHITECTURE.md

**Implementation**: Terraform workspace commands via Docker

**Difficulty**: intermediate

**Estimated Time**: 15min

---

## Prerequisites

- [ ] Terraform bootstrap applied
- [ ] Backend configuration updated
- [ ] Docker installed

## Overview

Terraform workspaces provide environment isolation with shared configuration. Each workspace has
separate state stored in S3 at different keys (dev/, staging/, prod/).

## Steps

### Step 1: List Existing Workspaces

```bash
cd infra
make -f Makefile.infra infra-workspaces
```

### Step 2: Create New Workspace

```bash
# Create staging workspace
cd infra/terraform/workspaces/base
docker run --rm -it \
  -v $(pwd):/workspace \
  -v ~/.aws:/root/.aws:ro \
  -w /workspace \
  hashicorp/terraform:1.6 workspace new staging
```

### Step 3: Switch Workspace

```bash
# Switch to staging
docker run --rm -it \
  -v $(pwd):/workspace \
  -v ~/.aws:/root/.aws:ro \
  -w /workspace \
  hashicorp/terraform:1.6 workspace select staging
```

### Step 4: Apply Environment-Specific Config

```bash
# Plan for staging
make -f Makefile.infra infra-plan ENV=staging

# Apply for staging
make -f Makefile.infra infra-apply ENV=staging
```

## Verification

```bash
# List workspaces (current marked with *)
make -f Makefile.infra infra-workspaces

# Show current workspace
cd infra/terraform/workspaces/base
docker run --rm -it \
  -v $(pwd):/workspace \
  -w /workspace \
  hashicorp/terraform:1.6 workspace show
```

## Common Issues

### Issue: Workspace Already Exists

**Solution**: Select existing workspace instead of creating new one

### Issue: Wrong Workspace Selected

**Solution**: Always verify current workspace before applying changes

## Best Practices

1. Use consistent workspace names (dev, staging, prod)
2. Verify workspace before apply: `terraform workspace show`
3. Use workspace-specific variables via `terraform.workspace`
4. Isolate state per environment

## Checklist

- [ ] Workspaces created for all environments
- [ ] Backend configured per workspace
- [ ] Workspace selection verified before apply
- [ ] State isolation confirmed

## Related Resources

- [Terraform Workspaces Documentation](https://www.terraform.io/docs/language/state/workspaces.html)
- [Infrastructure Principles](../../docs/react-python-fullstack/INFRASTRUCTURE_PRINCIPLES.md)
