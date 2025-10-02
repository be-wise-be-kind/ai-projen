# MCP Server for AI-Projen - AI Context

**Purpose**: AI agent context document for implementing the MCP Server for AI-Projen plugins

**Scope**: Model Context Protocol server exposing ai-projen plugin system through structured API

**Overview**: Comprehensive context document for AI agents working on the MCP Server feature.
    This document describes the design, architecture, and implementation approach for creating an MCP server
    that exposes the ai-projen plugin system through a structured API, enabling AI agents to discover and
    access plugin instructions, templates, and validation tools without needing to clone the repository.

**Dependencies**: Model Context Protocol SDK, ai-projen plugin system, AWS infrastructure (ECS, ALB, Terraform)

**Exports**: MCP server implementation, Terraform deployment infrastructure, plugin discovery API

**Related**: PR_BREAKDOWN.md for implementation tasks, PROGRESS_TRACKER.md for current status

**Implementation**: TypeScript MCP server with resource-based plugin exposure, deployed via Terraform to AWS ECS

---

## Overview

The MCP Server for AI-Projen transforms the existing markdown-based plugin system into a discoverable,
structured API that AI agents can consume through the Model Context Protocol. This enables users to
interact with ai-projen plugins through MCP-compatible clients (like Claude Desktop) without manually
cloning repositories or running markdown instructions.

## Project Background

**ai-projen** is a plugin-based framework for creating AI-ready repositories. Currently:
- Plugins are documented via AGENT_INSTRUCTIONS.md files (markdown)
- AI agents read markdown, interpret instructions, and execute steps
- Users must clone the repo or copy plugin directories
- Discovery happens through manual file navigation

**The Problem**: While the markdown approach is flexible and adaptable, it requires:
- Direct file system access to the ai-projen repository
- Manual discovery of available plugins
- No structured validation or state checking
- No versioning or deployment mechanism

## Feature Vision

Transform ai-projen into an **agent-accessible service** while preserving its core philosophy:

1. **Discovery Layer**: AI agents can discover available plugins through MCP
2. **Context Provider**: Server analyzes target projects and recommends plugins
3. **Instruction Repository**: Serves plugin instructions and templates as MCP resources
4. **Validation Helper**: Provides tools to verify prerequisites and installation success
5. **Preserves Intelligence**: AI agents still interpret and adapt instructions (no rigid automation)
6. **Production Deployment**: Hosted service accessible via MCP without local cloning

## Current Application Context

### Existing ai-projen Architecture
```
ai-projen/
├── plugins/
│   ├── PLUGIN_MANIFEST.yaml          # Central registry
│   ├── foundation/
│   │   └── ai-folder/
│   │       ├── AGENT_INSTRUCTIONS.md # Markdown instructions
│   │       ├── README.md             # Human docs
│   │       └── templates/            # File templates
│   ├── languages/
│   │   ├── python/
│   │   │   ├── AGENT_INSTRUCTIONS.md
│   │   │   ├── linters/ruff/
│   │   │   ├── testing/pytest/
│   │   │   └── templates/
│   │   └── typescript/
│   └── infrastructure/
├── .ai/
│   ├── docs/                         # Documentation
│   ├── index.yaml                    # Navigation index
│   └── layout.yaml                   # Directory structure
└── agents.md                         # Entry point for agents
```

### Core Philosophy (Must Preserve)
- **Standalone First**: Plugins work independently
- **Agent-Friendly**: Instructions designed for AI interpretation
- **Framework over Library**: Teaching patterns, not automating everything
- **Extensible**: Easy community contribution
- **Battle-Tested**: Patterns from production apps

## Target Architecture

