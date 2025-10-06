# React + Python Full-Stack Application - Agent Instructions

**Purpose**: Installation instructions for AI agents to set up React + Python full-stack application

**Scope**: Complete installation of full-stack web application with React frontend, FastAPI backend, PostgreSQL database, and Docker orchestration

**Overview**: Step-by-step instructions for installing a production-ready full-stack web application.
    This meta-plugin orchestrates the installation of foundation, Python, TypeScript, Docker, CI/CD,
    infrastructure, and standards plugins, then adds a complete starter application with React frontend,
    FastAPI backend, PostgreSQL database, and comprehensive Docker orchestration for local development
    and production deployment.

**Prerequisites**: Empty or existing repository with git initialized

---

## What This Application Provides

**Use Case**: Production-ready full-stack web applications with modern TypeScript frontend and scalable Python backend

**Technology Stack**:
- **Backend**: Python 3.11+ with FastAPI, SQLAlchemy, Pydantic, Alembic
- **Frontend**: React 18 with TypeScript, Vite, React Router
- **Database**: PostgreSQL 15+ with SQLAlchemy ORM
- **Infrastructure**: Docker, Docker Compose, Nginx (optional reverse proxy)
- **CI/CD**: GitHub Actions for automated testing and deployment
- **Deployment**: AWS ECS + ALB via Terraform

**What Gets Installed**:
- Complete FastAPI backend with health endpoint, CORS, authentication patterns
- Complete React frontend with routing, API client, component structure
- PostgreSQL database with migration support
- Docker Compose orchestration for all services
- Hot reload for both frontend and backend
- Comprehensive test suites for both layers
- CI/CD pipeline for automated testing and deployment
- AWS infrastructure as code with Terraform
- Security scanning and pre-commit hooks
- Complete documentation and how-to guides

## How This Meta-Plugin Works

**IMPORTANT**: This is a **meta-plugin** that orchestrates the installation of 9+ atomic plugins in a specific order.

**What this means:**
- Each "Follow:" directive MUST be executed - you cannot skip plugin installations
- The `PROJECT_NAME-app/` directory contains APPLICATION CODE that depends on infrastructure
- Infrastructure (`.docker/`, CI/CD configs, etc.) is created by executing the plugins in Phases 1-4
- Application code (Phase 5) will NOT work without the infrastructure from Phases 1-4

**Common mistake to avoid:**
❌ WRONG: "I see PROJECT_NAME-app/ has backend/frontend code, so I'll skip plugin installations and just copy the files"
✅ CORRECT: "I must execute all 'Follow:' directives in Phases 1-4 to create infrastructure, THEN copy application code in Phase 5"

**Reference**: See AGENTS.md "Critical Rules for Repository Assistant Mode" for general guidance on following plugin instructions.

---

## Installation Approach: Roadmap-Based (REQUIRED)

**CRITICAL**: This meta-plugin installation MUST use a roadmap-based approach.

**Why?**
- Meta-plugin installations are complex (8 phases, 9+ plugin installations)
- Agents tend to rush, skip phases, or take shortcuts when given all phases at once
- Breaking into separate PRs prevents shortcuts and ensures systematic execution

**How it works:**

### Step 1: Create Installation Roadmap (PR0)

**Ask user questions ONE AT A TIME. Wait for each answer before asking the next question.**

1. **Question 1: Docker Infrastructure (REQUIRED)**

   Present this question and WAIT for user's answer:
   ```
   Docker Infrastructure Setup (REQUIRED for Production)

   This is a Docker-first application. All development, testing, and linting
   should happen in Docker containers for consistency and reproducibility.

   Would you like to set up Docker infrastructure? (Recommended: yes)

   If 'yes':
   - .docker/ folder with multi-stage Dockerfiles will be created
   - docker-compose files for dev, lint, and test will be configured
   - All Makefile targets will use 'docker compose run' commands
   - Hot reload will work via volume mounts

   If 'no':
   - Host-based development (requires Python, Node.js, Poetry, npm on host)
   - No container isolation or consistency guarantees
   - Makefile targets will use direct 'poetry run' and 'npm run' commands

   Set up Docker infrastructure? (yes/no)
   ```

   **STOP and WAIT for user's answer. Do NOT ask the next question yet.**

2. **Question 2: UI Scaffold (OPTIONAL)**

   After receiving Docker answer, present this question and WAIT:
   ```
   Modern UI Scaffold (Optional)

   Would you like to install a modern UI scaffold with:
   - Hero banner with feature cards
   - Principles banner with modal popups
   - Tabbed navigation with 3 blank starter tabs
   - Responsive design (mobile + desktop)

   Install UI scaffold? (yes/no)
   ```

   **STOP and WAIT for user's answer. Do NOT ask the next question yet.**

3. **Question 3: Terraform Deployment (OPTIONAL)**

   After receiving UI scaffold answer, present this question and WAIT:
   ```
   Terraform AWS Deployment (Optional)

   Would you like to set up AWS deployment infrastructure using Terraform?

   This will add:
   - Terraform workspaces (bootstrap, base) for multi-environment deployment
   - AWS infrastructure (VPC, ECR, ECS, ALB, RDS)
   - Makefile.infra for Docker-based Terraform operations
   - Complete deployment documentation and how-tos

   Deploy to AWS with Terraform? (yes/no)
   ```

   **STOP and WAIT for user's answer.**

4. **After ALL three answers received**, proceed to create roadmap and calculate parameters

