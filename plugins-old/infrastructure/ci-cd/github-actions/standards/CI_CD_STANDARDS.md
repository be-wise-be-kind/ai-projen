# GitHub Actions CI/CD Standards

**Purpose**: Best practices and standards for GitHub Actions CI/CD workflows

**Scope**: Workflow design, performance optimization, security, and operational excellence

## Core Principles

### 1. Docker-First CI/CD Pattern

**Standard**: All CI/CD workflows should use containerized execution environments.

**Rationale**:
- Consistent environments between local development and CI
- Reproducible builds across different runners
- Faster iteration with pre-built containers
- Isolation of dependencies and tools

**Implementation**:
```yaml
# Use dedicated linting containers
- Multi-stage Dockerfiles with lint, test, dev, and prod targets
- Registry caching (GHCR) for pre-built containers
- Conditional rebuilds based on dependency changes
```

**Benefits**:
- 80-90% faster CI runs with caching
- Same `make` commands work locally and in CI
- No dependency installation on every run

### 2. Registry-Based Caching

**Standard**: Cache pre-built containers in GitHub Container Registry (GHCR).

**Implementation**:
```yaml
- name: Check dependencies changed
  run: |
    # Only rebuild if Dockerfile or deps changed
    if dependencies_changed; then
      build_and_cache_to_ghcr
    else
      pull_from_ghcr
    fi
```

**Requirements**:
- Conditional rebuild logic based on file changes
- Always refresh cache on main branch
- Cache hit detection with fallback to build

### 3. Parallel Execution

**Standard**: Run independent jobs in parallel to minimize total CI time.

**Implementation**:
```yaml
jobs:
  lint-backend:
    # Runs in parallel with lint-frontend
  lint-frontend:
    # Runs in parallel with lint-backend
  test-backend:
    needs: [lint-backend]
    # Runs after lint passes
```

**Best Practices**:
- Backend and frontend jobs run in parallel
- Tests run only after linting passes
- Build/deploy waits for all tests

### 4. Change Detection

**Standard**: Run only relevant tests based on changed files.

**Implementation**:
```yaml
- uses: dorny/paths-filter@v2
  id: changes
  with:
    filters: |
      backend: 'backend/**'
      frontend: 'frontend/**'

- if: steps.changes.outputs.backend == 'true'
  run: make test-backend
```

**Benefits**:
- Faster feedback for isolated changes
- Reduced resource usage
- Still runs all tests on main branch

## Workflow Organization

### Naming Conventions

**Standard**: Use clear, descriptive workflow names.

```yaml
# Good
name: Python CI
name: Deploy to AWS ECS
name: Build and Push to ECR

# Bad
name: CI
name: Deploy
name: Build
```

### File Organization

```
.github/
└── workflows/
    ├── ci-python.yml          # Backend CI
    ├── ci-typescript.yml      # Frontend CI
    ├── ci-full-stack.yml      # Combined CI (alternative)
    ├── build-ecr.yml          # Docker build and push
    ├── deploy-aws.yml         # ECS deployment
    └── release.yml            # Release automation
```

### Trigger Configuration

**Standard**: Use specific path filters and branch patterns.

```yaml
on:
  pull_request:
    branches: [main, develop]
    paths:
      - 'backend/**'
      - '**/*.py'
      - 'pyproject.toml'
  push:
    branches: [main]
```

**Best Practices**:
- Use path filters to avoid unnecessary runs
- Separate PR and push triggers
- Use workflow_dispatch for manual runs

## Performance Standards

### Build Time Targets

| Workflow | Target Time (cached) | Target Time (uncached) |
|----------|---------------------|------------------------|
| Python CI | < 3 minutes | < 8 minutes |
| TypeScript CI | < 3 minutes | < 8 minutes |
| Full-Stack CI | < 5 minutes | < 12 minutes |
| Docker Build | < 5 minutes | < 10 minutes |
| ECS Deploy | < 5 minutes | N/A |

### Caching Strategy

**Required Caching**:
1. **Docker Layer Cache**: Use GitHub Actions cache or GHCR
2. **Dependency Cache**: npm, pip, poetry caches
3. **Test Results**: For incremental testing

