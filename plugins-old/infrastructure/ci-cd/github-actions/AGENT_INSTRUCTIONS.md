# GitHub Actions CI/CD Plugin - Agent Instructions

**Purpose**: Install and configure GitHub Actions CI/CD workflows for automated testing, linting, building, and deployment

**Scope**: Complete CI/CD pipeline setup with workflows for Python, TypeScript, Docker, and AWS deployment

**Prerequisites**:
- GitHub repository initialized
- `.ai/` folder exists (foundation plugin installed)
- At least one language plugin installed (Python or TypeScript)
- (Optional) Docker plugin for containerized CI/CD
- (Optional) AWS infrastructure for deployment workflows

## Installation Steps

### Step 1: Assess Project Requirements

Determine which workflows are needed based on installed plugins:

```bash
# Check for Python plugin
if [ -f "pyproject.toml" ] || [ -d "plugins/languages/python" ]; then
  NEEDS_PYTHON_CI=true
fi

# Check for TypeScript plugin
if [ -f "package.json" ] || [ -f "tsconfig.json" ]; then
  NEEDS_TYPESCRIPT_CI=true
fi

# Check for Docker
if [ -f "Dockerfile" ] || [ -f "docker-compose.yml" ]; then
  HAS_DOCKER=true
fi

# Check for AWS deployment
if [ -d "infra/terraform" ]; then
  NEEDS_AWS_DEPLOY=true
fi
```

### Step 2: Create Workflow Directory

```bash
mkdir -p .github/workflows
```

### Step 3: Copy Workflow Templates

Based on project requirements, copy appropriate workflow templates:

#### For Python Projects:
```bash
cp plugins/infrastructure/ci-cd/github-actions/templates/ci-python.yml .github/workflows/lint.yml
```

#### For TypeScript Projects:
```bash
cp plugins/infrastructure/ci-cd/github-actions/templates/ci-typescript.yml .github/workflows/lint-frontend.yml
```

#### For Full-Stack Projects (Python + TypeScript):
```bash
cp plugins/infrastructure/ci-cd/github-actions/templates/ci-full-stack.yml .github/workflows/lint.yml
cp plugins/infrastructure/ci-cd/github-actions/templates/ci-full-stack.yml .github/workflows/test.yml
```

#### For Docker Build/Push:
```bash
cp plugins/infrastructure/ci-cd/github-actions/templates/build-ecr.yml .github/workflows/build-and-push.yml
```

#### For AWS Deployment:
```bash
cp plugins/infrastructure/ci-cd/github-actions/templates/deploy-aws.yml .github/workflows/deploy.yml
```

#### For Release Management:
```bash
cp plugins/infrastructure/ci-cd/github-actions/templates/release.yml .github/workflows/release.yml
```

### Step 4: Customize Workflows

Edit copied workflow files to match your project configuration:

#### Common Customizations:

1. **Project Name**:
   - Replace `{{PROJECT_NAME}}` with your actual project name
   - Update image names, service names, etc.

2. **Version Numbers**:
   - Set `PYTHON_VERSION` (default: '3.11')
   - Set `NODE_VERSION` (default: '20')
   - Set `POETRY_VERSION` if using Poetry

3. **AWS Configuration** (if using AWS workflows):
   - Set `AWS_REGION` (e.g., 'us-west-2')
   - Set ECR repository names
   - Set ECS cluster and service names
   - Set task definition names

4. **Branch Strategy**:
   - Update branch names in triggers (e.g., 'main', 'develop')
   - Configure path filters for selective workflows

5. **Docker Registry**:
   - Configure GHCR (GitHub Container Registry) for caching
   - Update registry URLs if using custom registry

### Step 5: Configure GitHub Secrets

For workflows to function, configure these GitHub Secrets:

#### Required for AWS Deployment:
```
AWS_ROLE_ARN              # AWS IAM role ARN for OIDC authentication
AWS_REGION                # AWS region (e.g., us-west-2)
```

#### Optional Secrets:
```
GITHUB_TOKEN              # Automatically provided by GitHub Actions
API_URL                   # Backend API URL for frontend builds
SLACK_WEBHOOK_URL         # For deployment notifications
```

**To add secrets**:
1. Go to repository Settings → Secrets and variables → Actions
2. Click "New repository secret"
3. Add each required secret

### Step 6: Configure AWS OIDC (if using AWS deployment)

For secure AWS authentication without long-lived credentials:

1. **Create OIDC Provider in AWS**:
```bash
aws iam create-open-id-connect-provider \
  --url https://token.actions.githubusercontent.com \
  --client-id-list sts.amazonaws.com \
  --thumbprint-list 6938fd4d98bab03faadb97b34396831e3780aea1
```

2. **Create IAM Role**:
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

3. **Attach Policies**:
   - ECR push/pull permissions
   - ECS task definition and service update permissions
   - CloudWatch Logs (for monitoring)

### Step 7: Update Project Documentation

Update `.ai/index.yaml` to reference new workflows:

```yaml
ci_cd:
  platform: github-actions
  workflows:
    - name: lint
      file: .github/workflows/lint.yml
      triggers: [pull_request, push]
    - name: test
      file: .github/workflows/test.yml
      triggers: [pull_request, push]
    - name: build
      file: .github/workflows/build-and-push.yml
      triggers: [push]
    - name: deploy
      file: .github/workflows/deploy.yml
      triggers: [push, workflow_dispatch]
```

## Workflow Architecture

### Docker-First CI/CD Pattern

This plugin implements a Docker-first CI/CD approach:

1. **Dedicated Linting Containers**:
   - Separate linting stage in multi-stage Dockerfiles
   - Pre-built containers cached in GHCR
   - 80-90% faster builds when using cached images

2. **Registry-Based Caching**:
   - Uses GitHub Container Registry (GHCR)
   - Conditional rebuilds based on file changes
   - Parallel container builds for speed

3. **Multi-Stage Docker Builds**:
   - `base`: Shared dependencies
   - `dev`: Development environment
   - `lint`: Linting tools only
   - `test`: Testing environment
   - `prod`: Production runtime

### Workflow Execution Flow

#### Standard CI Flow:
```
1. Trigger (PR or push)
   ↓
2. Detect changes (backend/frontend/both)
   ↓
3. Build or pull linting containers (parallel)
   ↓
4. Run linting (Ruff, ESLint, MyPy, etc.)
   ↓
5. Build dev containers (parallel)
   ↓
6. Run tests with coverage
   ↓
7. Upload coverage reports
```

#### Build & Deploy Flow:
```
1. Tests pass on main branch
   ↓
2. Build production images (multi-platform)
   ↓
3. Push to ECR with tags (latest, commit SHA, branch)
   ↓
4. Update ECS task definitions
   ↓
5. Deploy to ECS (zero-downtime)
   ↓
6. Verify service health
```

## Integration with Language Plugins

### Python Integration

The Python CI workflow integrates with Python plugin features:

**Linting Tools**:
- Ruff (fast linting)
- Black (code formatting check)
- MyPy (type checking)
- Bandit (security scanning)
- Pylint (comprehensive linting)
- Flake8 suite (style enforcement)
- Radon (complexity analysis)
- Xenon (complexity enforcement)

**Testing**:
- pytest with coverage
- Parallel test execution
- Coverage reporting to GitHub

**Make Targets Used**:
```bash
make lint-python        # All Python linting
make test-python        # Run Python tests
make format-check-python # Verify formatting
```

### TypeScript Integration

The TypeScript CI workflow integrates with TypeScript plugin features:

**Linting Tools**:
- ESLint (code quality)
- Prettier (formatting check)
- TypeScript compiler (type checking)

**Testing**:
- Vitest (unit and component tests)
- Coverage reporting
- React component testing

**Make Targets Used**:
```bash
make lint-typescript     # All TypeScript linting
make test-typescript     # Run TypeScript tests
make format-check-typescript # Verify formatting
```

## Performance Optimizations

### 1. Registry Caching

Workflows use GHCR to cache pre-built linting containers:

```yaml
- name: Check if linting dependencies changed
  id: lint-deps-check
  run: |
    # Only rebuild if Dockerfile or dependencies changed
    if git diff HEAD~1 HEAD | grep -E "(Dockerfile|package.json|pyproject.toml)"; then
      echo "rebuild_needed=true"
    else
      echo "rebuild_needed=false"
      # Pull from cache instead
    fi
```

**Result**: 80-90% faster CI runs when dependencies haven't changed.

### 2. Parallel Execution

Build containers in parallel:

```yaml
build_python &
build_typescript &
wait  # Wait for both to complete
```

### 3. Change Detection

Run only relevant tests based on changed files:

```yaml
- uses: dorny/paths-filter@v2
  id: changes
  with:
    filters: |
      backend: 'backend/**'
      frontend: 'frontend/**'

# Only run backend tests if backend changed
- if: steps.changes.outputs.backend == 'true'
  run: make test-python
```

### 4. Matrix Testing

Test across multiple versions in parallel:

```yaml
strategy:
  matrix:
    python-version: ['3.10', '3.11', '3.12']
    node-version: ['18', '20']
```

## Security Best Practices

### 1. OIDC Authentication

Use AWS OIDC instead of long-lived credentials:
- No IAM access keys in secrets
- Temporary credentials for each workflow run
- Scoped to specific repository

### 2. Secret Management

Store sensitive data in GitHub Secrets:
- AWS credentials
- API keys
- Database passwords
- Never commit secrets to code

### 3. Security Scanning

Every workflow includes security checks:
- Bandit for Python security issues
- Dependency vulnerability scanning
- Docker image scanning
- License compliance checking

### 4. Least Privilege

Grant minimal required permissions:
```yaml
permissions:
  id-token: write    # For OIDC
  contents: read     # For checkout
  packages: write    # For GHCR push
```

## Monitoring and Debugging

### Workflow Status Badges

Add status badges to README.md:

```markdown
![Lint Status](https://github.com/OWNER/REPO/workflows/Linting/badge.svg)
![Test Status](https://github.com/OWNER/REPO/workflows/Testing/badge.svg)
![Deploy Status](https://github.com/OWNER/REPO/workflows/Deploy/badge.svg)
```

### Viewing Workflow Runs

1. Go to repository Actions tab
2. Click on specific workflow
3. View logs for each step
4. Download artifacts (coverage reports)

### Common Issues

#### Issue: Linting container build fails
**Solution**: Check Dockerfile syntax and dependencies

#### Issue: Tests fail in CI but pass locally
**Solution**: Ensure Docker containers match local environment

#### Issue: AWS deployment fails
**Solution**: Verify OIDC role permissions and ECS configuration

#### Issue: Cache not working
**Solution**: Check cache key configuration and GHCR permissions

## Post-Installation Checklist

- [ ] Workflows copied to `.github/workflows/`
- [ ] Project-specific values customized (names, versions, regions)
- [ ] GitHub Secrets configured (AWS credentials)
- [ ] AWS OIDC provider and role created (if using AWS)
- [ ] First workflow run successful
- [ ] Status badges added to README
- [ ] `.ai/index.yaml` updated with workflow information
- [ ] Team notified of new CI/CD pipeline

## Available Make Targets

If using with Docker plugin, these Make targets integrate with CI/CD:

```bash
# Linting (matches CI workflow)
make lint-all              # Run all linting
make lint-python           # Python linting only
make lint-typescript       # TypeScript linting only

# Testing (matches CI workflow)
make test-all              # Run all tests
make test-python           # Python tests only
make test-typescript       # TypeScript tests only

# Building (for local testing)
make build-all             # Build all containers
make build-python          # Build Python containers
make build-typescript      # Build TypeScript containers
```

## Next Steps

After installation:

1. **Test Locally**: Run `make lint-all` and `make test-all` locally to verify
2. **First Push**: Push to a feature branch and create PR to test CI
3. **Monitor**: Watch Actions tab for workflow execution
4. **Iterate**: Adjust workflows based on project needs
5. **Deploy**: Once CI is green, configure deployment workflows

## Related Documentation

- **How-to Guides**:
  - `howtos/how-to-add-workflow.md` - Creating custom workflows
  - `howtos/how-to-configure-secrets.md` - Managing secrets
  - `howtos/how-to-add-deployment.md` - AWS deployment setup

- **Standards**:
  - `standards/CI_CD_STANDARDS.md` - CI/CD best practices

- **Templates**:
  - `templates/ci-python.yml` - Python CI workflow
  - `templates/ci-typescript.yml` - TypeScript CI workflow
  - `templates/ci-full-stack.yml` - Full-stack CI workflow
  - `templates/build-ecr.yml` - Docker build and push
  - `templates/deploy-aws.yml` - AWS ECS deployment
  - `templates/release.yml` - Release automation

## Support

For issues or questions:
1. Check `standards/CI_CD_STANDARDS.md` for best practices
2. Review workflow logs in GitHub Actions tab
3. Consult GitHub Actions documentation
4. Review how-to guides in `howtos/` directory