2. Calculate parameter values:
   ```bash
   # Extract repository name and calculate paths
   REPO_NAME=$(basename "${TARGET_REPO_PATH}")  # e.g., "teamgames.biz"
   APP_NAME="${REPO_NAME%%.*}"                   # e.g., "teamgames"

   # Calculate installation paths for atomic plugins
   BACKEND_PATH="${APP_NAME}-app/backend"
   FRONTEND_PATH="${APP_NAME}-app/frontend"
   FOUNDATION_INSTALL_PATH="."
   DOCKER_INSTALL_PATH=".docker"

   # Calculate plugin parameters
   LANGUAGES="python,typescript"
   SERVICES="backend,frontend,database"

   echo "✅ Parameters calculated:"
   echo "   APP_NAME: ${APP_NAME}"
   echo "   BACKEND_PATH: ${BACKEND_PATH}"
   echo "   FRONTEND_PATH: ${FRONTEND_PATH}"
   echo "   LANGUAGES: ${LANGUAGES}"
   echo "   SERVICES: ${SERVICES}"
   ```

3. Create roadmap file from template:
   ```bash
   mkdir -p roadmap/react-python-fullstack-install
   cp .ai/templates/roadmap-meta-plugin-installation.md.template \
      roadmap/react-python-fullstack-install/PROGRESS_TRACKER.md
   ```

4. Fill in template variables using sed:
   ```bash
   # Replace metadata variables
   sed -i "s|{{PLUGIN_NAME}}|react-python-fullstack|g" roadmap/react-python-fullstack-install/PROGRESS_TRACKER.md
   sed -i "s|{{TOTAL_PLUGINS}}|9|g" roadmap/react-python-fullstack-install/PROGRESS_TRACKER.md
   sed -i "s|{{TOTAL_PRS}}|9|g" roadmap/react-python-fullstack-install/PROGRESS_TRACKER.md
   sed -i "s|{{TARGET_REPO_PATH}}|${TARGET_REPO_PATH}|g" roadmap/react-python-fullstack-install/PROGRESS_TRACKER.md
   sed -i "s|{{PROJECT_NAME}}|${APP_NAME}|g" roadmap/react-python-fullstack-install/PROGRESS_TRACKER.md

   # Replace user choice variables
   sed -i "s|{{DOCKER_CHOICE}}|${DOCKER_CHOICE}|g" roadmap/react-python-fullstack-install/PROGRESS_TRACKER.md
   sed -i "s|{{UI_SCAFFOLD_CHOICE}}|${UI_SCAFFOLD_CHOICE}|g" roadmap/react-python-fullstack-install/PROGRESS_TRACKER.md
   sed -i "s|{{TERRAFORM_CHOICE}}|${TERRAFORM_CHOICE}|g" roadmap/react-python-fullstack-install/PROGRESS_TRACKER.md

   # Replace parameter variables (for plugin installation paths)
   sed -i "s|{{PYTHON_INSTALL_PATH}}|${BACKEND_PATH}|g" roadmap/react-python-fullstack-install/PROGRESS_TRACKER.md
   sed -i "s|{{TYPESCRIPT_INSTALL_PATH}}|${FRONTEND_PATH}|g" roadmap/react-python-fullstack-install/PROGRESS_TRACKER.md
   sed -i "s|{{FOUNDATION_INSTALL_PATH}}|${FOUNDATION_INSTALL_PATH}|g" roadmap/react-python-fullstack-install/PROGRESS_TRACKER.md
   sed -i "s|{{DOCKER_INSTALL_PATH}}|${DOCKER_INSTALL_PATH}|g" roadmap/react-python-fullstack-install/PROGRESS_TRACKER.md
   sed -i "s|{{LANGUAGES}}|${LANGUAGES}|g" roadmap/react-python-fullstack-install/PROGRESS_TRACKER.md
   sed -i "s|{{SERVICES}}|${SERVICES}|g" roadmap/react-python-fullstack-install/PROGRESS_TRACKER.md

   echo "✅ Template variables replaced with calculated values"
   ```

5. Initialize PR status dashboard:
   - Mark PR0 as ✅ Complete
   - Mark PRs 1-5, 8 as 🔴 Not Started
   - Mark PR6 as 🔴 Not Started or ⏭️ Skipped (based on UI choice)
   - Mark PR7 as 🔴 Not Started or ⏭️ Skipped (based on Terraform choice)

6. Commit roadmap:
   ```bash
   git add roadmap/react-python-fullstack-install/PROGRESS_TRACKER.md
   git commit -m "chore: Create roadmap for react-python-fullstack installation"
   ```

7. Inform user:
   ```
   ✅ Roadmap created at: roadmap/react-python-fullstack-install/PROGRESS_TRACKER.md

   Next steps:
   1. Review the roadmap to understand the installation plan
   2. Execute one PR at a time by requesting: "Execute PR1 from roadmap"
   3. Each PR will install one phase and update the roadmap

   User choices recorded:
   - Docker Infrastructure: {{DOCKER_CHOICE}}
   - UI Scaffold: {{UI_SCAFFOLD_CHOICE}}
   - Terraform: {{TERRAFORM_CHOICE}}
   ```

### Step 2: User Executes PRs One at a Time

User will request execution like:
- "Execute PR1 from roadmap/react-python-fullstack-install"
- "Execute PR2 from roadmap/react-python-fullstack-install"
- etc.

