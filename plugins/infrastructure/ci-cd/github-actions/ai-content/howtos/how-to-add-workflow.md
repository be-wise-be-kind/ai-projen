# How-To: Add a GitHub Actions Workflow

**Purpose**: Create custom CI/CD workflows with proper triggers and jobs

**Scope**: Workflow creation from templates to customized automation

**Prerequisites**:
- GitHub repository configured
- GitHub Actions plugin installed
- Basic understanding of YAML syntax
- Understanding of your project structure

**Estimated Time**: 30-45 minutes

**Difficulty**: Intermediate

## Overview

This guide walks through creating a new GitHub Actions workflow from scratch or from a template. You'll learn how to configure triggers, define jobs, use caching, and integrate with other workflows.

## Step 1: Choose a Template or Start Fresh

### Option A: Use Existing Template

Choose from available templates based on your needs:

```bash
# For Python projects
cp plugins/infrastructure/ci-cd/github-actions/templates/ci-python.yml .github/workflows/

# For TypeScript projects
cp plugins/infrastructure/ci-cd/github-actions/templates/ci-typescript.yml .github/workflows/

# For full-stack projects
cp plugins/infrastructure/ci-cd/github-actions/templates/ci-full-stack.yml .github/workflows/

# For AWS deployment
cp plugins/infrastructure/ci-cd/github-actions/templates/deploy-aws.yml .github/workflows/
```

### Option B: Start from Scratch

Create a new workflow file:

```bash
touch .github/workflows/custom-workflow.yml
```

Basic structure:

```yaml
# Purpose: Brief description of what this workflow does
# Scope: What it covers
# Dependencies: What it needs

name: Custom Workflow

on:
  pull_request:
    branches: [main]
  push:
    branches: [main]

env:
  # Environment variables

jobs:
  job-name:
    name: Job Display Name
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      # Add your steps
```

**Template**: `templates/ci-python.yml` or `templates/ci-typescript.yml`

## Step 2: Configure Workflow Triggers

### Common Trigger Patterns

#### Pull Request Trigger

```yaml
on:
  pull_request:
    branches: [main, develop]
    paths:
      - 'backend/**'
      - '**/*.py'
      - 'pyproject.toml'
```

**Use when**: You want to run checks on PRs before merging

#### Push Trigger

```yaml
on:
  push:
    branches: [main]
    paths:
      - 'backend/**'
```

**Use when**: You want to run on every push to specific branches

#### Schedule Trigger

```yaml
on:
  schedule:
    - cron: '0 0 * * *'  # Daily at midnight UTC
```

**Use when**: You want periodic runs (nightly tests, security scans)

#### Manual Trigger

```yaml
on:
  workflow_dispatch:
    inputs:
      environment:
        description: 'Environment to deploy'
        required: true
        type: choice
        options: [dev, staging, prod]
```

**Use when**: You want manual control over when workflow runs

#### Combined Triggers

```yaml
on:
  pull_request:
    branches: [main, develop]
  push:
    branches: [main]
  workflow_dispatch:
  schedule:
    - cron: '0 0 * * SUN'
```

### Path Filters

Only run when specific files change:

```yaml
on:
  pull_request:
    paths:
      - '**/*.py'          # Any Python file
      - 'backend/**'       # Anything in backend
      - 'pyproject.toml'   # Specific file
      - '!docs/**'         # Exclude docs directory
```

## Step 3: Define Jobs

### Basic Job Structure

```yaml
jobs:
  lint:
    name: Linting
    runs-on: ubuntu-latest
    permissions:
      contents: read
    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Run linting
        run: make lint
```

### Job Dependencies

```yaml
jobs:
  lint:
    runs-on: ubuntu-latest
    steps:
      - run: make lint

  test:
    needs: [lint]  # Waits for lint to complete
    runs-on: ubuntu-latest
    steps:
      - run: make test

  deploy:
    needs: [lint, test]  # Waits for both
    runs-on: ubuntu-latest
    steps:
      - run: make deploy
```

### Conditional Jobs

```yaml
jobs:
  deploy:
    if: github.ref == 'refs/heads/main'  # Only on main
    runs-on: ubuntu-latest
    steps:
      - run: make deploy

  deploy-staging:
    if: github.ref == 'refs/heads/develop'  # Only on develop
    runs-on: ubuntu-latest
    steps:
      - run: make deploy-staging
```

### Parallel Jobs

```yaml
jobs:
  lint-backend:
    # Runs in parallel
    runs-on: ubuntu-latest
    steps:
      - run: make lint-backend

  lint-frontend:
    # Runs in parallel
    runs-on: ubuntu-latest
    steps:
      - run: make lint-frontend

  test:
    needs: [lint-backend, lint-frontend]  # Waits for both
    runs-on: ubuntu-latest
    steps:
      - run: make test
```

## Step 4: Add Docker Integration

### Using Docker Containers

```yaml
jobs:
  lint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v3

      - name: Build linting container
        run: |
          docker buildx build \
            --target lint \
            --load \
            -t my-app-linter:latest \
            .

      - name: Run linting
        run: docker run --rm my-app-linter:latest
```

### With Registry Caching

