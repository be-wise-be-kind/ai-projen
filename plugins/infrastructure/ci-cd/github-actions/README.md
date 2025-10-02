# GitHub Actions CI/CD Plugin

**Purpose**: Complete GitHub Actions CI/CD pipeline for automated testing, linting, building, and deployment

**Scope**: Production-grade workflows for Python, TypeScript, Docker, and AWS deployment with advanced caching

## Overview

This plugin provides a comprehensive GitHub Actions CI/CD system implementing:

- **Docker-First CI/CD**: Dedicated linting containers with registry caching
- **Multi-Language Support**: Python and TypeScript workflows
- **Performance Optimizations**: 80-90% faster builds with GHCR caching
- **AWS Deployment**: Zero-downtime ECS deployments with OIDC authentication
- **Security**: Built-in security scanning, secrets management, and OIDC
- **Matrix Testing**: Test across multiple language versions in parallel

## Features

### 🚀 CI/CD Workflows

#### Python CI Workflow
- **Linting**: Ruff, Black, MyPy, Bandit, Pylint, Flake8, Radon, Xenon
- **Testing**: pytest with coverage reporting
- **Security**: Bandit security scanning, dependency checking
- **Type Checking**: MyPy static type analysis
- **Complexity**: Radon complexity metrics, Xenon enforcement
- **Caching**: GHCR-based linting container caching

#### TypeScript CI Workflow
- **Linting**: ESLint with React rules
- **Testing**: Vitest with component testing
- **Formatting**: Prettier validation
- **Type Checking**: TypeScript compiler
- **Coverage**: Comprehensive coverage reporting
- **Caching**: GHCR-based linting container caching

#### Full-Stack CI Workflow
- **Parallel Execution**: Backend and frontend in parallel
- **Change Detection**: Run only affected test suites
- **Integration Tests**: Playwright end-to-end testing
- **Combined Coverage**: Aggregate coverage from all sources
- **Smart Caching**: Multi-stage Docker builds with shared layers

### 🐳 Docker Build Workflow

- **Multi-Platform**: amd64 and arm64 architecture support
- **ECR Push**: Automated push to AWS Elastic Container Registry
- **Tagging Strategy**:
  - `latest` - Most recent main branch build
  - `<commit-sha>` - Specific commit identifier
  - `<branch-name>` - Branch-based tags
- **Build Cache**: GitHub Actions cache for faster builds
- **OIDC Auth**: Secure AWS authentication without long-lived credentials

### ☁️ AWS Deployment Workflow

- **Multi-Environment**: dev, staging, and production support
- **Zero-Downtime**: Rolling ECS updates with health checks
- **Task Definitions**: Automated task definition updates
- **Service Health**: Monitoring and verification
- **Rollback**: Automatic rollback on failed deployments
- **Manual Dispatch**: On-demand deployments with environment selection

### 📦 Release Workflow

- **Semantic Versioning**: Automated version bumping
- **Changelog**: Auto-generated changelog from commits
- **GitHub Releases**: Automated release creation
- **Asset Upload**: Attach build artifacts to releases
- **Tag Management**: Git tag creation and management

## Installation

### Prerequisites

1. **GitHub Repository**: Repository must exist
2. **Language Plugin**: At least one language plugin installed (Python or TypeScript)
3. **Docker** (optional): For Docker-based CI/CD
4. **AWS Account** (optional): For deployment workflows

### Quick Start

```bash
# 1. Install foundation plugin (if not already installed)
# See plugins/foundation/ai-folder/AGENT_INSTRUCTIONS.md

# 2. Copy workflow templates
cp plugins/infrastructure/ci-cd/github-actions/templates/ci-python.yml .github/workflows/
cp plugins/infrastructure/ci-cd/github-actions/templates/deploy-aws.yml .github/workflows/

# 3. Customize workflows
# Edit .github/workflows/*.yml files to match your project

# 4. Configure GitHub Secrets
# Go to Settings → Secrets → Actions
# Add: AWS_ROLE_ARN, AWS_REGION

# 5. Push and test
git add .github/workflows/
git commit -m "feat: Add GitHub Actions CI/CD"
git push
```

### Detailed Installation

See [AGENT_INSTRUCTIONS.md](AGENT_INSTRUCTIONS.md) for complete installation guide.

## Workflow Templates

### Available Templates

| Template | Purpose | Language | AWS |
|----------|---------|----------|-----|
| `ci-python.yml` | Python CI/CD | Python | No |
| `ci-typescript.yml` | TypeScript CI/CD | TypeScript | No |
| `ci-full-stack.yml` | Full-stack CI/CD | Both | No |
| `build-ecr.yml` | Build & push to ECR | Any | Yes |
| `deploy-aws.yml` | Deploy to ECS | Any | Yes |
| `release.yml` | Release automation | Any | No |

### Template Customization

Each template includes placeholder variables:

```yaml
# Replace these in workflow files
{{PROJECT_NAME}}           # Your project name
{{PYTHON_VERSION}}         # e.g., '3.11'
{{NODE_VERSION}}          # e.g., '20'
{{AWS_REGION}}            # e.g., 'us-west-2'
{{ECR_REPOSITORY}}        # ECR repository name
{{ECS_CLUSTER}}           # ECS cluster name
{{ECS_SERVICE}}           # ECS service name
```