Each PR execution:
1. Agent reads PROGRESS_TRACKER.md
2. Checks "Next PR to Implement" section
3. Executes ONLY that PR's instructions
4. Validates completion
5. Updates PROGRESS_TRACKER.md (mark PR complete, update "Next PR")
6. Commits and merges PR branch
7. STOPS - does NOT continue to next PR

**DO NOT execute multiple PRs in one session.**

---

## Roadmap PR Breakdown

When creating the roadmap, ensure it includes these PRs:

- **PR0**: Planning (ask questions, create roadmap) - YOU DO THIS NOW
- **PR1**: Foundation (install ai-folder plugin)
- **PR2**: Languages (install Python + TypeScript plugins)
- **PR3**: Docker (install Docker infrastructure) - conditional on user choice
- **PR4**: Standards (install security, docs, pre-commit plugins)
- **PR5**: Application (copy app structure, configure, install deps)
- **PR6**: UI Scaffold (optional) - conditional on user choice
- **PR7**: Terraform (optional) - conditional on user choice
- **PR8**: Finalization (validate, create AGENTS.md)

**See the roadmap template for detailed instructions for each PR.**

---

## If You Are Being Asked to "Install react-python-fullstack Plugin"

**STOP. You should NOT execute the full installation in one go.**

Instead, your task is:
1. **Create the roadmap** (PR0 instructions above)
2. **Ask the user questions**
3. **Create PROGRESS_TRACKER.md**
4. **Inform user to execute PRs one at a time**

The detailed phase instructions below are for REFERENCE ONLY. They will be executed incrementally via the roadmap PRs, not all at once.

---

## Detailed Phase Instructions (For Roadmap PR Execution Only)

**NOTE**: These instructions are used by individual roadmap PRs. Do NOT execute all phases in one session.

### Prerequisites Check

Before installation, verify:

```bash
# Check git repository exists
test -d .git && echo "✅ Git repository" || echo "❌ Run: git init"

# Check Python installed
python --version && echo "✅ Python" || echo "❌ Install Python 3.11+"

# Check Node.js installed
node --version && echo "✅ Node.js" || echo "❌ Install Node.js 18+"

# Check Docker running
docker ps > /dev/null 2>&1 && echo "✅ Docker running" || echo "❌ Start Docker"

# Check Docker Compose installed
docker compose version && echo "✅ Docker Compose" || echo "❌ Install Docker Compose"
```

### Phase 1: Foundation Setup

**NOTE**: When executed via roadmap (recommended), parameters calculated in PR0 will be passed to plugins. See roadmap template for parameter passing syntax.

**1. Install foundation/ai-folder plugin**

Follow: `plugins/foundation/ai-folder/AGENT_INSTRUCTIONS.md`
  with INSTALL_PATH={{FOUNDATION_INSTALL_PATH}}

Creates `.ai/` directory structure for AI navigation.

**Validation**:
```bash
test -d .ai && echo "✅ .ai folder created" || echo "❌ Foundation plugin failed"
```

### Phase 2: Language Plugin Installation

**2. Install languages/python plugin**

Follow: `plugins/languages/python/core/AGENT_INSTRUCTIONS.md`
  with INSTALL_PATH={{PYTHON_INSTALL_PATH}}

Installs Python with FastAPI, SQLAlchemy, pytest, ruff, mypy, bandit.

**Options**:
- Framework: FastAPI
- ORM: SQLAlchemy
- Testing: pytest
- Linter: ruff
- Type checker: mypy
- Security: bandit

**Validation**:
```bash
test -f pyproject.toml && echo "✅ Python configured" || echo "❌ Python plugin failed"
```

**2.5. Verify and Install Comprehensive Python Tooling**

Check that comprehensive tooling is present in backend/pyproject.toml, and add if missing:

```bash
cd backend

# Check if comprehensive tooling is already present
if ! grep -q "pylint" pyproject.toml || ! grep -q "radon" pyproject.toml; then
  echo "Adding comprehensive Python tooling..."
  poetry add --group dev \
    pylint \
    flake8 flake8-docstrings flake8-bugbear flake8-comprehensions flake8-simplify \
    radon xenon \
    safety pip-audit
else
  echo "✅ Comprehensive Python tooling already present"
fi
```

**Validation**:
```bash
cd backend
poetry run pylint --version
poetry run flake8 --version
poetry run radon --version
poetry run xenon --version
poetry run safety --version
poetry run pip-audit --version
```

**3. Install languages/typescript plugin**

Follow: `plugins/languages/typescript/core/AGENT_INSTRUCTIONS.md`
  with INSTALL_PATH={{TYPESCRIPT_INSTALL_PATH}}

Installs TypeScript with React, Vite, ESLint, Prettier, Vitest.

**Options**:
- Framework: React 18
- Bundler: Vite
- Linter: ESLint
- Formatter: Prettier
- Testing: Vitest
- Type checking: TypeScript strict mode

**Validation**:
```bash
test -f tsconfig.json && echo "✅ TypeScript configured" || echo "❌ TypeScript plugin failed"
```

**3.5. Verify and Install Comprehensive TypeScript Tooling**

Check that comprehensive tooling is present in frontend/package.json, and add if missing:

```bash
cd frontend

# Check if comprehensive tooling is already present
if ! grep -q "@playwright/test" package.json || ! grep -q "eslint-plugin-jsx-a11y" package.json; then
  echo "Adding comprehensive TypeScript tooling..."
  npm install --save-dev \
    @playwright/test \
    @testing-library/react \
    @testing-library/jest-dom \
    @testing-library/user-event \
    eslint-plugin-jsx-a11y \
    eslint-plugin-react-hooks \
    eslint-plugin-import \
    eslint-plugin-complexity \
    vitest @vitest/ui happy-dom \
    @vitest/coverage-v8
else
  echo "✅ Comprehensive TypeScript tooling already present"
fi
```

**Validation**:
```bash
cd frontend
npx playwright --version
npx vitest --version
npm ls eslint-plugin-jsx-a11y
npm ls @testing-library/react
```

### Phase 3: Docker Infrastructure Setup (REQUIRED)

**IMPORTANT: This phase is REQUIRED for production-ready applications.**

**STOP and ASK THE USER:**

Present this question to the user and WAIT for their response:

```
==========================================
   Docker Infrastructure Setup (REQUIRED)
==========================================

This is a Docker-first application. All development, testing, and linting
should happen in Docker containers for consistency and reproducibility.

Would you like to set up Docker infrastructure? (Recommended: yes)

If you choose 'yes':
  - .docker/ folder with multi-stage Dockerfiles will be created
  - docker-compose files for dev, lint, and test will be configured
  - All Makefile targets will use 'docker compose run' commands
  - Hot reload will work via volume mounts

If you choose 'no':
  - Host-based development (requires Python, Node.js, Poetry, npm on host)
  - No container isolation or consistency guarantees
  - Makefile targets will use direct 'poetry run' and 'npm run' commands

Set up Docker infrastructure? (yes/no)
```

**If user answers "no":**
Display this warning:
```
⚠️  WARNING: Skipping Docker setup. You will need to:
   - Install Python 3.11+, Poetry, Node.js 18+, and npm on your host
   - Manage dependencies manually with 'poetry install' and 'npm install'
   - Run tests and linting on your host environment

Docker setup can be added later by manually running the Docker plugin.
```
Then SKIP to Phase 4 (Standards Plugin Installation).

**If user answers "yes" (RECOMMENDED), proceed with Docker installation:**

**4. Install infrastructure/containerization/docker plugin**

Follow: `plugins/infrastructure/containerization/docker/AGENT_INSTRUCTIONS.md`
  with LANGUAGES={{LANGUAGES}}
  with SERVICES={{SERVICES}}
  with INSTALL_PATH={{DOCKER_INSTALL_PATH}}

**Options**:
- Services: [backend, frontend, database]
- Compose: yes
- Multi-stage: yes

Creates Docker containerization for full-stack application.

**Validation**:
```bash
test -f docker-compose.yml && echo "✅ Docker configured" || echo "❌ Docker plugin failed"
```

**5. Install infrastructure/ci-cd/github-actions plugin**

Follow: `plugins/infrastructure/ci-cd/github-actions/AGENT_INSTRUCTIONS.md`

**Options**:
- Workflows: [test, lint, build, deploy]
- Matrix: yes (Python 3.11, 3.12; Node 18, 20)
- Docker: yes

Creates CI/CD pipeline for full-stack application.

**Validation**:
```bash
test -d .github/workflows && echo "✅ CI/CD configured" || echo "❌ CI/CD plugin failed"
```

**6. Install infrastructure/iac/terraform-aws plugin**

Follow: `plugins/infrastructure/iac/terraform-aws/AGENT_INSTRUCTIONS.md`

**Options**:
- Resources: [ECS, ALB, RDS, VPC]
- Application: fullstack
- Database: PostgreSQL

Creates AWS infrastructure as code for deployment.

**Validation**:
```bash
test -d terraform && echo "✅ Terraform configured" || echo "❌ Terraform plugin failed"
```

### Phase 4: Standards Plugin Installation

**7. Install standards/security plugin**

Follow: `plugins/standards/security/AGENT_INSTRUCTIONS.md`

**Options**:
- Scanning: [secrets, dependencies, containers]
- Tools: [gitleaks, trivy, bandit, safety]

**Validation**:
```bash
test -f .gitignore && grep -q "secrets" .gitignore && echo "✅ Security configured" || echo "❌ Security plugin failed"
```

**8. Install standards/documentation plugin**

Follow: `plugins/standards/documentation/AGENT_INSTRUCTIONS.md`

**Options**:
- Headers: yes
- README sections: standard

**Validation**:
```bash
test -f .ai/docs/file-headers.md && echo "✅ Documentation configured" || echo "❌ Documentation plugin failed"
```

**9. Install standards/pre-commit-hooks plugin**

Follow: `plugins/standards/pre-commit-hooks/AGENT_INSTRUCTIONS.md`

**Options**:
- Hooks: [format, lint, secrets, trailing-whitespace, type-check]

**Validation**:
```bash
test -f .pre-commit-config.yaml && echo "✅ Pre-commit configured" || echo "❌ Pre-commit plugin failed"
```

### Phase 5: Application-Specific Installation

**CRITICAL CONTEXT**: You will be given a TARGET_REPO_PATH (e.g., `/home/stevejackson/Projects/teamgames.biz`). This directory ALREADY EXISTS. DO NOT create a directory with the same name as the repository - that would cause double-nesting (e.g., `teamgames.biz/teamgames.biz/`).

**10. Create Application Wrapper Directory**

Create the `<app-name>-app/` wrapper directory INSIDE the target repository:

```bash
# TARGET_REPO_PATH should be provided (e.g., /home/stevejackson/Projects/teamgames.biz)
# Extract base name and strip domain extensions (.biz, .com, etc.)
REPO_NAME=$(basename "${TARGET_REPO_PATH}")  # e.g., "teamgames.biz"
APP_NAME="${REPO_NAME%%.*}"                   # e.g., "teamgames"

# Create app wrapper INSIDE the target repo (not a nested repo directory!)
mkdir -p "${TARGET_REPO_PATH}/${APP_NAME}-app"

echo "✅ Created ${TARGET_REPO_PATH}/${APP_NAME}-app/ wrapper directory"
```

**11. Copy Application Structure**

Copy the complete application structure from plugin to target repository:

```bash
# Copy from ai-projen's literal "PROJECT_NAME-app" directory to target repo
# Note: PROJECT_NAME-app is the actual directory name in the plugin, not a placeholder
cp -r plugins/applications/react-python-fullstack/project-content/PROJECT_NAME-app/* "${TARGET_REPO_PATH}/${APP_NAME}-app/"

echo "✅ Application structure copied to ${TARGET_REPO_PATH}/${APP_NAME}-app/"
```

**12. Process Template Files**

Process all `.template` files by removing the extension:

```bash
# Process backend templates
find "${TARGET_REPO_PATH}/${APP_NAME}-app/backend" -name "*.template" -type f | while read file; do
  mv "$file" "${file%.template}"
done

# Process frontend templates
find "${TARGET_REPO_PATH}/${APP_NAME}-app/frontend" -name "*.template" -type f | while read file; do
  mv "$file" "${file%.template}"
done

echo "✅ Template files processed"
```

**13. Copy Root-Level Files**

Copy root-level configuration files to target repository:

```bash
# Copy split Makefiles to target repo
cp plugins/applications/react-python-fullstack/project-content/Makefile.template "${TARGET_REPO_PATH}/Makefile"
cp plugins/applications/react-python-fullstack/project-content/Makefile.lint.template "${TARGET_REPO_PATH}/Makefile.lint"
cp plugins/applications/react-python-fullstack/project-content/Makefile.test.template "${TARGET_REPO_PATH}/Makefile.test"
cp plugins/applications/react-python-fullstack/project-content/Makefile.gh.template "${TARGET_REPO_PATH}/Makefile.gh"
cp plugins/applications/react-python-fullstack/project-content/Makefile.infra.template "${TARGET_REPO_PATH}/Makefile.infra"

# Copy environment files to target repo
cp plugins/applications/react-python-fullstack/project-content/.env.example.template "${TARGET_REPO_PATH}/.env.example"
cp plugins/applications/react-python-fullstack/project-content/.envrc.template "${TARGET_REPO_PATH}/.envrc"
cp plugins/applications/react-python-fullstack/project-content/.actrc.template "${TARGET_REPO_PATH}/.actrc"
cp plugins/applications/react-python-fullstack/project-content/.htmlhintrc.template "${TARGET_REPO_PATH}/.htmlhintrc"

# Change to target repo to process templates
cd "${TARGET_REPO_PATH}"

# Remove .template extensions
for file in Makefile*.template .env*.template .envrc.template .actrc.template .htmlhintrc.template; do
  if [ -f "${file}" ]; then
    mv "$file" "${file%.template}"
  fi
done

# Replace {{PROJECT_NAME}} placeholder in Makefiles and .env files with actual app name
sed -i "s/{{PROJECT_NAME}}/${APP_NAME}/g" Makefile*
sed -i "s/{{PROJECT_NAME}}/${APP_NAME}/g" .env.example

echo "✅ Root-level files copied and configured"
```

**Validation**:
```bash
make help

# Should show composite targets:
# - lint-backend (fast)
# - lint-backend-all (comprehensive)
# - lint-backend-security
# - lint-backend-complexity
# - lint-backend-full (everything)
# - lint-frontend (fast)
# - lint-frontend-all (comprehensive)
# - lint-frontend-security
# - lint-frontend-full (everything)
# - lint-all (both stacks, comprehensive)
# - lint-full (ALL 15+ tools)
# - test-all (all tests)
```

**13. Copy Docker Orchestration**

```bash
# Copy fullstack docker-compose
cp plugins/applications/react-python-fullstack/project-content/docker-compose.fullstack.yml.template ./docker-compose.fullstack.yml

# Merge with existing docker-compose.yml or replace
# (Agent decision based on existing configuration)
```

**13. Copy Application Documentation**

Copy files from `plugins/applications/react-python-fullstack/ai-content/` to `.ai/`:

```bash
# Copy architecture documentation
cp plugins/applications/react-python-fullstack/ai-content/docs/*.md .ai/docs/

# Copy application-specific how-tos
mkdir -p .ai/howtos/fullstack
cp plugins/applications/react-python-fullstack/ai-content/howtos/*.md .ai/howtos/fullstack/

# Copy application templates
mkdir -p .ai/templates/fullstack
cp plugins/applications/react-python-fullstack/ai-content/templates/*.template .ai/templates/fullstack/
```

**14. Configure Environment**

Create .env file from .env.example at the root level:

```bash
# Copy .env.example to .env in target repo
cd "${TARGET_REPO_PATH}"
cp .env.example .env

echo "✅ Environment file created"
echo "⚠️  IMPORTANT: Edit .env and fill in real values for your environment"
echo "   - Database credentials"
echo "   - API keys (Claude, GitHub, etc.)"
echo "   - AWS configuration (if deploying)"
```

**15. Install Dependencies**