**Cache Keys**:
```yaml
# Docker layers
key: ${{ runner.os }}-buildx-${{ hashFiles('**/Dockerfile*', '**/package*.json') }}

# Dependencies
key: ${{ runner.os }}-deps-${{ hashFiles('**/poetry.lock') }}
```

### Optimization Techniques

1. **Multi-Stage Docker Builds**:
   - Share base layers across stages
   - Minimize layer count
   - Order layers by change frequency

2. **Parallel Container Builds**:
   ```bash
   build_python &
   build_typescript &
   wait
   ```

3. **Conditional Execution**:
   ```yaml
   if: steps.changes.outputs.backend == 'true'
   ```

## Security Standards

### OIDC Authentication

**Standard**: Use OIDC for AWS authentication, never long-lived credentials.

**Implementation**:
```yaml
- name: Configure AWS credentials
  uses: aws-actions/configure-aws-credentials@v4
  with:
    role-to-assume: ${{ secrets.AWS_ROLE_ARN }}
    aws-region: ${{ env.AWS_REGION }}
```

**Requirements**:
- AWS OIDC provider configured
- IAM role with trust relationship to GitHub
- Minimal permissions (least privilege)

### Secret Management

**Standard**: All sensitive data in GitHub Secrets, never in code.

**Required Secrets**:
```
AWS_ROLE_ARN          # For AWS OIDC
AWS_REGION            # For AWS services
API_URL               # For frontend builds (optional)
```

**Never Store**:
- AWS access keys (use OIDC)
- API keys in plaintext
- Database passwords
- Private keys

### Permissions

**Standard**: Minimal required permissions per job.

```yaml
permissions:
  id-token: write    # For OIDC
  contents: read     # For checkout
  packages: write    # For GHCR push
```

### Security Scanning

**Required Scans**:
- **Bandit**: Python security issues
- **Dependency Check**: Known vulnerabilities
- **Docker Scan**: Container vulnerabilities
- **License Check**: OSS compliance

## Testing Standards

### Coverage Requirements

**Standard**: Maintain minimum code coverage.

```
Minimum Coverage: 80%
Target Coverage: 90%
Critical Paths: 100%
```

### Test Organization

```python
# Backend (pytest)
tests/
├── unit/           # Unit tests (fast)
├── integration/    # Integration tests
└── e2e/           # End-to-end tests

# Frontend (Vitest)
src/
└── __tests__/     # Component tests
```

### Test Execution

**Standard**: Run tests in order of speed.

```yaml
1. Linting (fastest, fails fast)
2. Unit tests (fast)
3. Integration tests (medium)
4. E2E tests (slowest)
```

## Deployment Standards

### Environment Strategy

**Standard**: Three-tier deployment.

```
dev → staging → production
```

**Configuration**:
```yaml
on:
  workflow_dispatch:
    inputs:
      environment:
        type: choice
        options: [dev, staging, prod]
```

### Zero-Downtime Deployment

**Standard**: Use ECS rolling updates with health checks.

```yaml
- uses: aws-actions/amazon-ecs-deploy-task-definition@v1
  with:
    wait-for-service-stability: true
    wait-for-minutes: 10
```

### Deployment Verification

**Required Checks**:
1. Service health status
2. Task count (running == desired)
3. Deployment status
4. Health check endpoint

### Rollback Strategy

**Standard**: Automatic rollback on failed health checks.

**Process**:
1. ECS detects failed health checks
2. Stops new task deployment
3. Rolls back to previous task definition
4. Alerts team

## Monitoring and Observability

### Status Badges

**Standard**: Add status badges to README.

```markdown
![Lint](https://github.com/USER/REPO/workflows/Python%20CI/badge.svg)
![Test](https://github.com/USER/REPO/workflows/Testing/badge.svg)
![Deploy](https://github.com/USER/REPO/workflows/Deploy/badge.svg)
```

### Workflow Summaries

**Standard**: Generate comprehensive summaries for all workflows.

```yaml
- name: Generate summary
  run: |
    echo "## 🔍 CI Summary" >> $GITHUB_STEP_SUMMARY
    echo "Tests: PASSED" >> $GITHUB_STEP_SUMMARY
    echo "Coverage: 87%" >> $GITHUB_STEP_SUMMARY
```