### MCP Server Structure
```
mcp-server/
├── src/
│   ├── server.ts                    # MCP server entry point
│   ├── resources/
│   │   ├── pluginManifest.ts       # Serve PLUGIN_MANIFEST.yaml
│   │   ├── pluginInstructions.ts   # Serve AGENT_INSTRUCTIONS.md
│   │   ├── pluginTemplates.ts      # Serve template files
│   │   └── projectState.ts         # Analyze target projects
│   ├── tools/
│   │   ├── listPlugins.ts          # Discover available plugins
│   │   ├── getPluginDetails.ts     # Get specific plugin info
│   │   ├── analyzeProject.ts       # Detect project state
│   │   └── validateInstallation.ts # Check if tools installed
│   └── types/
│       └── plugin.ts                # TypeScript types
├── infrastructure/
│   └── terraform/                   # AWS deployment
│       ├── main.tf
│       ├── ecs.tf                   # ECS service
│       ├── alb.tf                   # Load balancer
│       ├── networking.tf            # VPC, subnets
│       └── variables.tf
├── package.json
├── tsconfig.json
└── Dockerfile
```

### Core Components

#### 1. MCP Resources (Read-Only Data)
Resources expose plugin metadata and instructions:

- `resource://ai-projen/manifest` - Complete plugin manifest
- `resource://ai-projen/plugin/{name}/instructions` - AGENT_INSTRUCTIONS.md
- `resource://ai-projen/plugin/{name}/readme` - README.md
- `resource://ai-projen/plugin/{name}/templates` - List of templates
- `resource://ai-projen/plugin/{name}/template/{file}` - Specific template content

#### 2. MCP Tools (Callable Functions)
Tools provide discovery and validation:

**Discovery Tools**:
- `list_available_plugins()` - Get all plugins with status (stable/planned)
- `get_plugin_details(plugin_name)` - Get options, dependencies, description
- `search_plugins(capability)` - Find plugins by capability (e.g., "python linting")

**Analysis Tools**:
- `analyze_project(project_path)` - Detect languages, existing tools, structure
- `recommend_plugins(project_analysis)` - Suggest relevant plugins
- `check_prerequisites(plugin_name)` - Verify dependencies installed

**Validation Tools**:
- `validate_installation(plugin_name, project_path)` - Check if plugin installed correctly
- `validate_yaml(yaml_content)` - Parse and validate YAML files
- `check_tool_exists(tool_name)` - Verify command-line tool available

#### 3. Deployment Infrastructure
- **Container**: Docker image with Node.js and MCP server
- **Orchestration**: AWS ECS Fargate for serverless containers
- **Load Balancing**: ALB for HTTPS/HTTP access
- **Networking**: VPC with public/private subnets
- **IaC**: Terraform for reproducible infrastructure

### User Journey

#### Scenario 1: User Adds TypeScript Support
```
1. User (via Claude Desktop with MCP): "Add TypeScript support to my project"

2. Claude calls MCP tools:
   - analyze_project(/path/to/project) → detects existing structure
   - list_available_plugins() → sees typescript plugin available
   - get_plugin_details("typescript") → gets options (eslint vs biome, etc.)

3. Claude asks user preferences or uses defaults

4. Claude fetches resources:
   - resource://ai-projen/plugin/typescript/instructions
   - resource://ai-projen/plugin/typescript/templates

5. Claude interprets instructions, adapts to project context, executes:
   - Copies tsconfig.json template
   - Installs dependencies
   - Updates Makefile
   - Extends agents.md

6. Claude validates:
   - validate_installation("typescript", /path/to/project)
   - check_tool_exists("tsc")

7. User has TypeScript support installed properly
```

#### Scenario 2: New Project Creation
```
1. User: "Create a new AI-ready Python project"

2. Claude:
   - list_available_plugins() → sees foundation/ai-folder and languages/python
   - get_plugin_details("ai-folder") → foundation plugin
   - get_plugin_details("python") → python tooling

3. Claude installs sequentially:
   a. Foundation (ai-folder structure)
   b. Python (with Ruff, MyPy, Pytest)

4. Claude validates each step before proceeding

5. User has production-ready Python project structure
```

#### Scenario 3: Plugin Discovery
```
1. User: "What infrastructure plugins are available?"

2. Claude:
   - search_plugins("infrastructure") → gets docker, terraform, github-actions
   - Presents options with descriptions

3. User selects docker

4. Claude fetches and executes docker plugin instructions

5. User has containerization set up
```