```bash
# Install backend dependencies
cd "${TARGET_REPO_PATH}/${APP_NAME}-app/backend" && poetry install && cd -

# Install frontend dependencies
cd "${TARGET_REPO_PATH}/${APP_NAME}-app/frontend" && npm install && cd -

echo "✅ All dependencies installed"
```

**16. Update .ai/index.yaml**

Add application entry to `.ai/index.yaml` with correct structure paths:

```yaml
application:
  type: web
  stack:
    backend: Python + FastAPI
    frontend: React + TypeScript + Vite
    database: PostgreSQL
    infrastructure: Docker + AWS ECS
  structure:
    application:
      location: ${APP_NAME}-app/
      description: Main application wrapper
      components:
        backend: ${APP_NAME}-app/backend/app/
        frontend: ${APP_NAME}-app/frontend/src/
        backend_tests: ${APP_NAME}-app/backend/test/
        frontend_tests: ${APP_NAME}-app/frontend/src/test/
  architecture: .ai/docs/fullstack-architecture.md
  integration: .ai/docs/api-frontend-integration.md
  howtos: .ai/howtos/fullstack/
  templates: .ai/templates/fullstack/
```

Note: Replace `${APP_NAME}` with the actual app name (e.g., "teamgames") when updating the file.

### Phase 6: Optional UI Scaffold (Optional)

**IMPORTANT**: This phase is OPTIONAL. Ask the user if they want a modern UI scaffold with hero banner and tabbed navigation.

```bash
echo ""
echo "=========================================="
echo "   Optional: Modern UI Scaffold Setup    "
echo "=========================================="
echo ""
echo "Would you like to install a modern UI scaffold with:"
echo "  - Hero banner with feature cards"
echo "  - Principles banner with modal popups"
echo "  - Tabbed navigation with 3 blank starter tabs"
echo "  - Responsive design (mobile + desktop)"
echo ""
read -p "Install UI scaffold? (yes/no): " ui_response
echo ""

if [[ "$ui_response" =~ ^[Yy] ]]; then
  echo "Installing UI scaffold..."

  # Copy UI scaffold components
  cp -r plugins/applications/react-python-fullstack/project-content/frontend/ui-scaffold/* ./frontend/src/

  # Process templates (remove .template extension)
  find frontend/src -name "*.template" -type f | while read file; do
    mv "$file" "${file%.template}"
  done

  # Update App.tsx to use AppShell
  cat > frontend/src/App.tsx << 'APPEOF'
import React from 'react';
import AppShell from './components/AppShell/AppShell';
import './App.css';

function App() {
  return <AppShell />;
}

export default App;
APPEOF

  echo "✅ UI scaffold installed!"
  echo ""
  echo "UI Scaffold includes:"
  echo "  ✓ HomePage with hero banner and principle cards"
  echo "  ✓ AppShell with routing"
  echo "  ✓ TabNavigation with 3 blank starter tabs"
  echo "  ✓ PrinciplesBanner with modal popups"
  echo "  ✓ Configuration files (tabs.config.ts, principles.config.ts)"
  echo ""
  echo "Customization guides:"
  echo "  - .ai/howtos/react-python-fullstack/how-to-modify-hero-section.md"
  echo "  - .ai/howtos/react-python-fullstack/how-to-add-tab.md"
  echo "  - .ai/howtos/react-python-fullstack/how-to-modify-tab-content.md"
  echo "  - .ai/howtos/react-python-fullstack/how-to-add-hero-card.md"
  echo "  - .ai/howtos/react-python-fullstack/how-to-add-principle-card.md"
  echo ""
else
  echo "Skipping UI scaffold installation."
  echo "Using basic React app structure."
  echo ""
fi
```

**Validation** (if UI scaffold installed):
```bash
# Verify UI scaffold components exist
test -f frontend/src/components/AppShell/AppShell.tsx && echo "✅ AppShell installed" || echo "❌ UI scaffold missing"
test -f frontend/src/pages/HomePage/HomePage.tsx && echo "✅ HomePage installed" || echo "❌ UI scaffold missing"
test -f frontend/src/components/TabNavigation/TabNavigation.tsx && echo "✅ TabNavigation installed" || echo "❌ UI scaffold missing"
test -f frontend/src/config/tabs.config.ts && echo "✅ Tabs config installed" || echo "❌ UI scaffold missing"
```

### Phase 7: Optional Terraform Deployment (Optional)

**IMPORTANT**: This phase is OPTIONAL. Ask the user if they want to deploy to AWS using Terraform.

```bash
echo ""
echo "=========================================="
echo "   Optional: Terraform Deployment Setup  "
echo "=========================================="
echo ""
echo "Would you like to set up AWS deployment infrastructure using Terraform?"
echo ""
echo "This will add:"
echo "  - Terraform workspaces (bootstrap, base) for multi-environment deployment"
echo "  - AWS infrastructure (VPC, ECR, ECS, ALB, RDS)"
echo "  - Makefile.infra for Docker-based Terraform operations"
echo "  - Complete deployment documentation and how-tos"
echo ""
read -p "Deploy to AWS with Terraform? (yes/no): " TERRAFORM_CHOICE

if [ "$TERRAFORM_CHOICE" = "yes" ]; then
  echo "Installing Terraform deployment infrastructure..."
else
  echo "Skipping Terraform deployment. You can add it later if needed."
  echo "Infrastructure setup complete without Terraform."
fi
```