```yaml
- name: Login to GHCR
  uses: docker/login-action@v3
  with:
    registry: ghcr.io
    username: ${{ github.actor }}
    password: ${{ secrets.GITHUB_TOKEN }}

- name: Build or pull cached container
  run: |
    IMAGE="ghcr.io/${{ github.repository }}-linter:latest"
    docker pull $IMAGE || true

    docker buildx build \
      --cache-from type=registry,ref=$IMAGE \
      --cache-to type=registry,ref=$IMAGE,mode=max \
      --target lint \
      --load \
      -t my-app-linter:latest \
      .
```

## Step 5: Add Caching

### Dependencies Cache

```yaml
- name: Cache dependencies
  uses: actions/cache@v4
  with:
    path: |
      ~/.cache/pip
      ~/.npm
      node_modules
    key: ${{ runner.os }}-deps-${{ hashFiles('**/poetry.lock', '**/package-lock.json') }}
    restore-keys: |
      ${{ runner.os }}-deps-
```

### Docker Layer Cache

```yaml
- name: Cache Docker layers
  uses: actions/cache@v4
  with:
    path: /tmp/.buildx-cache
    key: ${{ runner.os }}-buildx-${{ hashFiles('**/Dockerfile*') }}
    restore-keys: |
      ${{ runner.os }}-buildx-
```

## Step 6: Add Environment Variables and Secrets

### Environment Variables

```yaml
env:
  PYTHON_VERSION: '3.11'
  NODE_VERSION: '20'
  AWS_REGION: 'us-west-2'

jobs:
  build:
    env:
      BUILD_ENV: production
    steps:
      - run: echo $PYTHON_VERSION
      - run: echo $BUILD_ENV
```

### Using Secrets

```yaml
jobs:
  deploy:
    steps:
      - name: Configure AWS
        uses: aws-actions/configure-aws-credentials@v4
        with:
          role-to-assume: ${{ secrets.AWS_ROLE_ARN }}
          aws-region: ${{ env.AWS_REGION }}

      - name: Use API key
        run: |
          curl -H "Authorization: Bearer ${{ secrets.API_KEY }}" \
            https://api.example.com
```

## Step 7: Add Outputs and Summaries

### Job Outputs

```yaml
jobs:
  build:
    outputs:
      version: ${{ steps.get_version.outputs.version }}
    steps:
      - name: Get version
        id: get_version
        run: |
          VERSION=$(cat VERSION)
          echo "version=$VERSION" >> $GITHUB_OUTPUT

  deploy:
    needs: [build]
    steps:
      - name: Deploy version
        run: |
          echo "Deploying version: ${{ needs.build.outputs.version }}"
```

### Workflow Summaries

```yaml
- name: Generate summary
  if: always()
  run: |
    echo "## 🔍 Workflow Summary" >> $GITHUB_STEP_SUMMARY
    echo "Status: SUCCESS" >> $GITHUB_STEP_SUMMARY
    echo "Duration: 3m 24s" >> $GITHUB_STEP_SUMMARY
```

## Step 8: Test the Workflow

### Local Testing

If using `make` targets, test locally first:

```bash
make lint
make test
make build
```

### Push to Feature Branch

```bash
git checkout -b add-custom-workflow
git add .github/workflows/custom-workflow.yml
git commit -m "feat: Add custom workflow"
git push origin add-custom-workflow
```

### Verify in GitHub

1. Go to repository Actions tab
2. Find your workflow
3. Check that it ran successfully
4. Review logs for each step

## Verification

### Checklist

- [ ] Workflow file is valid YAML
- [ ] Triggers are configured correctly
- [ ] Jobs run in correct order
- [ ] Caching is configured (if applicable)
- [ ] Secrets are used properly (not exposed in logs)
- [ ] Workflow summary is generated
- [ ] Workflow runs successfully on test branch

### Debugging

If workflow fails:

1. **Check syntax**: Use YAML validator
2. **Review logs**: Click on failed step in GitHub Actions
3. **Enable debug logging**:
   ```yaml
   env:
     ACTIONS_STEP_DEBUG: true
   ```
4. **Test locally**: Run same commands in local environment

## Common Issues

### Issue: Workflow doesn't trigger

**Solution**: Check path filters and branch names

```yaml
on:
  pull_request:
    branches: [main]  # Verify branch name
    paths:
      - 'correct-path/**'  # Verify path
```

### Issue: Job fails with permission error

**Solution**: Add required permissions

```yaml
permissions:
  contents: read
  packages: write  # For pushing to GHCR
  id-token: write  # For OIDC
```

### Issue: Cache not working

**Solution**: Verify cache key includes correct files

```yaml
key: ${{ runner.os }}-deps-${{ hashFiles('**/lock-file') }}
```

## Next Steps

After creating your workflow:

1. **Add Status Badge**: Add badge to README
   ```markdown
   ![Workflow](https://github.com/USER/REPO/workflows/NAME/badge.svg)
   ```

2. **Configure Branch Protection**: Require workflow to pass before merge
   - Settings → Branches → main
   - Add required status check

3. **Optimize Performance**: Review and add caching

4. **Monitor**: Watch workflow runs and iterate

5. **Document**: Add workflow documentation to project README

## Related How-Tos

- [How to Configure GitHub Secrets](how-to-configure-secrets.md) - Set up secrets for workflows
- [How to Add AWS Deployment](how-to-add-deployment.md) - Deploy to AWS ECS

## References

- **Standards**: `standards/ci-cd-standards.md` - CI/CD best practices
- **Templates**: `templates/` - Example workflows
- **GitHub Docs**: [GitHub Actions Documentation](https://docs.github.com/en/actions)
