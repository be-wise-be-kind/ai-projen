# Language Plugin Template

**Purpose**: Template for creating new language plugins for ai-projen

**Use this template to**: Add support for new programming languages (Go, Rust, Java, PHP, Ruby, etc.)

---

## How to Use This Template

### Step 1: Copy This Directory

```bash
cp -r plugins/languages/_template/ plugins/languages/<language-name>/
cd plugins/languages/<language-name>/
```

### Step 2: Customize Files

1. **README.md** (this file)
   - Replace `<LANGUAGE>` with your language name
   - Document what the plugin provides
   - List supported tools (linters, formatters, test frameworks)

2. **AGENT_INSTRUCTIONS.md**
   - Step-by-step installation instructions for AI agents
   - How to select between linter/formatter options
   - How to integrate with Makefile
   - How to extend agents.md

3. **linters/** directory
   - Add subdirectories for each linter option
   - Include AGENT_INSTRUCTIONS.md and config files
   - Example: `linters/eslint/`, `linters/biome/`

4. **formatters/** directory
   - Add subdirectories for each formatter option
   - Include AGENT_INSTRUCTIONS.md and config files
   - Example: `formatters/prettier/`, `formatters/black/`

5. **testing/** directory
   - Add subdirectories for each test framework
   - Include AGENT_INSTRUCTIONS.md and config files
   - Example: `testing/jest/`, `testing/pytest/`

6. **templates/** directory
   - Makefile snippets (e.g., `makefile-<language>.mk`)
   - GitHub Actions workflows
   - Configuration file templates
   - Example code files

7. **standards/** directory
   - Language-specific coding standards
   - Naming conventions
   - Best practices documentation

### Step 3: Update PLUGIN_MANIFEST.yaml

Add your plugin to `plugins/PLUGIN_MANIFEST.yaml`:

```yaml
languages:
  <language-name>:
    status: community  # or 'planned' if you're proposing it
    description: <Language> development environment
    location: plugins/languages/<language-name>/
    dependencies:
      - foundation/ai-folder

    options:
      linters:
        available: [<linter1>, <linter2>]
        recommended: <linter1>
        description: Code quality and style checking

      formatters:
        available: [<formatter1>, <formatter2>]
        recommended: <formatter1>
        description: Automatic code formatting

      testing:
        available: [<framework1>, <framework2>]
        recommended: <framework1>
        description: Testing framework

    installation_guide: plugins/languages/<language-name>/AGENT_INSTRUCTIONS.md
```

### Step 4: Test Your Plugin

```bash
# Test standalone installation in a clean directory
mkdir -p /tmp/test-<language>-plugin
cd /tmp/test-<language>-plugin
git init

# Have an AI agent follow your AGENT_INSTRUCTIONS.md
# Verify all files are created correctly
# Run linting, formatting, testing commands
# Ensure no errors
```

### Step 5: Submit PR

1. Create feature branch: `git checkout -b feat/add-<language>-plugin`
2. Commit your changes
3. Push and create PR
4. Reference this template in PR description

## What a Complete Language Plugin Should Include

### Required Files
- ✅ `AGENT_INSTRUCTIONS.md` - Installation instructions for AI agents
- ✅ `README.md` - Human-readable plugin documentation
- ✅ At least one linter configuration
- ✅ At least one formatter configuration
- ✅ At least one test framework configuration

### Recommended Files
- ✅ Makefile snippet with targets (`make lint-<lang>`, `make test-<lang>`)
- ✅ GitHub Actions workflow template
- ✅ Standards documentation
- ✅ Example/starter code templates
- ✅ agents.md extension snippet

### Integration Points

Your plugin should:
1. **Extend agents.md** - Add language conventions between `LANGUAGE_SPECIFIC_GUIDELINES` markers
2. **Provide Make targets** - Consistent naming: `lint-<lang>`, `format-<lang>`, `test-<lang>`
3. **Work standalone** - Don't require orchestrator to function
4. **Declare dependencies** - Clear prerequisites in AGENT_INSTRUCTIONS.md
5. **Support options** - Multiple linter/formatter/testing choices with recommended defaults

## Examples to Follow

Look at existing language plugins:
- **Python**: `plugins/languages/python/` (Ruff, Black, pytest)
- **TypeScript**: `plugins/languages/typescript/` (ESLint, Prettier, Vitest)

These show complete implementations with all the features above.

## Common Patterns

### Linter Structure
```
linters/
└── <linter-name>/
    ├── AGENT_INSTRUCTIONS.md  # How to install this linter
    ├── config/
    │   └── .<linter>rc        # Linter configuration file
    └── README.md              # What this linter does
```

### Formatter Structure
```
formatters/
└── <formatter-name>/
    ├── AGENT_INSTRUCTIONS.md  # How to install this formatter
    ├── config/
    │   └── .<formatter>rc     # Formatter configuration
    └── README.md              # What this formatter does
```

### Makefile Integration
```makefile
# In templates/makefile-<language>.mk

.PHONY: lint-<lang> format-<lang> test-<lang>

lint-<lang>:
	<linter-command>

format-<lang>:
	<formatter-command>

test-<lang>:
	<test-command>
```

### agents.md Extension
```markdown
#### <Language> (<Style Guide>)
- Key conventions
- Naming patterns
- Import organization

**Linting**: `make lint-<lang>` (runs <linter>)
**Formatting**: `make format-<lang>` (runs <formatter>)
**Testing**: `make test-<lang>` (runs <test-framework>)
```

## Questions?

- See `.ai/howto/how-to-create-a-language-plugin.md` (created in PR7)
- Look at PLUGIN_ARCHITECTURE.md for plugin structure requirements
- Check PLUGIN_MANIFEST.yaml for existing plugins as examples

---

**Delete this README.md and replace with your language-specific README when creating an actual plugin.**