**If user chooses "yes", proceed with Terraform installation:**

**17. Copy Terraform Infrastructure**

Copy Terraform configuration from plugin:

```bash
# Create infrastructure directory
mkdir -p infra/terraform

# Copy all Terraform workspaces
cp -r plugins/applications/react-python-fullstack/project-content/infra/terraform/workspaces ./infra/terraform/
cp -r plugins/applications/react-python-fullstack/project-content/infra/terraform/modules ./infra/terraform/
cp -r plugins/applications/react-python-fullstack/project-content/infra/terraform/shared ./infra/terraform/
cp -r plugins/applications/react-python-fullstack/project-content/infra/terraform/backend-config ./infra/terraform/

# Copy infrastructure Makefile
cp plugins/applications/react-python-fullstack/project-content/infra/Makefile.infra.template ./infra/Makefile.infra
```

**18. Copy Terraform Documentation**

Copy Terraform how-tos and documentation:

```bash
# Copy Terraform how-tos
mkdir -p .ai/howtos/react-python-fullstack
cp plugins/applications/react-python-fullstack/ai-content/howtos/react-python-fullstack/how-to-manage-terraform-infrastructure.md .ai/howtos/react-python-fullstack/
cp plugins/applications/react-python-fullstack/ai-content/howtos/react-python-fullstack/how-to-deploy-to-aws.md .ai/howtos/react-python-fullstack/
cp plugins/applications/react-python-fullstack/ai-content/howtos/react-python-fullstack/how-to-setup-terraform-workspaces.md .ai/howtos/react-python-fullstack/

# Copy Terraform documentation
mkdir -p .ai/docs/react-python-fullstack
cp plugins/applications/react-python-fullstack/ai-content/docs/react-python-fullstack/TERRAFORM_ARCHITECTURE.md .ai/docs/react-python-fullstack/
cp plugins/applications/react-python-fullstack/ai-content/docs/react-python-fullstack/DEPLOYMENT_GUIDE.md .ai/docs/react-python-fullstack/
cp plugins/applications/react-python-fullstack/ai-content/docs/react-python-fullstack/INFRASTRUCTURE_PRINCIPLES.md .ai/docs/react-python-fullstack/
```

**19. Update .ai/index.yaml for Terraform**

If Terraform was installed, add Terraform entries to `.ai/index.yaml`:

```yaml
infrastructure:
  terraform:
    location: infra/terraform/
    workspaces:
      - bootstrap (S3 backend, DynamoDB, GitHub OIDC)
      - base (VPC, ECR, ALB, security groups)
    modules:
      - ecs-service (Fargate deployment with auto-scaling)
      - rds (PostgreSQL with backups)
    makefile: infra/Makefile.infra
    howtos:
      - .ai/howtos/react-python-fullstack/how-to-manage-terraform-infrastructure.md
      - .ai/howtos/react-python-fullstack/how-to-deploy-to-aws.md
      - .ai/howtos/react-python-fullstack/how-to-setup-terraform-workspaces.md
    docs:
      - .ai/docs/react-python-fullstack/TERRAFORM_ARCHITECTURE.md
      - .ai/docs/react-python-fullstack/DEPLOYMENT_GUIDE.md
      - .ai/docs/react-python-fullstack/INFRASTRUCTURE_PRINCIPLES.md
```

**20. Display Terraform Next Steps**

If Terraform was installed, display next steps:

```bash
if [ "$TERRAFORM_CHOICE" = "yes" ]; then
  echo ""
  echo "✅ Terraform deployment infrastructure installed!"
  echo ""
  echo "📝 Next Steps for AWS Deployment:"
  echo "  1. Configure AWS credentials: aws configure"
  echo "  2. Bootstrap Terraform backend:"
  echo "     cd infra && make -f Makefile.infra infra-bootstrap"
  echo "  3. Initialize dev environment:"
  echo "     make -f Makefile.infra infra-init ENV=dev"
  echo "  4. Plan infrastructure:"
  echo "     make -f Makefile.infra infra-plan ENV=dev"
  echo "  5. Apply infrastructure:"
  echo "     make -f Makefile.infra infra-apply ENV=dev"
  echo ""
  echo "📖 Documentation:"
  echo "  - How to manage Terraform: .ai/howtos/react-python-fullstack/how-to-manage-terraform-infrastructure.md"
  echo "  - How to deploy to AWS: .ai/howtos/react-python-fullstack/how-to-deploy-to-aws.md"
  echo "  - Architecture guide: .ai/docs/react-python-fullstack/TERRAFORM_ARCHITECTURE.md"
  echo ""
fi
```

**Validation**:

If Terraform was installed:
```bash
# Verify Terraform files
test -d infra/terraform/workspaces/bootstrap && echo "✅ Bootstrap workspace present" || echo "❌ Missing bootstrap"
test -d infra/terraform/workspaces/base && echo "✅ Base workspace present" || echo "❌ Missing base"
test -d infra/terraform/modules/ecs-service && echo "✅ ECS module present" || echo "❌ Missing ECS module"
test -f infra/Makefile.infra && echo "✅ Infrastructure Makefile present" || echo "❌ Missing Makefile.infra"

# Verify documentation
test -f .ai/howtos/react-python-fullstack/how-to-manage-terraform-infrastructure.md && echo "✅ Terraform how-tos present" || echo "❌ Missing how-tos"
test -f .ai/docs/react-python-fullstack/TERRAFORM_ARCHITECTURE.md && echo "✅ Terraform docs present" || echo "❌ Missing docs"

# Show Terraform help
cd infra && make -f Makefile.infra help
```

