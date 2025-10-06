# MCP Server for AI-Projen - PR Breakdown

**Purpose**: Detailed implementation breakdown of MCP Server feature into manageable, atomic pull requests

**Scope**: Complete feature implementation from project setup through production deployment to AWS

**Overview**: Comprehensive breakdown of the MCP Server feature into 8 manageable, atomic
    pull requests. Each PR is designed to be self-contained, testable, and maintains application functionality
    while incrementally building toward the complete feature. Includes detailed implementation steps, file
    structures, testing requirements, and success criteria for each PR.

**Dependencies**: Model Context Protocol SDK (@modelcontextprotocol/sdk-typescript), TypeScript, Node.js, Docker, Terraform, AWS

**Exports**: PR implementation plans, file structures, testing strategies, and success criteria for each development phase

**Related**: AI_CONTEXT.md for feature overview, PROGRESS_TRACKER.md for status tracking

**Implementation**: Atomic PR approach with detailed step-by-step implementation guidance and comprehensive testing validation

---

## 🚀 PROGRESS TRACKER - MUST BE UPDATED AFTER EACH PR!

### ✅ Completed PRs
- ⬜ None yet - Planning phase just completed

### 🎯 NEXT PR TO IMPLEMENT
➡️ **START HERE: PR1** - Project Setup and Foundation

### 📋 Remaining PRs
- [ ] PR1: Project Setup and Foundation
- [ ] PR2: Plugin Manifest Resource Handler
- [ ] PR3: Plugin Instructions and Template Resources
- [ ] PR4: Discovery and Analysis Tools
- [ ] PR5: Validation Tools
- [ ] PR6: Dockerization and Local Testing
- [ ] PR7: Terraform Infrastructure
- [ ] PR8: CI/CD Pipeline and Production Deployment

**Progress**: 0% Complete (0/8 PRs)

---

## Overview
This document breaks down the MCP Server for AI-Projen feature into manageable, atomic PRs. Each PR is designed to be:
- Self-contained and testable
- Maintains a working application
- Incrementally builds toward the complete feature
- Revertible if needed

---

## PR1: Project Setup and Foundation

### Summary
Bootstrap the MCP server project with TypeScript, set up the basic MCP server scaffold, implement health checks,
and establish the development workflow. This PR creates the foundational structure all subsequent PRs will build upon.

### Motivation
Need a solid foundation with proper tooling, type safety, and development workflow before implementing features.

### Prerequisites
- [x] Node.js 20+ installed
- [x] TypeScript knowledge
- [x] MCP SDK documentation reviewed
- [x] ai-projen repository cloned

### Implementation Steps

#### Step 1: Create Project Structure
```bash
# Create mcp-server directory in ai-projen root
mkdir -p mcp-server/src/{resources,tools,types,utils}
cd mcp-server
```

#### Step 2: Initialize Node.js Project
```bash
npm init -y
```

Update `package.json`:
```json
{
  "name": "@ai-projen/mcp-server",
  "version": "0.1.0",
  "description": "Model Context Protocol server for ai-projen plugin discovery",
  "main": "dist/server.js",
  "type": "module",
  "scripts": {
    "dev": "tsx watch src/server.ts",
    "build": "tsc",
    "start": "node dist/server.js",
    "test": "vitest",
    "lint": "eslint src --ext .ts",
    "format": "prettier --write src",
    "typecheck": "tsc --noEmit"
  },
  "keywords": ["mcp", "ai-projen", "plugins"],
  "author": "Steve Jackson",
  "license": "MIT"
}
```

#### Step 3: Install Dependencies
```bash
# Production dependencies
npm install @modelcontextprotocol/sdk

# Development dependencies
npm install -D \
  typescript \
  @types/node \
  tsx \
  vitest \
  eslint \
  @typescript-eslint/parser \
  @typescript-eslint/eslint-plugin \
  prettier
```

#### Step 4: TypeScript Configuration
Create `tsconfig.json`:
```json
{
  "compilerOptions": {
    "target": "ES2022",
    "module": "ES2022",
    "lib": ["ES2022"],
    "moduleResolution": "node",
    "outDir": "./dist",
    "rootDir": "./src",
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true,
    "resolveJsonModule": true,
    "declaration": true,
    "declarationMap": true,
    "sourceMap": true
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules", "dist"]
}
```

#### Step 5: ESLint Configuration
Create `.eslintrc.json`:
```json
{
  "parser": "@typescript-eslint/parser",
  "extends": [
    "eslint:recommended",
    "plugin:@typescript-eslint/recommended"
  ],
  "plugins": ["@typescript-eslint"],
  "env": {
    "node": true,
    "es2022": true
  },
  "rules": {
    "@typescript-eslint/explicit-function-return-type": "warn",
    "@typescript-eslint/no-unused-vars": ["error", { "argsIgnorePattern": "^_" }],
    "no-console": ["warn", { "allow": ["warn", "error"] }]
  }
}
```

#### Step 6: Prettier Configuration
Create `.prettierrc`:
```json
{
  "semi": true,
  "trailingComma": "es5",
  "singleQuote": true,
  "printWidth": 100,
  "tabWidth": 2
}
```

#### Step 7: Create Type Definitions
Create `src/types/plugin.ts`:
```typescript
export interface PluginManifest {
  version: string;
  foundation: Record<string, Plugin>;
  languages: Record<string, Plugin>;
  infrastructure: Record<string, InfrastructurePlugins>;
  standards: Record<string, Plugin>;
  metadata: ManifestMetadata;
}

export interface Plugin {
  status: 'stable' | 'planned' | 'community';
  description: string;
  location: string;
  dependencies?: string[];
  required?: boolean | 'recommended';
  options?: Record<string, PluginOption>;
  installation_guide?: string;
}

export interface PluginOption {
  available: string[];
  recommended: string | string[];
  description: string;
  note?: string;
}

export interface InfrastructurePlugins {
  [key: string]: Plugin;
}

export interface ManifestMetadata {
  version: string;
  last_updated: string;
  total_plugins: {
    stable: number;
    planned: number;
    community: number;
  };
  notes_for_agents?: string[];
}

export interface AnalysisResult {
  has_ai_folder: boolean;
  detected_languages: string[];
  existing_tools: string[];
  recommended_plugins: string[];
  project_structure: {
    has_git: boolean;
    has_package_json: boolean;
    has_pyproject_toml: boolean;
    has_makefile: boolean;
  };
}
```