### Data Flow

```
User Request
    ↓
Claude Desktop (MCP Client)
    ↓
MCP Server (HTTPS)
    ↓
┌─────────────────────┐
│  Resource Handlers  │ → File System → ai-projen plugin files
├─────────────────────┤
│   Tool Handlers     │ → Analysis Logic → Project detection
└─────────────────────┘
    ↓
Structured Response (JSON)
    ↓
Claude interprets and executes
    ↓
User's Project Updated
```

## Key Decisions Made

### Why MCP Resources for Plugin Content?
**Reasoning**: Plugin instructions and templates are read-only data that doesn't change based on context.
Resources are the natural fit for serving static content that AI agents consume.

### Why MCP Tools for Discovery/Validation?
**Reasoning**: Discovery and validation are **actions** that take parameters and return computed results.
Tools provide the dynamic, contextual capabilities needed for these operations.

### Why NOT Deterministic Installation Functions?
**Reasoning**: Every project is different. Rigid functions can't handle:
- Varying project structures
- Existing configurations to merge
- Non-standard setups
- Edge cases

AI interpretation of markdown instructions is **far more flexible** than pre-programmed functions.

### Why TypeScript for MCP Server?
**Reasoning**:
- MCP SDK has excellent TypeScript support
- Strong typing helps prevent errors
- Good fit for JSON/YAML processing
- Ecosystem familiarity (Node.js)

### Why AWS ECS + Terraform?
**Reasoning**:
- **ECS Fargate**: Serverless containers, no EC2 management
- **Terraform**: Infrastructure as code, version controlled, reproducible
- **ALB**: Standard HTTPS access, health checks, auto-scaling
- **Proven Pattern**: Same stack as durable-code-test

### Why Expose Templates as Resources?
**Reasoning**: AI agents need access to template files to copy/adapt them. Resources allow:
- Listing available templates
- Fetching template content
- Versioning (future: templates by version)

## Integration Points

### With Existing ai-projen Features

#### Plugin Manifest (`plugins/PLUGIN_MANIFEST.yaml`)
- MCP server reads this file on startup
- Caches in memory for fast lookups
- Hot-reloads on changes (development mode)
- Validates schema before serving

#### AGENT_INSTRUCTIONS.md Files
- Served as-is through resources
- No parsing or transformation
- Preserves original markdown formatting
- AI agents interpret as they do today

#### Template Files
- Directory scanning to discover templates
- Served with original paths preserved
- MIME type detection for proper handling
- Binary file support (images, etc.)

### With MCP Ecosystem

#### Claude Desktop Integration
- MCP server listed in Claude Desktop config
- Tools appear in Claude's tool palette
- Resources accessible via URI scheme
- Seamless user experience

#### Other MCP Clients
- Any MCP-compatible client can connect
- Standard protocol compliance
- No client-specific code needed
- Future-proof architecture

### With Deployment Infrastructure

#### Terraform Workspaces
- `dev`: Development environment with verbose logging
- `staging`: Pre-production testing
- `prod`: Production deployment with monitoring

#### CI/CD Pipeline
- GitHub Actions builds Docker image
- Runs tests before deployment
- Terraform plan/apply on PR merge
- Blue-green deployment strategy

## Success Metrics

### Technical Metrics
- ✅ MCP server starts and responds to health checks
- ✅ All plugin manifest data accessible via resources
- ✅ All tools return valid responses
- ✅ YAML parsing works correctly
- ✅ Template files served with correct content
- ✅ Response time < 500ms for resource requests
- ✅ Response time < 2s for tool calls

### Feature Metrics
- ✅ Users can discover all plugins via MCP
- ✅ Claude Desktop successfully installs plugins
- ✅ Project analysis detects common patterns
- ✅ Validation tools correctly identify issues
- ✅ No need to clone ai-projen repository
- ✅ Community can add plugins without server changes