## Architecture

### Docker-First CI/CD Pattern

```
┌─────────────────────────────────────────────────────┐
│                  GitHub Actions                      │
├─────────────────────────────────────────────────────┤
│                                                      │
│  ┌──────────────┐  ┌──────────────┐  ┌───────────┐ │
│  │   Checkout   │→ │  Detect      │→ │  Cache    │ │
│  │   Code       │  │  Changes     │  │  Check    │ │
│  └──────────────┘  └──────────────┘  └───────────┘ │
│                                                      │
│  ┌──────────────────────────────────────────────┐  │
│  │  Build/Pull Linting Containers (Parallel)    │  │
│  │  ┌──────────────┐    ┌──────────────┐        │  │
│  │  │   Python     │    │  TypeScript  │        │  │
│  │  │   Linter     │    │  Linter      │        │  │
│  │  └──────────────┘    └──────────────┘        │  │
│  └──────────────────────────────────────────────┘  │
│                                                      │
│  ┌──────────────────────────────────────────────┐  │
│  │  Run Linting (Parallel)                      │  │
│  │  • Ruff, MyPy, Bandit, Pylint               │  │
│  │  • ESLint, Prettier, TSC                     │  │
│  └──────────────────────────────────────────────┘  │
│                                                      │
│  ┌──────────────────────────────────────────────┐  │
│  │  Run Tests with Coverage                     │  │
│  │  • pytest (Python)                           │  │
│  │  • Vitest (TypeScript)                       │  │
│  │  • Playwright (Integration)                  │  │
│  └──────────────────────────────────────────────┘  │
│                                                      │
│  ┌──────────────────────────────────────────────┐  │
│  │  Build Production Images (if on main)        │  │
│  │  • Multi-platform (amd64/arm64)              │  │
│  │  • Push to ECR                               │  │
│  └──────────────────────────────────────────────┘  │
│                                                      │
│  ┌──────────────────────────────────────────────┐  │
│  │  Deploy to AWS ECS (if on main)              │  │
│  │  • Update task definitions                   │  │
│  │  • Zero-downtime deployment                  │  │
│  │  • Health check verification                 │  │
│  └──────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────┘
```

### Registry Caching Strategy

```
┌─────────────────────────────────────────────────────┐
│         GitHub Container Registry (GHCR)            │
├─────────────────────────────────────────────────────┤
│                                                      │
│  ┌─────────────────┐  ┌─────────────────┐         │
│  │  Python Linter  │  │  JS Linter      │         │
│  │  Image Cache    │  │  Image Cache    │         │
│  └─────────────────┘  └─────────────────┘         │
│                                                      │
│  Updated when:                                      │
│  • Dockerfile changes                               │
│  • Dependencies change (pyproject.toml, package.json)│
│  • Push to main branch (refresh cache)             │
│                                                      │
│  Benefits:                                          │
│  • 80-90% faster CI runs                           │
│  • No rebuild on every PR                          │
│  • Consistent linting environment                  │
└─────────────────────────────────────────────────────┘
```

## Performance Metrics

### Before Optimization
- Average CI run: **8-12 minutes**
- Container builds: **5-7 minutes**
- Linting: **2-3 minutes**
- Tests: **3-4 minutes**

### After Optimization (with caching)
- Average CI run: **2-3 minutes** (75% reduction)
- Container pulls: **30-60 seconds** (cached)
- Linting: **1-2 minutes**
- Tests: **1-2 minutes**

### Optimization Techniques
1. **GHCR Registry Caching**: Pre-built linting containers
2. **Conditional Rebuilds**: Only rebuild when dependencies change
3. **Parallel Execution**: Run Python and TypeScript jobs concurrently
4. **Layer Caching**: Multi-stage Dockerfiles with shared base layers
5. **Change Detection**: Run only affected test suites

## Security

### OIDC Authentication

Use AWS OIDC for secure, keyless authentication:

```yaml
- name: Configure AWS credentials
  uses: aws-actions/configure-aws-credentials@v4
  with:
    role-to-assume: ${{ secrets.AWS_ROLE_ARN }}
    aws-region: ${{ env.AWS_REGION }}
```

**Benefits**:
- No long-lived AWS access keys
- Temporary credentials per workflow run
- Scoped to specific repository
- Automatic rotation

### Secret Management

Store sensitive data in GitHub Secrets:

```bash
# Required for AWS deployment
AWS_ROLE_ARN              # IAM role ARN for OIDC
AWS_REGION                # AWS region

# Optional
API_URL                   # Backend API URL
SLACK_WEBHOOK_URL         # Deployment notifications
```

### Security Scanning

Every workflow includes:
- **Bandit**: Python security vulnerability scanning
- **Dependency Check**: Known vulnerability detection
- **License Check**: OSS license compliance
- **Docker Scan**: Container image vulnerability scanning

## Integration with Language Plugins

