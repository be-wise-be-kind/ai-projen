# Purpose: Output values from bootstrap workspace
# Scope: Exports Terraform backend configuration and GitHub OIDC details
# Overview: Provides output values needed for backend configuration and CI/CD setup including
#     S3 bucket name, DynamoDB table name, GitHub OIDC provider ARN, and GitHub Actions role ARN.
#     These outputs are used to configure remote state in other workspaces and set up CI/CD.

output "terraform_state_bucket" {
  description = "S3 bucket name for Terraform state storage"
  value       = aws_s3_bucket.terraform_state.id
}

output "terraform_locks_table" {
  description = "DynamoDB table name for Terraform state locking"
  value       = aws_dynamodb_table.terraform_locks.id
}

output "github_oidc_provider_arn" {
  description = "ARN of the GitHub OIDC provider"
  value       = aws_iam_openid_connect_provider.github.arn
}

output "github_actions_role_arn" {
  description = "ARN of the IAM role for GitHub Actions"
  value       = aws_iam_role.github_actions.arn
}

output "backend_config" {
  description = "Backend configuration for other workspaces"
  value = {
    bucket         = aws_s3_bucket.terraform_state.id
    dynamodb_table = aws_dynamodb_table.terraform_locks.id
    region         = var.aws_region
  }
}