### Deployment Metrics
- ✅ Terraform apply succeeds in all environments
- ✅ ECS service healthy and running
- ✅ HTTPS access works correctly
- ✅ Container auto-restarts on failures
- ✅ Logs captured in CloudWatch

## Technical Constraints

### Must Preserve ai-projen Philosophy
- Don't add rigid automation
- Keep instructions interpretable by AI
- Maintain plugin independence
- Support standalone usage (repo still cloneable)

### MCP Protocol Compliance
- Follow MCP specification exactly
- Use standard resource URI schemes
- Tool parameters must be JSON-serializable
- Error handling per MCP spec

### Stateless Design
- No user session tracking
- No database needed
- All data from file system or computed
- Horizontal scaling ready

### Security
- Read-only file system access
- No code execution on server
- Input validation on all tool parameters
- Rate limiting on tools
- HTTPS only in production

## AI Agent Guidance

### When Implementing MCP Resources
1. Read plugin files from disk (don't hard-code)
2. Use streaming for large files
3. Handle missing files gracefully
4. Return proper MIME types
5. Cache manifest in memory
6. Support URI parameters for filtering

### When Implementing MCP Tools
1. Validate all input parameters
2. Return structured, consistent responses
3. Include error details in failures
4. Keep tool scope focused and clear
5. Document expected inputs/outputs
6. Test with various project structures

### When Writing Terraform
1. Use variables for all configurable values
2. Output all important values (URLs, ARNs)
3. Tag all resources appropriately
4. Use remote state (S3 backend)
5. Follow least-privilege IAM principles
6. Enable monitoring and logging

### Common Patterns

#### Resource Handler Pattern
```typescript
async function getPluginInstructions(pluginName: string): Promise<string> {
  const path = `plugins/${category}/${pluginName}/AGENT_INSTRUCTIONS.md`;
  if (!fs.existsSync(path)) {
    throw new Error(`Plugin ${pluginName} not found`);
  }
  return await fs.promises.readFile(path, 'utf-8');
}
```

#### Tool Handler Pattern
```typescript
async function analyzeTool(params: AnalyzeParams): Promise<AnalysisResult> {
  // 1. Validate inputs
  validateProjectPath(params.project_path);

  // 2. Perform analysis
  const languages = await detectLanguages(params.project_path);
  const tools = await detectTools(params.project_path);

  // 3. Return structured result
  return {
    languages,
    tools,
    recommendations: generateRecommendations(languages, tools)
  };
}
```

## Risk Mitigation

### Risk: Breaking Changes to Plugin Structure
**Mitigation**:
- Version the API (v1, v2)
- Support multiple manifest formats
- Graceful degradation for missing fields
- Automated tests against plugin structure

### Risk: Large Template Files
**Mitigation**:
- Stream file content
- Implement size limits
- Compress responses
- Pagination for template lists

### Risk: Invalid YAML in Manifest
**Mitigation**:
- Validate on server startup
- Fail fast with clear error
- Schema validation
- CI/CD validation before deploy

### Risk: Server Downtime
**Mitigation**:
- ECS auto-restart on failures
- Health checks with auto-recovery
- Multi-AZ deployment
- CloudWatch alarms
- Fallback to direct repo access

### Risk: Cost Overrun
**Mitigation**:
- Fargate Spot for non-prod
- Auto-scaling with conservative limits
- CloudWatch cost alarms
- Resource tagging for cost tracking

## Future Enhancements

### Phase 2: Enhanced Discovery
- Semantic search over plugin descriptions
- Dependency graph visualization
- Plugin compatibility matrix
- Version history and changelogs

### Phase 3: State Tracking
- Optional project registration
- Track installed plugins per project
- Update notifications
- Rollback capability

### Phase 4: Plugin Marketplace
- Community plugin submission
- Automated validation pipeline
- Rating and reviews
- Usage analytics

### Phase 5: Multi-Repo Support
- Serve plugins from multiple sources
- Plugin federation
- Private plugin registries
- Organization-specific plugins

### Phase 6: Advanced Tooling
- Automated plugin testing
- Compatibility verification
- Performance profiling
- Security scanning integration