#### Step 8: Create Basic MCP Server
Create `src/server.ts`:
```typescript
#!/usr/bin/env node
import { Server } from '@modelcontextprotocol/sdk/server/index.js';
import { StdioServerTransport } from '@modelcontextprotocol/sdk/server/stdio.js';
import {
  CallToolRequestSchema,
  ListResourcesRequestSchema,
  ListToolsRequestSchema,
  ReadResourceRequestSchema,
} from '@modelcontextprotocol/sdk/types.js';

const SERVER_NAME = 'ai-projen-mcp';
const SERVER_VERSION = '0.1.0';

class AiProjenMcpServer {
  private server: Server;

  constructor() {
    this.server = new Server(
      {
        name: SERVER_NAME,
        version: SERVER_VERSION,
      },
      {
        capabilities: {
          resources: {},
          tools: {},
        },
      }
    );

    this.setupHandlers();
  }

  private setupHandlers(): void {
    // List available resources
    this.server.setRequestHandler(ListResourcesRequestSchema, async () => {
      return {
        resources: [
          {
            uri: 'ai-projen://health',
            name: 'Health Check',
            description: 'Server health status',
            mimeType: 'application/json',
          },
        ],
      };
    });

    // Read resource content
    this.server.setRequestHandler(ReadResourceRequestSchema, async (request) => {
      const uri = request.params.uri;

      if (uri === 'ai-projen://health') {
        return {
          contents: [
            {
              uri,
              mimeType: 'application/json',
              text: JSON.stringify(
                {
                  status: 'healthy',
                  server: SERVER_NAME,
                  version: SERVER_VERSION,
                  timestamp: new Date().toISOString(),
                },
                null,
                2
              ),
            },
          ],
        };
      }

      throw new Error(`Unknown resource: ${uri}`);
    });

    // List available tools
    this.server.setRequestHandler(ListToolsRequestSchema, async () => {
      return {
        tools: [
          {
            name: 'ping',
            description: 'Test tool - returns pong',
            inputSchema: {
              type: 'object',
              properties: {},
            },
          },
        ],
      };
    });

    // Handle tool calls
    this.server.setRequestHandler(CallToolRequestSchema, async (request) => {
      if (request.params.name === 'ping') {
        return {
          content: [
            {
              type: 'text',
              text: 'pong',
            },
          ],
        };
      }

      throw new Error(`Unknown tool: ${request.params.name}`);
    });
  }

  async run(): Promise<void> {
    const transport = new StdioServerTransport();
    await this.server.connect(transport);
    console.error('AI-Projen MCP Server running on stdio');
  }
}

const server = new AiProjenMcpServer();
server.run().catch((error) => {
  console.error('Server error:', error);
  process.exit(1);
});
```

#### Step 9: Add Development Scripts
Update `package.json` scripts:
```json
{
  "scripts": {
    "dev": "tsx watch src/server.ts",
    "build": "tsc",
    "start": "node dist/server.js",
    "test": "vitest",
    "lint": "eslint src --ext .ts",
    "format": "prettier --write src",
    "typecheck": "tsc --noEmit",
    "check": "npm run typecheck && npm run lint"
  }
}
```

#### Step 10: Create Basic Test
Create `src/server.test.ts`:
```typescript
import { describe, it, expect } from 'vitest';

describe('MCP Server', () => {
  it('should have basic structure', () => {
    expect(true).toBe(true);
  });
});
```

Create `vitest.config.ts`:
```typescript
import { defineConfig } from 'vitest/config';

export default defineConfig({
  test: {
    globals: true,
    environment: 'node',
  },
});
```

#### Step 11: Create README
Create `mcp-server/README.md`:
```markdown
# AI-Projen MCP Server

Model Context Protocol server for the ai-projen plugin system.

## Development

Install dependencies:
\`\`\`bash
npm install
\`\`\`

Run in development mode:
\`\`\`bash
npm run dev
\`\`\`

Build for production:
\`\`\`bash
npm run build
npm start
\`\`\`

## Testing

Run tests:
\`\`\`bash
npm test
\`\`\`

Run type checking and linting:
\`\`\`bash
npm run check
\`\`\`

## MCP Configuration

Add to Claude Desktop config (`~/Library/Application Support/Claude/claude_desktop_config.json` on macOS):

\`\`\`json
{
  "mcpServers": {
    "ai-projen": {
      "command": "node",
      "args": ["/path/to/ai-projen/mcp-server/dist/server.js"]
    }
  }
}
\`\`\`
```

### File Structure
```
mcp-server/
├── src/
│   ├── server.ts                 # Main server entry point
│   ├── server.test.ts            # Basic tests
│   ├── types/
│   │   └── plugin.ts             # TypeScript type definitions
│   ├── resources/                # (Empty for now)
│   ├── tools/                    # (Empty for now)
│   └── utils/                    # (Empty for now)
├── package.json
├── tsconfig.json
├── .eslintrc.json
├── .prettierrc
├── vitest.config.ts
└── README.md
```

### Testing Checklist
- [ ] `npm install` succeeds
- [ ] `npm run typecheck` passes
- [ ] `npm run lint` passes
- [ ] `npm run test` passes
- [ ] `npm run build` creates dist/ directory
- [ ] `npm start` runs server without errors
- [ ] Health check resource returns valid JSON
- [ ] Ping tool returns "pong"

### Success Criteria
- ✅ MCP server project initialized with TypeScript
- ✅ All linting and type checking passes
- ✅ Basic MCP server responds to health checks
- ✅ Development workflow established (dev, build, test)
- ✅ README documents setup and usage
- ✅ Server can be manually tested with MCP inspector

---

## PR2: Plugin Manifest Resource Handler

### Summary
Implement resource handlers to serve the plugin manifest (PLUGIN_MANIFEST.yaml) through MCP resources.
Parse YAML, cache in memory, validate schema, and expose via `ai-projen://manifest` resource.

### Motivation
The plugin manifest is the central registry of all plugins. Exposing it as an MCP resource enables
AI agents to discover available plugins without file system access.

### Prerequisites
- [x] PR1 completed (project foundation exists)
- [x] PLUGIN_MANIFEST.yaml exists in ai-projen repository

### Implementation Steps

#### Step 1: Install YAML Parser
```bash
npm install js-yaml
npm install -D @types/js-yaml
```

#### Step 2: Create Manifest Loader Utility
Create `src/utils/manifestLoader.ts`:
```typescript
import fs from 'fs/promises';
import path from 'path';
import yaml from 'js-yaml';
import type { PluginManifest } from '../types/plugin.js';

export class ManifestLoader {
  private manifestPath: string;
  private cachedManifest: PluginManifest | null = null;
  private lastLoadTime: number = 0;
  private readonly CACHE_TTL_MS = 60000; // 1 minute in dev, disable in prod

  constructor(pluginsRoot: string) {
    this.manifestPath = path.join(pluginsRoot, 'PLUGIN_MANIFEST.yaml');
  }

  async load(forceReload: boolean = false): Promise<PluginManifest> {
    const now = Date.now();
    const cacheExpired = now - this.lastLoadTime > this.CACHE_TTL_MS;

    if (!forceReload && this.cachedManifest && !cacheExpired) {
      return this.cachedManifest;
    }

    try {
      const content = await fs.readFile(this.manifestPath, 'utf-8');
      const manifest = yaml.load(content) as PluginManifest;

      this.validateManifest(manifest);

      this.cachedManifest = manifest;
      this.lastLoadTime = now;

      return manifest;
    } catch (error) {
      throw new Error(`Failed to load manifest: ${error instanceof Error ? error.message : String(error)}`);
    }
  }

  private validateManifest(manifest: unknown): asserts manifest is PluginManifest {
    if (!manifest || typeof manifest !== 'object') {
      throw new Error('Manifest is not an object');
    }

    const m = manifest as Record<string, unknown>;

    if (!m.version || typeof m.version !== 'string') {
      throw new Error('Manifest missing valid version');
    }

    if (!m.metadata || typeof m.metadata !== 'object') {
      throw new Error('Manifest missing metadata');
    }

    // Additional validation can be added here
  }

  getManifestPath(): string {
    return this.manifestPath;
  }
}
```

