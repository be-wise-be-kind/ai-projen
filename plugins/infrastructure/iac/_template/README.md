# Infrastructure as Code Plugin Template

**Purpose**: Template for IaC tool plugins (Pulumi, CDK, CloudFormation, etc.)

**Use this template to**: Add support for IaC tools beyond Terraform

---

## How to Use This Template

1. Copy: `cp -r plugins/infrastructure/iac/_template/ plugins/infrastructure/iac/<tool>/`
2. Customize for your IaC tool
3. Add configuration templates and modules
4. Provide Make targets for plan/apply/destroy
5. Update PLUGIN_MANIFEST.yaml

## What to Include

- ✅ Project initialization files
- ✅ Module/stack templates (VPC, compute, storage, etc.)
- ✅ Environment/workspace configurations (dev, staging, prod)
- ✅ State management setup
- ✅ Make targets (plan, apply, destroy)
- ✅ Provider configurations (AWS, GCP, Azure)

## Integration

- Extend agents.md with IaC commands
- Provide clear workspace/environment separation
- Include cost estimation commands where available
- Document security best practices

See `plugins/infrastructure/iac/terraform/` for reference.