### Python Plugin Integration

Works seamlessly with Python plugin features:

```bash
# Makefile targets used in CI
make lint-python          # Ruff, MyPy, Bandit, Pylint
make test-python          # pytest with coverage
make format-check-python  # Black formatting validation
```

**Linting Tools**:
- Ruff (fast linting)
- MyPy (type checking)
- Bandit (security)
- Pylint (comprehensive)
- Flake8 suite (style)
- Radon (complexity)
- Xenon (complexity enforcement)

### TypeScript Plugin Integration

Works seamlessly with TypeScript plugin features:

```bash
# Makefile targets used in CI
make lint-typescript       # ESLint + Prettier
make test-typescript       # Vitest with coverage
make format-check-typescript # Prettier validation
```

**Linting Tools**:
- ESLint (code quality)
- Prettier (formatting)
- TypeScript compiler (type checking)

### Docker Plugin Integration

Leverages Docker plugin for containerized CI/CD:

```bash
# Docker-based CI commands
make lint-all             # Uses linting containers
make test-all             # Uses dev containers
make build-all            # Build production images
```

## Common Workflows

### Standard Pull Request Flow

```bash
1. Developer creates feature branch
2. Push triggers CI workflows:
   - lint.yml (Python/TypeScript linting)
   - test.yml (All tests with coverage)
3. PR shows status checks
4. Merge to main triggers:
   - build-and-push.yml (Build Docker images)
   - deploy.yml (Deploy to dev environment)
```

### Release Flow

```bash
1. Create release via GitHub UI or workflow_dispatch
2. release.yml workflow:
   - Bumps version (semantic versioning)
   - Generates changelog
   - Creates GitHub release
   - Uploads build artifacts
3. Deploy to staging
4. Manual promotion to production
```

### Hotfix Flow

```bash
1. Create hotfix branch from main
2. CI runs on PR
3. Emergency merge to main
4. Automatic deployment to production
5. Tag as hotfix release
```

## Monitoring

### Status Badges

Add to README.md:

```markdown
![Lint](https://github.com/USER/REPO/workflows/Linting/badge.svg)
![Test](https://github.com/USER/REPO/workflows/Testing/badge.svg)
![Deploy](https://github.com/USER/REPO/workflows/Deploy/badge.svg)
```

### Workflow Summaries

Each workflow generates a summary visible in the Actions tab:

```
🔍 Linting Summary
✓ Python linting completed
✓ TypeScript linting completed
⚡ Cache hit: 90% faster build

🧪 Test Summary
✓ Backend tests: 247 passed
✓ Frontend tests: 183 passed
✓ Coverage: 87%

🚀 Deployment Summary
✓ Deployed to dev environment
✓ Service health: OK
✓ URL: https://dev.example.com
```

## Troubleshooting

### Common Issues

| Issue | Solution |
|-------|----------|
| Linting container build fails | Check Dockerfile and dependencies |
| Tests pass locally, fail in CI | Ensure Docker environment matches local |
| AWS deployment fails | Verify OIDC role permissions |
| Cache not working | Check cache key and GHCR permissions |
| Slow CI runs | Enable GHCR caching, use parallel jobs |

### Debug Mode

Enable debug logging:

```yaml
env:
  ACTIONS_STEP_DEBUG: true
  ACTIONS_RUNNER_DEBUG: true
```

## How-To Guides

- [How to Add a Workflow](howtos/how-to-add-workflow.md)
- [How to Configure Secrets](howtos/how-to-configure-secrets.md)
- [How to Add AWS Deployment](howtos/how-to-add-deployment.md)

## Standards

See [ci-cd-standards.md](standards/ci-cd-standards.md) for:
- Workflow naming conventions
- Branch protection rules
- Deployment strategies
- Security best practices
- Performance guidelines

## Examples

### Minimal Python Project

```yaml
# .github/workflows/ci.yml
name: CI
on: [pull_request, push]
jobs:
  lint-and-test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: make lint-python
      - run: make test-python
```

### Full-Stack with Deployment

```yaml
# Uses all workflow templates
- ci-full-stack.yml     # CI for both stacks
- build-ecr.yml         # Build Docker images
- deploy-aws.yml        # Deploy to ECS
- release.yml           # Release management
```

## Migration Guide

### From CircleCI

1. Copy workflow templates
2. Replace CircleCI orbs with GitHub Actions
3. Update cache keys
4. Configure GitHub Secrets

### From Jenkins

1. Convert Jenkinsfile to YAML workflows
2. Replace Jenkins plugins with GitHub Actions
3. Update environment variables
4. Configure OIDC for AWS

## Contributing

To add new workflow templates:

1. Create workflow in `templates/`
2. Update `manifest.yaml`
3. Add how-to guide in `howtos/`
4. Update this README
5. Test in a real project

## Support

- **Documentation**: See `AGENT_INSTRUCTIONS.md`
- **How-To Guides**: See `howtos/` directory
- **Standards**: See `standards/ci-cd-standards.md`
- **GitHub Actions Docs**: https://docs.github.com/en/actions

## License

Part of the ai-projen framework. See repository license.