#### Step 3: Create Manifest Resource Handler
Create `src/resources/pluginManifest.ts`:
```typescript
import type { PluginManifest } from '../types/plugin.js';
import type { ManifestLoader } from '../utils/manifestLoader.js';

export class PluginManifestResource {
  constructor(private manifestLoader: ManifestLoader) {}

  async getManifest(): Promise<PluginManifest> {
    return await this.manifestLoader.load();
  }

  async getManifestText(): Promise<string> {
    const manifest = await this.getManifest();
    return JSON.stringify(manifest, null, 2);
  }

  async getPluginCategories(): Promise<string[]> {
    const manifest = await this.getManifest();
    return Object.keys(manifest).filter(
      (key) => !['version', 'metadata', '_templates'].includes(key)
    );
  }

  async getPluginsByCategory(category: string): Promise<Record<string, unknown>> {
    const manifest = await this.getManifest();

    if (category === 'foundation') return manifest.foundation;
    if (category === 'languages') return manifest.languages;
    if (category === 'infrastructure') return manifest.infrastructure;
    if (category === 'standards') return manifest.standards;

    throw new Error(`Unknown category: ${category}`);
  }
}
```

#### Step 4: Update Server with Manifest Resources
Update `src/server.ts`:
```typescript
import { ManifestLoader } from './utils/manifestLoader.js';
import { PluginManifestResource } from './resources/pluginManifest.js';
import path from 'path';
import { fileURLToPath } from 'url';

// Add to constructor
const __dirname = path.dirname(fileURLToPath(import.meta.url));
const pluginsRoot = path.join(__dirname, '../../plugins');

this.manifestLoader = new ManifestLoader(pluginsRoot);
this.manifestResource = new PluginManifestResource(this.manifestLoader);

// Update ListResourcesRequestSchema handler
this.server.setRequestHandler(ListResourcesRequestSchema, async () => {
  return {
    resources: [
      {
        uri: 'ai-projen://health',
        name: 'Health Check',
        description: 'Server health status',
        mimeType: 'application/json',
      },
      {
        uri: 'ai-projen://manifest',
        name: 'Plugin Manifest',
        description: 'Complete plugin manifest with all available plugins',
        mimeType: 'application/json',
      },
      {
        uri: 'ai-projen://manifest/categories',
        name: 'Plugin Categories',
        description: 'List of plugin categories (foundation, languages, etc.)',
        mimeType: 'application/json',
      },
    ],
  };
});

// Update ReadResourceRequestSchema handler
this.server.setRequestHandler(ReadResourceRequestSchema, async (request) => {
  const uri = request.params.uri;

  if (uri === 'ai-projen://health') {
    // ... existing health check code
  }

  if (uri === 'ai-projen://manifest') {
    const manifestText = await this.manifestResource.getManifestText();
    return {
      contents: [
        {
          uri,
          mimeType: 'application/json',
          text: manifestText,
        },
      ],
    };
  }

  if (uri === 'ai-projen://manifest/categories') {
    const categories = await this.manifestResource.getPluginCategories();
    return {
      contents: [
        {
          uri,
          mimeType: 'application/json',
          text: JSON.stringify(categories, null, 2),
        },
      ],
    };
  }

  // Support category-specific resources
  const categoryMatch = uri.match(/^ai-projen:\/\/manifest\/category\/(.+)$/);
  if (categoryMatch) {
    const category = categoryMatch[1];
    const plugins = await this.manifestResource.getPluginsByCategory(category);
    return {
      contents: [
        {
          uri,
          mimeType: 'application/json',
          text: JSON.stringify(plugins, null, 2),
        },
      ],
    };
  }

  throw new Error(`Unknown resource: ${uri}`);
});
```

#### Step 5: Add Tests
Create `src/resources/pluginManifest.test.ts`:
```typescript
import { describe, it, expect, beforeEach } from 'vitest';
import { ManifestLoader } from '../utils/manifestLoader.js';
import { PluginManifestResource } from './pluginManifest.js';
import path from 'path';

describe('PluginManifestResource', () => {
  let manifestResource: PluginManifestResource;

  beforeEach(() => {
    const pluginsRoot = path.join(__dirname, '../../../plugins');
    const loader = new ManifestLoader(pluginsRoot);
    manifestResource = new PluginManifestResource(loader);
  });

  it('should load manifest', async () => {
    const manifest = await manifestResource.getManifest();
    expect(manifest).toBeDefined();
    expect(manifest.version).toBeDefined();
    expect(manifest.metadata).toBeDefined();
  });

  it('should get plugin categories', async () => {
    const categories = await manifestResource.getPluginCategories();
    expect(categories).toContain('foundation');
    expect(categories).toContain('languages');
    expect(categories).toContain('infrastructure');
    expect(categories).toContain('standards');
  });

  it('should get plugins by category', async () => {
    const plugins = await manifestResource.getPluginsByCategory('foundation');
    expect(plugins).toBeDefined();
    expect(plugins['ai-folder']).toBeDefined();
  });

  it('should throw error for invalid category', async () => {
    await expect(manifestResource.getPluginsByCategory('invalid')).rejects.toThrow();
  });
});
```