If Terraform was skipped:
```bash
echo "✅ Terraform deployment skipped - installation complete without AWS infrastructure"
```

## Post-Installation

### Phase 8: Install AI Agent Guide and Validation Script

**Copy AGENTS.md template to repository**:
```bash
# Copy AGENTS.md template
cp plugins/applications/react-python-fullstack/ai-content/AGENTS.md.template .ai/AGENTS.md

echo "✅ AI agent guide installed at .ai/AGENTS.md"
```

**Copy validation script**:
```bash
# Create scripts directory if it doesn't exist
mkdir -p scripts

# Copy validation script
cp plugins/applications/react-python-fullstack/project-content/scripts/validate-fullstack-setup.sh ./scripts/

# Make executable
chmod +x ./scripts/validate-fullstack-setup.sh

echo "✅ Validation script installed at scripts/validate-fullstack-setup.sh"
```

### Initial Setup

```bash
# Build containers
docker-compose build

# Start database and run migrations
docker-compose up -d db
docker-compose run backend alembic upgrade head

# Run development environment
docker-compose up

# In another terminal, run tests
docker-compose run backend pytest
docker-compose run frontend npm test

# Run linting
make lint-all
```

### Validation

**Run complete setup validation**:

```bash
# Run validation script to check all 15+ tools and infrastructure
./scripts/validate-fullstack-setup.sh

# For verbose output showing tool versions
./scripts/validate-fullstack-setup.sh --verbose
```

The validation script checks:
- ✅ All 9 backend tools (Ruff, Pylint, Flake8+plugins, MyPy, Bandit, Radon, Xenon, Safety, pip-audit)
- ✅ All 6 frontend tools (ESLint+plugins, TypeScript, Vitest, React Testing Library, Playwright, npm audit)
- ✅ All Makefile targets functional
- ✅ Docker Compose configuration
- ✅ CI/CD workflows
- ✅ Optional features (UI scaffold, Terraform) if installed
- ✅ Documentation completeness

**Manual checks** (if services are running):

```bash
# Check services running
docker-compose ps

# Check health endpoints
curl http://localhost:8000/health
curl http://localhost:5173

# Check API documentation
curl http://localhost:8000/docs
```

**Run quality gates**:

```bash
# Fast check (during development)
make lint-backend   # ~3 seconds
make lint-frontend  # ~3 seconds

# Thorough check (before commit)
make lint-all       # ~30 seconds

# Full quality gate (before PR)
make lint-full      # ~2 minutes (all 15+ tools)
make test-all       # All tests with coverage
```

## Success Criteria

- [x] All plugin dependencies installed successfully
- [x] Backend FastAPI application running with health endpoint
- [x] Frontend React application running and accessible
- [x] PostgreSQL database running and accepting connections
- [x] Backend and frontend can communicate via API
- [x] Hot reload working for both backend and frontend
- [x] Tests pass for both backend and frontend
- [x] Linting passes for both backend and frontend
- [x] CI/CD pipeline configured with GitHub Actions
- [x] Terraform infrastructure code created
- [x] Application-specific how-tos available in .ai/howtos/fullstack/
- [x] Security standards applied (secrets scanning, dependency checking)
- [x] Documentation standards applied (file headers)
- [x] Pre-commit hooks installed and working

## Next Steps

1. **Read Application How-Tos**: Check `.ai/howtos/fullstack/` for guides
2. **Explore API Documentation**: Visit `http://localhost:8000/docs` for interactive API docs
3. **Customize Backend**: Add database models, API endpoints, business logic
4. **Customize Frontend**: Add pages, components, state management
5. **Add Features**: Follow how-tos to add API endpoints, frontend pages, and integrate them
6. **Deploy**: Follow deployment guide in `.ai/howtos/fullstack/how-to-deploy-fullstack-app.md`

## Common Issues

### Issue: Plugin dependency failed
**Solution**: Install failed plugin manually following its AGENT_INSTRUCTIONS.md

### Issue: Docker containers won't start
**Solution**:
```bash
docker-compose down
docker-compose build --no-cache
docker-compose up
```

### Issue: Backend tests failing
**Solution**: Check that PostgreSQL is running and migrations are applied
```bash
docker-compose up -d db
docker-compose run backend alembic upgrade head
docker-compose run backend pytest
```

### Issue: Frontend can't connect to backend
**Solution**: Check CORS configuration in `backend/src/config.py` and `frontend/.env`
```bash
# Verify backend CORS_ORIGINS includes frontend URL
grep CORS_ORIGINS backend/.env

# Verify frontend API URL points to backend
grep VITE_API_URL frontend/.env
```

### Issue: Hot reload not working
**Solution**: Check volume mounts in docker-compose.yml
```bash
docker-compose down
docker-compose up --force-recreate
```

## Application-Specific Notes

- **Backend runs on**: `http://localhost:8000`
- **Frontend runs on**: `http://localhost:5173`
- **API documentation**: `http://localhost:8000/docs`
- **Database port**: `5432` (mapped from container)
- **Backend hot reload**: Uses uvicorn `--reload` flag with volume mount
- **Frontend hot reload**: Uses Vite HMR with volume mount
- **Database persistence**: Uses Docker volume `postgres_data`

---

**Remember**: This is a starter application with production-ready patterns. Customize it for your needs. All underlying plugins can be configured independently.