### Notifications

**Optional**: Slack/email notifications for critical workflows.

```yaml
# On deployment
- name: Notify Slack
  if: always()
  uses: slackapi/slack-github-action@v1
```

## Branch Protection Rules

### Required Checks

**Standard**: Enforce CI checks before merge.

**GitHub Settings**:
```
Settings → Branches → main

Required status checks:
  - Python CI (or Full-Stack CI)
  - TypeScript CI (or Full-Stack CI)
  - Integration Tests (if configured)

Required reviews: 1
Require linear history: true
```

### Merge Strategies

**Standard**: Squash and merge for cleaner history.

```
Merge Strategy: Squash and merge
Commit Message: PR title + description
```

## Workflow Maintenance

### Version Updates

**Standard**: Keep actions updated to latest stable versions.

**Update Cadence**: Monthly

**Common Actions**:
```yaml
actions/checkout@v4
docker/setup-buildx-action@v3
aws-actions/configure-aws-credentials@v4
```

### Workflow Testing

**Standard**: Test workflow changes in feature branch first.

**Process**:
1. Create feature branch
2. Update workflow
3. Push and observe workflow run
4. Verify all jobs pass
5. Merge to main

## Error Handling

### Failure Notifications

**Standard**: Always notify on failure in critical workflows.

```yaml
- name: Handle failure
  if: failure()
  run: |
    echo "::error::Workflow failed"
    # Send notification
```

### Debugging

**Enable Debug Logs**:
```yaml
env:
  ACTIONS_STEP_DEBUG: true
  ACTIONS_RUNNER_DEBUG: true
```

### Artifacts

**Standard**: Upload artifacts for debugging.

```yaml
- uses: actions/upload-artifact@v4
  if: always()
  with:
    name: test-results
    path: |
      coverage/
      logs/
    retention-days: 30
```

## Documentation Requirements

### Workflow Documentation

**Required**:
- Purpose comment at top of file
- Scope and dependencies
- Customization instructions
- Example configurations

### README Updates

**Standard**: Document CI/CD setup in project README.

**Required Sections**:
```markdown
## CI/CD

- Workflows
- Status badges
- How to run locally
- How to deploy
```

## Compliance and Auditing

### Audit Trail

**Standard**: All deployments must be traceable.

**Required Information**:
- Commit SHA
- Deployer (GitHub actor)
- Timestamp
- Environment
- Previous version

### Approval Gates

**Production Deployments**:
- Required approval from team lead
- Must pass all tests
- Must include release notes

## Best Practices Summary

✅ **DO**:
- Use Docker-first CI/CD with registry caching
- Run jobs in parallel when possible
- Use change detection for selective testing
- Implement OIDC for AWS authentication
- Cache aggressively (dependencies, Docker layers)
- Generate comprehensive workflow summaries
- Keep workflows DRY with reusable actions
- Test workflows in feature branches

❌ **DON'T**:
- Store secrets in code or environment variables (use GitHub Secrets)
- Use long-lived AWS credentials
- Run all tests on every change (use change detection)
- Skip linting to save time (fails fast is good)
- Deploy without health checks
- Leave workflow actions outdated
- Ignore failed workflows
- Mix development and deployment in same workflow

## Migration Checklist

When adopting these standards:

- [ ] Dockerfiles have multi-stage builds (base, dev, lint, test, prod)
- [ ] GHCR caching configured for linting containers
- [ ] Conditional rebuild logic based on dependency changes
- [ ] Workflows use parallel execution where possible
- [ ] Change detection configured for selective testing
- [ ] AWS OIDC configured (no long-lived credentials)
- [ ] All secrets in GitHub Secrets
- [ ] Minimal permissions per job
- [ ] Security scanning enabled
- [ ] Coverage reporting configured
- [ ] Status badges in README
- [ ] Workflow summaries generated
- [ ] Branch protection rules enabled
- [ ] Deployment requires approval for production
- [ ] All workflows documented
- [ ] Make targets match CI commands

## Resources

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Docker BuildKit](https://docs.docker.com/build/buildkit/)
- [AWS OIDC Setup](https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/configuring-openid-connect-in-amazon-web-services)
- [GitHub Container Registry](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry)