### Testing Checklist
- [ ] Manifest loads successfully from YAML file
- [ ] Manifest validation catches invalid schemas
- [ ] Cache works correctly (doesn't reload every request)
- [ ] All resource URIs return valid JSON
- [ ] Category filtering works correctly
- [ ] Tests pass

### Success Criteria
- ✅ Plugin manifest loads from YAML file
- ✅ Manifest cached in memory with TTL
- ✅ Schema validation prevents invalid manifests
- ✅ Resources expose manifest via MCP
- ✅ Category-specific resources work
- ✅ All tests pass

---

## PR3: Plugin Instructions and Template Resources

### Summary
Implement resource handlers to serve plugin AGENT_INSTRUCTIONS.md files and template files.
Support dynamic discovery of plugins and their templates through MCP resources.

### Motivation
AI agents need access to installation instructions and template files to install plugins.
These are the core assets that guide plugin installation.

### Prerequisites
- [x] PR2 completed (manifest resources work)
- [x] AGENT_INSTRUCTIONS.md files exist in plugin directories

### Implementation Steps

#### Step 1: Create Plugin File Resolver
Create `src/utils/pluginResolver.ts`:
```typescript
import fs from 'fs/promises';
import path from 'path';
import type { PluginManifest } from '../types/plugin.js';

export class PluginResolver {
  constructor(private pluginsRoot: string, private manifest: PluginManifest) {}

  async resolvePluginPath(pluginName: string): Promise<string> {
    // Search through all categories
    const categories = ['foundation', 'languages', 'infrastructure', 'standards'];

    for (const category of categories) {
      const categoryPlugins = this.manifest[category as keyof typeof this.manifest];

      if (typeof categoryPlugins === 'object' && categoryPlugins !== null) {
        // Handle nested infrastructure plugins
        if (category === 'infrastructure') {
          for (const subcategory of Object.keys(categoryPlugins)) {
            const subPlugins = categoryPlugins[subcategory];
            if (typeof subPlugins === 'object' && pluginName in subPlugins) {
              const plugin = subPlugins[pluginName];
              if (plugin && typeof plugin === 'object' && 'location' in plugin) {
                return path.join(this.pluginsRoot, plugin.location as string);
              }
            }
          }
        } else {
          if (pluginName in categoryPlugins) {
            const plugin = categoryPlugins[pluginName];
            if (plugin && typeof plugin === 'object' && 'location' in plugin) {
              return path.join(this.pluginsRoot, plugin.location as string);
            }
          }
        }
      }
    }

    throw new Error(`Plugin not found: ${pluginName}`);
  }

  async getInstructionsPath(pluginName: string): Promise<string> {
    const pluginPath = await this.resolvePluginPath(pluginName);
    return path.join(pluginPath, 'AGENT_INSTRUCTIONS.md');
  }

  async getReadmePath(pluginName: string): Promise<string> {
    const pluginPath = await this.resolvePluginPath(pluginName);
    return path.join(pluginPath, 'README.md');
  }

  async listTemplates(pluginName: string): Promise<string[]> {
    const pluginPath = await this.resolvePluginPath(pluginName);
    const templatesPath = path.join(pluginPath, 'templates');

    try {
      const files = await fs.readdir(templatesPath, { recursive: true });
      return files.filter((f) => !f.startsWith('.'));
    } catch {
      return []; // No templates directory
    }
  }

  async getTemplatePath(pluginName: string, templateFile: string): Promise<string> {
    const pluginPath = await this.resolvePluginPath(pluginName);
    const templatePath = path.join(pluginPath, 'templates', templateFile);

    // Security check: ensure path is within plugin directory
    const resolvedPath = path.resolve(templatePath);
    const resolvedPluginPath = path.resolve(pluginPath);

    if (!resolvedPath.startsWith(resolvedPluginPath)) {
      throw new Error('Invalid template path (security violation)');
    }

    return templatePath;
  }
}
```

#### Step 2: Create Plugin Resources Handler
Create `src/resources/pluginResources.ts`:
```typescript
import fs from 'fs/promises';
import type { PluginResolver } from '../utils/pluginResolver.js';

export class PluginResources {
  constructor(private resolver: PluginResolver) {}

  async getInstructions(pluginName: string): Promise<string> {
    const instructionsPath = await this.resolver.getInstructionsPath(pluginName);

    try {
      return await fs.readFile(instructionsPath, 'utf-8');
    } catch (error) {
      throw new Error(
        `Failed to read instructions for ${pluginName}: ${error instanceof Error ? error.message : String(error)}`
      );
    }
  }

  async getReadme(pluginName: string): Promise<string> {
    const readmePath = await this.resolver.getReadmePath(pluginName);

    try {
      return await fs.readFile(readmePath, 'utf-8');
    } catch (error) {
      throw new Error(
        `Failed to read README for ${pluginName}: ${error instanceof Error ? error.message : String(error)}`
      );
    }
  }

  async listTemplates(pluginName: string): Promise<string[]> {
    return await this.resolver.listTemplates(pluginName);
  }

  async getTemplate(pluginName: string, templateFile: string): Promise<string> {
    const templatePath = await this.resolver.getTemplatePath(pluginName, templateFile);

    try {
      return await fs.readFile(templatePath, 'utf-8');
    } catch (error) {
      throw new Error(
        `Failed to read template ${templateFile} for ${pluginName}: ${error instanceof Error ? error.message : String(error)}`
      );
    }
  }
}
```

#### Step 3: Update Server with Plugin Resources
Update `src/server.ts` to add plugin-specific resources:

```typescript
// Add to ListResourcesRequestSchema handler
{
  uri: 'ai-projen://plugin/{name}/instructions',
  name: 'Plugin Instructions',
  description: 'AGENT_INSTRUCTIONS.md for a specific plugin',
  mimeType: 'text/markdown',
},
{
  uri: 'ai-projen://plugin/{name}/readme',
  name: 'Plugin README',
  description: 'README.md for a specific plugin',
  mimeType: 'text/markdown',
},
{
  uri: 'ai-projen://plugin/{name}/templates',
  name: 'Plugin Templates',
  description: 'List of template files for a plugin',
  mimeType: 'application/json',
},
{
  uri: 'ai-projen://plugin/{name}/template/{file}',
  name: 'Plugin Template File',
  description: 'Specific template file content',
  mimeType: 'text/plain',
},

// Add to ReadResourceRequestSchema handler
const instructionsMatch = uri.match(/^ai-projen:\/\/plugin\/(.+?)\/instructions$/);
if (instructionsMatch) {
  const pluginName = instructionsMatch[1];
  const instructions = await this.pluginResources.getInstructions(pluginName);
  return {
    contents: [
      {
        uri,
        mimeType: 'text/markdown',
        text: instructions,
      },
    ],
  };
}

const readmeMatch = uri.match(/^ai-projen:\/\/plugin\/(.+?)\/readme$/);
if (readmeMatch) {
  const pluginName = readmeMatch[1];
  const readme = await this.pluginResources.getReadme(pluginName);
  return {
    contents: [
      {
        uri,
        mimeType: 'text/markdown',
        text: readme,
      },
    ],
  };
}

const templatesMatch = uri.match(/^ai-projen:\/\/plugin\/(.+?)\/templates$/);
if (templatesMatch) {
  const pluginName = templatesMatch[1];
  const templates = await this.pluginResources.listTemplates(pluginName);
  return {
    contents: [
      {
        uri,
        mimeType: 'application/json',
        text: JSON.stringify(templates, null, 2),
      },
    ],
  };
}

const templateMatch = uri.match(/^ai-projen:\/\/plugin\/(.+?)\/template\/(.+)$/);
if (templateMatch) {
  const pluginName = templateMatch[1];
  const templateFile = templateMatch[2];
  const template = await this.pluginResources.getTemplate(pluginName, templateFile);
  return {
    contents: [
      {
        uri,
        mimeType: 'text/plain',
        text: template,
      },
    ],
  };
}
```

#### Step 4: Add Tests
Create `src/resources/pluginResources.test.ts`:
```typescript
import { describe, it, expect, beforeEach } from 'vitest';
import { ManifestLoader } from '../utils/manifestLoader.js';
import { PluginResolver } from '../utils/pluginResolver.js';
import { PluginResources } from './pluginResources.js';
import path from 'path';

describe('PluginResources', () => {
  let pluginResources: PluginResources;

  beforeEach(async () => {
    const pluginsRoot = path.join(__dirname, '../../../plugins');
    const loader = new ManifestLoader(pluginsRoot);
    const manifest = await loader.load();
    const resolver = new PluginResolver(pluginsRoot, manifest);
    pluginResources = new PluginResources(resolver);
  });

  it('should get plugin instructions', async () => {
    const instructions = await pluginResources.getInstructions('ai-folder');
    expect(instructions).toContain('AGENT_INSTRUCTIONS');
  });

  it('should get plugin readme', async () => {
    const readme = await pluginResources.getReadme('python');
    expect(readme).toContain('Python');
  });

  it('should list templates', async () => {
    const templates = await pluginResources.listTemplates('python');
    expect(templates.length).toBeGreaterThan(0);
  });

  it('should get template file', async () => {
    const templates = await pluginResources.listTemplates('python');
    if (templates.length > 0) {
      const template = await pluginResources.getTemplate('python', templates[0]);
      expect(template).toBeDefined();
    }
  });

  it('should throw for invalid plugin', async () => {
    await expect(pluginResources.getInstructions('nonexistent')).rejects.toThrow();
  });
});
```

### Testing Checklist
- [ ] Plugin instructions load correctly
- [ ] Plugin README loads correctly
- [ ] Template listing works
- [ ] Template file reading works
- [ ] Path traversal attacks blocked (security)
- [ ] Error handling for missing files
- [ ] Tests pass

### Success Criteria
- ✅ AGENT_INSTRUCTIONS.md accessible via resources
- ✅ README.md accessible via resources
- ✅ Template files discoverable and readable
- ✅ Security checks prevent path traversal
- ✅ All tests pass

---

## PR4: Discovery and Analysis Tools

### Summary
Implement MCP tools for plugin discovery and project analysis. Tools include listing plugins,
getting plugin details, searching by capability, and analyzing project structure.

### Motivation
AI agents need tools to discover what plugins are available and analyze target projects to
recommend appropriate plugins.

### Prerequisites
- [x] PR3 completed (resources work)

### Implementation Steps

#### Step 1: Create Discovery Tools
Create `src/tools/discovery.ts`:
```typescript
import type { PluginManifest, Plugin } from '../types/plugin.js';

export interface PluginSummary {
  name: string;
  category: string;
  status: string;
  description: string;
  dependencies: string[];
  has_instructions: boolean;
}

export class DiscoveryTools {
  constructor(private manifestLoader: () => Promise<PluginManifest>) {}

  async listAvailablePlugins(): Promise<PluginSummary[]> {
    const manifest = await this.manifestLoader();
    const plugins: PluginSummary[] = [];

    // Foundation plugins
    for (const [name, plugin] of Object.entries(manifest.foundation)) {
      plugins.push(this.createSummary(name, 'foundation', plugin));
    }

    // Language plugins
    for (const [name, plugin] of Object.entries(manifest.languages)) {
      if (plugin && typeof plugin === 'object' && 'status' in plugin) {
        plugins.push(this.createSummary(name, 'languages', plugin as Plugin));
      }
    }

    // Infrastructure plugins (nested structure)
    for (const [subcategory, subPlugins] of Object.entries(manifest.infrastructure)) {
      if (typeof subPlugins === 'object') {
        for (const [name, plugin] of Object.entries(subPlugins)) {
          if (plugin && typeof plugin === 'object' && 'status' in plugin) {
            plugins.push(
              this.createSummary(name, `infrastructure/${subcategory}`, plugin as Plugin)
            );
          }
        }
      }
    }

    // Standards plugins
    for (const [name, plugin] of Object.entries(manifest.standards)) {
      if (plugin && typeof plugin === 'object' && 'status' in plugin) {
        plugins.push(this.createSummary(name, 'standards', plugin as Plugin));
      }
    }

    return plugins;
  }

  async getPluginDetails(pluginName: string): Promise<Plugin & { name: string; category: string }> {
    const manifest = await this.manifestLoader();

    // Search all categories
    const categories = {
      foundation: manifest.foundation,
      languages: manifest.languages,
      standards: manifest.standards,
    };

    for (const [category, plugins] of Object.entries(categories)) {
      if (pluginName in plugins) {
        return {
          name: pluginName,
          category,
          ...(plugins[pluginName] as Plugin),
        };
      }
    }

    // Search infrastructure (nested)
    for (const [subcategory, subPlugins] of Object.entries(manifest.infrastructure)) {
      if (typeof subPlugins === 'object' && pluginName in subPlugins) {
        return {
          name: pluginName,
          category: `infrastructure/${subcategory}`,
          ...(subPlugins[pluginName] as Plugin),
        };
      }
    }

    throw new Error(`Plugin not found: ${pluginName}`);
  }

  async searchPlugins(query: string): Promise<PluginSummary[]> {
    const allPlugins = await this.listAvailablePlugins();
    const lowerQuery = query.toLowerCase();

    return allPlugins.filter(
      (p) =>
        p.name.toLowerCase().includes(lowerQuery) ||
        p.description.toLowerCase().includes(lowerQuery) ||
        p.category.toLowerCase().includes(lowerQuery)
    );
  }

  private createSummary(name: string, category: string, plugin: Plugin): PluginSummary {
    return {
      name,
      category,
      status: plugin.status,
      description: plugin.description,
      dependencies: plugin.dependencies || [],
      has_instructions: !!plugin.installation_guide,
    };
  }
}
```

#### Step 2: Create Project Analysis Tool
Create `src/tools/analysis.ts`:
```typescript
import fs from 'fs/promises';
import path from 'path';
import type { AnalysisResult } from '../types/plugin.js';

export class ProjectAnalyzer {
  async analyzeProject(projectPath: string): Promise<AnalysisResult> {
    const exists = await this.pathExists(projectPath);
    if (!exists) {
      throw new Error(`Project path does not exist: ${projectPath}`);
    }

    const [
      hasAiFolder,
      detectedLanguages,
      existingTools,
      projectStructure,
    ] = await Promise.all([
      this.checkAiFolder(projectPath),
      this.detectLanguages(projectPath),
      this.detectExistingTools(projectPath),
      this.analyzeStructure(projectPath),
    ]);

    const recommendedPlugins = this.generateRecommendations(
      hasAiFolder,
      detectedLanguages,
      projectStructure
    );

    return {
      has_ai_folder: hasAiFolder,
      detected_languages: detectedLanguages,
      existing_tools: existingTools,
      recommended_plugins: recommendedPlugins,
      project_structure: projectStructure,
    };
  }

  private async pathExists(filePath: string): Promise<boolean> {
    try {
      await fs.access(filePath);
      return true;
    } catch {
      return false;
    }
  }

  private async checkAiFolder(projectPath: string): Promise<boolean> {
    return await this.pathExists(path.join(projectPath, '.ai'));
  }

  private async detectLanguages(projectPath: string): Promise<string[]> {
    const languages: string[] = [];

    // Check for Python
    if (
      (await this.pathExists(path.join(projectPath, 'pyproject.toml'))) ||
      (await this.pathExists(path.join(projectPath, 'requirements.txt'))) ||
      (await this.pathExists(path.join(projectPath, 'setup.py')))
    ) {
      languages.push('python');
    }

    // Check for TypeScript/JavaScript
    if (
      (await this.pathExists(path.join(projectPath, 'package.json'))) ||
      (await this.pathExists(path.join(projectPath, 'tsconfig.json')))
    ) {
      languages.push('typescript');
    }

    return languages;
  }

  private async detectExistingTools(projectPath: string): Promise<string[]> {
    const tools: string[] = [];

    // Check for Docker
    if (
      (await this.pathExists(path.join(projectPath, 'Dockerfile'))) ||
      (await this.pathExists(path.join(projectPath, 'docker-compose.yml')))
    ) {
      tools.push('docker');
    }

    // Check for Terraform
    if (await this.pathExists(path.join(projectPath, 'terraform'))) {
      tools.push('terraform');
    }

    // Check for GitHub Actions
    if (await this.pathExists(path.join(projectPath, '.github/workflows'))) {
      tools.push('github-actions');
    }

    return tools;
  }

  private async analyzeStructure(
    projectPath: string
  ): Promise<AnalysisResult['project_structure']> {
    return {
      has_git: await this.pathExists(path.join(projectPath, '.git')),
      has_package_json: await this.pathExists(path.join(projectPath, 'package.json')),
      has_pyproject_toml: await this.pathExists(path.join(projectPath, 'pyproject.toml')),
      has_makefile: await this.pathExists(path.join(projectPath, 'Makefile')),
    };
  }

  private generateRecommendations(
    hasAiFolder: boolean,
    languages: string[],
    structure: AnalysisResult['project_structure']
  ): string[] {
    const recommendations: string[] = [];

    // Always recommend ai-folder if not present
    if (!hasAiFolder) {
      recommendations.push('ai-folder');
    }

    // Recommend language plugins
    recommendations.push(...languages);

    // Recommend standards
    recommendations.push('pre-commit-hooks', 'security', 'documentation');

    return recommendations;
  }
}
```

#### Step 3: Update Server with Tools
Update `src/server.ts`:

```typescript
// Add to ListToolsRequestSchema handler
{
  name: 'list_available_plugins',
  description: 'List all available ai-projen plugins with their status and descriptions',
  inputSchema: {
    type: 'object',
    properties: {
      status_filter: {
        type: 'string',
        enum: ['stable', 'planned', 'all'],
        description: 'Filter by plugin status',
      },
    },
  },
},
{
  name: 'get_plugin_details',
  description: 'Get detailed information about a specific plugin',
  inputSchema: {
    type: 'object',
    properties: {
      plugin_name: {
        type: 'string',
        description: 'Name of the plugin',
      },
    },
    required: ['plugin_name'],
  },
},
{
  name: 'search_plugins',
  description: 'Search for plugins by capability or keyword',
  inputSchema: {
    type: 'object',
    properties: {
      query: {
        type: 'string',
        description: 'Search query (searches name, description, category)',
      },
    },
    required: ['query'],
  },
},
{
  name: 'analyze_project',
  description: 'Analyze a project directory to detect languages, tools, and recommend plugins',
  inputSchema: {
    type: 'object',
    properties: {
      project_path: {
        type: 'string',
        description: 'Absolute path to the project directory',
      },
    },
    required: ['project_path'],
  },
},

// Add to CallToolRequestSchema handler
if (request.params.name === 'list_available_plugins') {
  const statusFilter = (request.params.arguments?.status_filter as string) || 'all';
  let plugins = await this.discoveryTools.listAvailablePlugins();

  if (statusFilter !== 'all') {
    plugins = plugins.filter((p) => p.status === statusFilter);
  }

  return {
    content: [
      {
        type: 'text',
        text: JSON.stringify(plugins, null, 2),
      },
    ],
  };
}

if (request.params.name === 'get_plugin_details') {
  const pluginName = request.params.arguments?.plugin_name as string;
  const details = await this.discoveryTools.getPluginDetails(pluginName);

  return {
    content: [
      {
        type: 'text',
        text: JSON.stringify(details, null, 2),
      },
    ],
  };
}

if (request.params.name === 'search_plugins') {
  const query = request.params.arguments?.query as string;
  const results = await this.discoveryTools.searchPlugins(query);

  return {
    content: [
      {
        type: 'text',
        text: JSON.stringify(results, null, 2),
      },
    ],
  };
}

if (request.params.name === 'analyze_project') {
  const projectPath = request.params.arguments?.project_path as string;
  const analysis = await this.projectAnalyzer.analyzeProject(projectPath);

  return {
    content: [
      {
        type: 'text',
        text: JSON.stringify(analysis, null, 2),
      },
    ],
  };
}
```

#### Step 4: Add Tests
Create `src/tools/discovery.test.ts` and `src/tools/analysis.test.ts`

### Testing Checklist
- [ ] list_available_plugins returns all plugins
- [ ] Status filtering works
- [ ] get_plugin_details returns correct data
- [ ] search_plugins finds relevant results
- [ ] analyze_project detects languages correctly
- [ ] Recommendations generated appropriately
- [ ] Tests pass

### Success Criteria
- ✅ All discovery tools functional
- ✅ Project analysis detects common patterns
- ✅ Plugin recommendations make sense
- ✅ All tests pass

---

## PR5: Validation Tools

### Summary
Implement validation tools to check prerequisites, verify installations, and validate YAML files.

### Motivation
AI agents need to verify that plugins are installed correctly and that dependencies are met.

### Prerequisites
- [x] PR4 completed

### Implementation Steps

#### Step 1: Create Validation Tools
Create `src/tools/validation.ts`:
```typescript
import { exec } from 'child_process';
import { promisify } from 'util';
import fs from 'fs/promises';
import yaml from 'js-yaml';

const execAsync = promisify(exec);

export interface ValidationResult {
  valid: boolean;
  checks: Array<{
    name: string;
    passed: boolean;
    message: string;
  }>;
}

export class ValidationTools {
  async checkToolExists(toolName: string): Promise<boolean> {
    try {
      await execAsync(`which ${toolName}`);
      return true;
    } catch {
      return false;
    }
  }

  async validateYaml(yamlContent: string): Promise<{ valid: boolean; error?: string; parsed?: unknown }> {
    try {
      const parsed = yaml.load(yamlContent);
      return { valid: true, parsed };
    } catch (error) {
      return {
        valid: false,
        error: error instanceof Error ? error.message : String(error),
      };
    }
  }

  async validateInstallation(pluginName: string, projectPath: string): Promise<ValidationResult> {
    const checks: ValidationResult['checks'] = [];

    // Plugin-specific validation logic
    if (pluginName === 'ai-folder') {
      const hasAiFolder = await this.pathExists(`${projectPath}/.ai`);
      checks.push({
        name: '.ai folder exists',
        passed: hasAiFolder,
        message: hasAiFolder ? '.ai folder found' : '.ai folder missing',
      });

      const hasAgentsMd = await this.pathExists(`${projectPath}/agents.md`);
      checks.push({
        name: 'AGENTS.md exists',
        passed: hasAgentsMd,
        message: hasAgentsMd ? 'AGENTS.md found' : 'AGENTS.md missing',
      });
    }

    if (pluginName === 'python') {
      const hasPyproject = await this.pathExists(`${projectPath}/pyproject.toml`);
      checks.push({
        name: 'pyproject.toml exists',
        passed: hasPyproject,
        message: hasPyproject ? 'pyproject.toml found' : 'pyproject.toml missing',
      });

      const hasRuff = await this.checkToolExists('ruff');
      checks.push({
        name: 'ruff installed',
        passed: hasRuff,
        message: hasRuff ? 'ruff available' : 'ruff not found in PATH',
      });
    }

    const allPassed = checks.every((c) => c.passed);
    return {
      valid: allPassed,
      checks,
    };
  }

  private async pathExists(path: string): Promise<boolean> {
    try {
      await fs.access(path);
      return true;
    } catch {
      return false;
    }
  }
}
```

#### Step 2: Add Validation Tools to Server
Update `src/server.ts` with validation tool handlers

#### Step 3: Add Tests

### Testing Checklist
- [ ] Tool existence checks work
- [ ] YAML validation catches errors
- [ ] Installation validation works
- [ ] Tests pass

### Success Criteria
- ✅ All validation tools functional
- ✅ Tests pass

---

## PR6: Dockerization and Local Testing

### Summary
Create Dockerfile, docker-compose.yml, and local testing setup for the MCP server.

### Motivation
Need containerized deployment and local development environment.

### Prerequisites
- [x] PR5 completed
- [x] Docker installed locally

### Implementation Steps

#### Step 1: Create Dockerfile
Create `mcp-server/Dockerfile`:
```dockerfile
FROM node:20-alpine AS builder

WORKDIR /app

COPY package*.json ./
RUN npm ci

COPY . .
RUN npm run build

FROM node:20-alpine

WORKDIR /app

COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./package.json

# Copy plugins directory
COPY ../plugins /app/plugins

EXPOSE 3000

CMD ["node", "dist/server.js"]
```

#### Step 2: Create docker-compose.yml
Create `mcp-server/docker-compose.yml`:
```yaml
version: '3.8'

services:
  mcp-server:
    build:
      context: .
      dockerfile: Dockerfile
    ports:
      - "3000:3000"
    volumes:
      - ../plugins:/app/plugins:ro
    environment:
      - NODE_ENV=development
    restart: unless-stopped
```

#### Step 3: Add Docker Scripts to package.json
```json
{
  "scripts": {
    "docker:build": "docker build -t ai-projen-mcp .",
    "docker:run": "docker run -p 3000:3000 ai-projen-mcp",
    "docker:compose": "docker-compose up -d",
    "docker:logs": "docker-compose logs -f"
  }
}
```

#### Step 4: Test Docker Build
```bash
npm run docker:build
npm run docker:run
```

### Testing Checklist
- [ ] Docker image builds successfully
- [ ] Container starts without errors
- [ ] Server accessible on port 3000
- [ ] Plugins directory mounted correctly
- [ ] Health check responds

### Success Criteria
- ✅ Docker image builds
- ✅ Container runs successfully
- ✅ Server accessible in container
- ✅ All tests pass in Docker

---

## PR7: Terraform Infrastructure

### Summary
Create Terraform infrastructure for deploying MCP server to AWS ECS with ALB, VPC, and monitoring.

### Motivation
Production deployment requires infrastructure as code for reproducibility and maintainability.

### Prerequisites
- [x] PR6 completed
- [x] AWS account configured
- [x] Terraform installed

### Implementation Steps

#### Step 1: Create Terraform Directory Structure
```bash
mkdir -p mcp-server/infrastructure/terraform/{modules,environments}
```

#### Step 2: Create VPC Module
Create `infrastructure/terraform/modules/networking/main.tf`:
```hcl
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "${var.project_name}-vpc"
    Environment = var.environment
  }
}

resource "aws_subnet" "public" {
  count                   = 2
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.project_name}-public-${count.index + 1}"
    Environment = var.environment
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "${var.project_name}-igw"
    Environment = var.environment
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name        = "${var.project_name}-public-rt"
    Environment = var.environment
  }
}

resource "aws_route_table_association" "public" {
  count          = 2
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

data "aws_availability_zones" "available" {
  state = "available"
}
```

#### Step 3: Create ECS Module
Create `infrastructure/terraform/modules/ecs/main.tf`:
```hcl
resource "aws_ecs_cluster" "main" {
  name = "${var.project_name}-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = {
    Environment = var.environment
  }
}

resource "aws_ecs_task_definition" "app" {
  family                   = "${var.project_name}-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.task_cpu
  memory                   = var.task_memory
  execution_role_arn       = aws_iam_role.ecs_execution.arn

  container_definitions = jsonencode([
    {
      name      = "mcp-server"
      image     = var.container_image
      essential = true

      portMappings = [
        {
          containerPort = 3000
          protocol      = "tcp"
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.app.name
          "awslogs-region"        = var.aws_region
          "awslogs-stream-prefix" = "ecs"
        }
      }

      environment = [
        {
          name  = "NODE_ENV"
          value = var.environment
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "app" {
  name            = "${var.project_name}-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = var.desired_count
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.subnet_ids
    security_groups  = [aws_security_group.ecs_tasks.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = "mcp-server"
    container_port   = 3000
  }

  depends_on = [var.alb_listener]
}

resource "aws_cloudwatch_log_group" "app" {
  name              = "/ecs/${var.project_name}"
  retention_in_days = 30
}
```

#### Step 4: Create ALB Module
Create `infrastructure/terraform/modules/alb/main.tf`

#### Step 5: Create Root Configuration
Create `infrastructure/terraform/main.tf`:
```hcl
terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket         = "ai-projen-terraform-state"
    key            = "mcp-server/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-locks"
  }
}

provider "aws" {
  region = var.aws_region
}

module "networking" {
  source       = "./modules/networking"
  project_name = var.project_name
  environment  = var.environment
  vpc_cidr     = var.vpc_cidr
}

module "alb" {
  source       = "./modules/alb"
  project_name = var.project_name
  environment  = var.environment
  vpc_id       = module.networking.vpc_id
  subnet_ids   = module.networking.public_subnet_ids
}

module "ecs" {
  source            = "./modules/ecs"
  project_name      = var.project_name
  environment       = var.environment
  aws_region        = var.aws_region
  container_image   = var.container_image
  subnet_ids        = module.networking.public_subnet_ids
  target_group_arn  = module.alb.target_group_arn
  alb_listener      = module.alb.listener
  task_cpu          = var.task_cpu
  task_memory       = var.task_memory
  desired_count     = var.desired_count
}
```

#### Step 6: Create Variables and Outputs
Create `infrastructure/terraform/variables.tf` and `outputs.tf`

#### Step 7: Create Workspace Configurations
Create `infrastructure/terraform/environments/dev.tfvars`:
```hcl
environment     = "dev"
project_name    = "ai-projen-mcp"
aws_region      = "us-east-1"
vpc_cidr        = "10.0.0.0/16"
container_image = "ai-projen-mcp:latest"
task_cpu        = "256"
task_memory     = "512"
desired_count   = 1
```

Create similar files for staging and prod.

### Testing Checklist
- [ ] Terraform init succeeds
- [ ] Terraform plan shows correct resources
- [ ] Terraform apply creates infrastructure
- [ ] ECS service starts successfully
- [ ] ALB health checks pass
- [ ] Server accessible via ALB DNS

### Success Criteria
- ✅ Terraform code validates
- ✅ Infrastructure deploys successfully
- ✅ Server accessible via HTTPS
- ✅ Auto-scaling configured
- ✅ Logging and monitoring enabled

---

## PR8: CI/CD Pipeline and Production Deployment

### Summary
Create GitHub Actions workflow for automated testing, Docker image building, ECR push, and
Terraform deployment.

### Motivation
Automated deployment pipeline ensures consistent, reliable deployments to all environments.

### Prerequisites
- [x] PR7 completed
- [x] AWS ECR repository created
- [x] GitHub secrets configured

### Implementation Steps

#### Step 1: Create GitHub Actions Workflow
Create `.github/workflows/mcp-server.yml`:
```yaml
name: MCP Server CI/CD

on:
  push:
    branches: [main, develop]
    paths:
      - 'mcp-server/**'
      - 'plugins/**'
  pull_request:
    branches: [main, develop]
    paths:
      - 'mcp-server/**'

env:
  AWS_REGION: us-east-1
  ECR_REPOSITORY: ai-projen-mcp

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '20'
          cache: 'npm'
          cache-dependency-path: mcp-server/package-lock.json

      - name: Install dependencies
        working-directory: mcp-server
        run: npm ci

      - name: Run type checking
        working-directory: mcp-server
        run: npm run typecheck

      - name: Run linting
        working-directory: mcp-server
        run: npm run lint

      - name: Run tests
        working-directory: mcp-server
        run: npm test

  build:
    needs: test
    runs-on: ubuntu-latest
    if: github.event_name == 'push'
    steps:
      - uses: actions/checkout@v4

      - name: Configure AWS credentials
        uses: aws-actions/configure-aws-credentials@v4
        with:
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          aws-region: ${{ env.AWS_REGION }}

      - name: Login to Amazon ECR
        id: login-ecr
        uses: aws-actions/amazon-ecr-login@v2

      - name: Build, tag, and push image
        working-directory: mcp-server
        env:
          ECR_REGISTRY: ${{ steps.login-ecr.outputs.registry }}
          IMAGE_TAG: ${{ github.sha }}
        run: |
          docker build -t $ECR_REGISTRY/$ECR_REPOSITORY:$IMAGE_TAG .
          docker tag $ECR_REGISTRY/$ECR_REPOSITORY:$IMAGE_TAG $ECR_REGISTRY/$ECR_REPOSITORY:latest
          docker push $ECR_REGISTRY/$ECR_REPOSITORY:$IMAGE_TAG
          docker push $ECR_REGISTRY/$ECR_REPOSITORY:latest

  deploy-dev:
    needs: build
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/develop'
    environment: dev
    steps:
      - uses: actions/checkout@v4

      - name: Setup Terraform
        uses: hashicorp/setup-terraform@v3

      - name: Configure AWS credentials
        uses: aws-actions/configure-aws-credentials@v4
        with:
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          aws-region: ${{ env.AWS_REGION }}

      - name: Terraform Init
        working-directory: mcp-server/infrastructure/terraform
        run: terraform init

      - name: Terraform Plan
        working-directory: mcp-server/infrastructure/terraform
        run: terraform plan -var-file=environments/dev.tfvars

      - name: Terraform Apply
        working-directory: mcp-server/infrastructure/terraform
        run: terraform apply -var-file=environments/dev.tfvars -auto-approve

  deploy-prod:
    needs: build
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    environment: production
    steps:
      # Similar to dev but with prod.tfvars
```

#### Step 2: Create ECR Repository Setup Script
Create `mcp-server/scripts/setup-ecr.sh`:
```bash
#!/bin/bash
aws ecr create-repository \
  --repository-name ai-projen-mcp \
  --region us-east-1 \
  --image-scanning-configuration scanOnPush=true
```

#### Step 3: Document Deployment Process
Update `mcp-server/README.md` with deployment instructions

### Testing Checklist
- [ ] GitHub Actions workflow triggers on push
- [ ] Tests run successfully in CI
- [ ] Docker image builds in CI
- [ ] Image pushed to ECR
- [ ] Terraform deployment succeeds
- [ ] Service accessible after deployment

### Success Criteria
- ✅ CI/CD pipeline functional
- ✅ Automated testing on PRs
- ✅ Automated deployment on merge
- ✅ Production environment accessible
- ✅ Monitoring and alerts configured

---

## Implementation Guidelines

### Code Standards
- **TypeScript**: Strict mode enabled, explicit types
- **ESLint**: Follow configured rules
- **Prettier**: Auto-format all code
- **Naming**: camelCase for functions/variables, PascalCase for classes
- **Error Handling**: Always catch and provide meaningful errors
- **Logging**: Use console.error for server logs (stdout is for MCP protocol)

### Testing Requirements
- **Unit Tests**: All tools and resources must have tests
- **Integration Tests**: Test MCP protocol compliance
- **Coverage**: Aim for >80% coverage
- **Test Data**: Use actual ai-projen plugin structure

### Documentation Standards
- **JSDoc**: All public functions documented
- **README**: Keep updated with new features
- **Comments**: Explain "why", not "what"
- **Examples**: Provide usage examples in README

### Security Considerations
- **Path Traversal**: Validate all file paths
- **Input Validation**: Validate all tool parameters
- **No Code Execution**: Server doesn't execute user code
- **Read-Only**: Only read plugin files, never write
- **HTTPS Only**: Production must use HTTPS

### Performance Targets
- **Resource Requests**: < 500ms response time
- **Tool Calls**: < 2s response time
- **Memory**: < 512MB container usage
- **Startup**: < 10s from container start to healthy

## Rollout Strategy

### Phase 1: Development (Weeks 1-2)
- PRs 1-3: Core server and resources
- Local testing with MCP inspector
- Manual validation of all resources

### Phase 2: Enhancement (Weeks 3-4)
- PRs 4-5: Tools and validation
- Integration testing with Claude Desktop
- User acceptance testing

### Phase 3: Infrastructure (Week 5)
- PR 6: Dockerization
- PR 7: Terraform infrastructure
- Deploy to dev environment

### Phase 4: Production (Week 6)
- PR 8: CI/CD pipeline
- Deploy to staging
- Production deployment
- Monitoring and alerts

## Success Metrics

### Launch Metrics
- ✅ All 8 PRs merged successfully
- ✅ Server deployed to production
- ✅ Zero critical bugs in first week
- ✅ Response times meet targets
- ✅ 99.9% uptime in first month

### Ongoing Metrics
- ✅ Plugin discovery works for all stable plugins
- ✅ AI agents successfully install plugins via MCP
- ✅ Average response time < 1s
- ✅ Container auto-recovery < 30s
- ✅ Monthly uptime > 99.5%
