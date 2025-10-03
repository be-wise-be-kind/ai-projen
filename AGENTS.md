# AI Agent Instructions for ai-projen

---

## What This Repository Does

ai-projen is a plugin-based framework that helps AI agents create and upgrade repositories to be "AI-ready."

**AI-Ready Definition**: A repository where AI agents can be trusted to generate code that is well-written, durable, scalable, performant, secure, and follows industry best practices.

**Services Provided**:
1. Create new repositories from scratch
2. Upgrade existing repositories safely
3. Add single or multiple capabilities to repositories
4. Lint, evaluate, and grade existing repositories

**Project Philosophies**:
- Maximize determinism while embracing AI agent flexibility
- Extensible for any configuration through plugins
- Human oversight required - we assist, not replace
- Explicit over implicit
- Immediate feedback loops
- Clear success and failure criteria
- Modular task decomposition
- Defensive validation
- Version control everything

---

## Determine Your Role: Two Agent Types

**FIRST STEP**: Determine which type of agent interaction this is.

### Type 1: Repository Assistant (User Working on DIFFERENT Repository)

**Detection**:
- User mentions a repository path OTHER than `/path/to/ai-projen`
- User asks about "my repo", "my project", or provides a path like `/home/user/Projects/their-app`
- User wants to create, upgrade, or add capabilities to THEIR repository

**Your Role**: Software development consultant helping users build production-ready repositories

**Proceed to**: Section "Repository Assistant Mode" below

### Type 2: Framework Developer (User Working on THIS Repository)

**Detection**:
- Working directory is `/path/to/ai-projen` (THIS repository)
- User asks about improving ai-projen itself
- User mentions adding plugins, updating documentation, or fixing framework code
- No external repository path mentioned

**Your Role**: Developer working to improve the ai-projen framework itself

**Proceed to**: Section "Framework Developer Mode" below

---

## Repository Assistant Mode

**When**: User is working on THEIR repository (not ai-projen)

**First Action**: Read `/path/to/ai-projen/.ai/index.yaml` (THIS repository's index) for complete ai-projen structure and available plugins

### Step 1: Understand User Intent

Analyze the user's request and classify it into ONE of these categories:

1. **Create New Repository**
   - Intent signals: "create new", "start from scratch", "empty directory", "new project"
   - No existing code to preserve
   - Route to: `.ai/howto/how-to-create-new-ai-repo.md`

2. **Upgrade Existing Repository**
   - Intent signals: "upgrade existing", "add AI patterns", "already have code", "enhance my repo"
   - Has working code that must be preserved
   - Route to: `.ai/howto/how-to-upgrade-to-ai-repo.md`

3. **Add Specific Capability**
   - Intent signals: "add Docker", "install Python plugin", "configure environment variables", "add [specific tool]"
   - Wants granular control, one capability at a time
   - Route to: `.ai/howto/how-to-add-capability.md`

### Step 2: Verify Repository Context

Before proceeding, confirm:
- [ ] User has provided repository path (if not, ask for it)
- [ ] Repository exists and is accessible
- [ ] Git repository is initialized (if not, initialize it first)
- [ ] Current working directory or target path is clear

### Step 3: Execute Workflow

**CRITICAL**: Follow the selected how-to guide's instructions EXACTLY. Do not deviate.

1. Read the entire how-to guide first
2. Follow steps sequentially
3. Create feature branch BEFORE making changes (per plugin instructions)
4. Validate each step's success criteria
5. Report results to user

### Step 4: Validate and Report

After execution:
- [ ] All success criteria met
- [ ] Changes on feature branch (not main)
- [ ] User informed of next steps (test, review, merge)
- [ ] No errors or warnings

### Decision Matrix

| User Request | Existing Code? | Route To |
|--------------|----------------|----------|
| "Create new Python API" | No | how-to-create-new-ai-repo.md |
| "Add Docker to my Flask app" | Yes | how-to-add-capability.md |
| "Make my repo AI-ready" | Yes | how-to-upgrade-to-ai-repo.md |
| "Setup environment variables" | Yes/No | how-to-add-capability.md |
| "Start React+Python fullstack" | No | how-to-create-new-ai-repo.md |

### Routing Examples

**Example 1**: "Help me update my environment variable handling for /home/user/my-app"
```
Analysis:
- Repository path: /home/user/my-app (DIFFERENT repo = Type 1)
- Intent: Specific capability (environment variables)
- Existing code: Assumed yes (user said "update")

Actions:
1. Classify as Type 1: Repository Assistant
2. Read /path/to/ai-projen/.ai/index.yaml (ai-projen's index)
3. Route to: /path/to/ai-projen/.ai/howto/how-to-add-capability.md
4. Follow guide to discover environment-setup plugin
5. Execute plugin's AGENT_INSTRUCTIONS.md in /home/user/my-app
6. Create feature branch in /home/user/my-app before changes
7. Validate installation
8. Report completion and next steps
```

**Example 2**: "Create a new Python CLI tool"
```
Analysis:
- Repository path: Not provided (ASK USER)
- Intent: Create new repository
- Existing code: No

Actions:
1. Classify as Type 1: Repository Assistant
2. Ask user for target directory
3. Read /path/to/ai-projen/.ai/index.yaml (ai-projen's index)
4. Route to: /path/to/ai-projen/.ai/howto/how-to-create-new-ai-repo.md
5. Follow discovery questions
6. Identify python-cli application plugin
7. Execute complete installation in target directory
8. Validate final result
```

**Example 3**: "I have an existing Django app, want to add CI/CD"
```
Analysis:
- Repository path: User's Django app (ask for path)
- Intent: Add specific capability to existing repo
- Existing code: Yes (Django app)

Actions:
1. Classify as Type 1: Repository Assistant
2. Confirm repository path
3. Read /path/to/ai-projen/.ai/index.yaml (ai-projen's index)
4. Route to: /path/to/ai-projen/.ai/howto/how-to-add-capability.md
5. Discover github-actions CI/CD plugin
6. Execute plugin's AGENT_INSTRUCTIONS.md in user's Django app
7. Create feature branch in user's Django app
8. Integrate with existing Django setup
9. Validate workflows
```

### Critical Rules for Repository Assistant Mode

1. **NEVER work directly on main branch** - Always create feature branch per plugin instructions
2. **ALWAYS validate prerequisites** before starting
3. **FOLLOW plugin AGENT_INSTRUCTIONS.md EXACTLY** - No improvisation
4. **ASK for clarification** if intent is ambiguous
5. **REPORT results** with clear next steps for user
6. **EXIT early** if prerequisites not met
7. **PRESERVE existing code** in upgrade scenarios - never break working functionality

---

## Framework Developer Mode

**When**: User is working on ai-projen repository ITSELF

**First Action**: Read `.ai/index.yaml` (in ai-projen root) for complete repository structure

### Step 1: Determine Development Task Type

Classify the request:

1. **Add New Plugin**
   - Intent: Create new plugin for ai-projen
   - Guide: `.ai/docs/PLUGIN_GIT_WORKFLOW_STANDARD.md` + relevant how-to-create-a-*-plugin.md

2. **Update Existing Plugin**
   - Intent: Modify existing plugin's behavior or documentation
   - Guide: Locate plugin's AGENT_INSTRUCTIONS.md, update following standards

3. **Improve Documentation**
   - Intent: Update guides, standards, or README files
   - Guide: `.ai/docs/FILE_HEADER_STANDARDS.md`, `.ai/docs/HOWTO_STANDARDS.md`

4. **Fix Bugs**
   - Intent: Correct errors in framework
   - Guide: Standard Git workflow, reference roadmap/PROGRESS_TRACKER.md

5. **Continue Roadmap**
   - Intent: Implement next PR from roadmap
   - Guide: `roadmap/ai_projen_implementation/PR_BREAKDOWN.md`

### Step 2: Review Relevant Standards

Before making changes, review:
- `.ai/index.yaml` - Repository structure
- `.ai/docs/PLUGIN_GIT_WORKFLOW_STANDARD.md` - Git workflow requirements
- `.ai/docs/FILE_HEADER_STANDARDS.md` - File documentation requirements
- `roadmap/ai_projen_implementation/PROGRESS_TRACKER.md` - Current state
- `plugins/PLUGIN_MANIFEST.yaml` - Existing plugins

### Step 3: Create Feature Branch

**MANDATORY**: Create feature branch BEFORE any changes

```bash
# Branch naming convention
feature/add-<plugin-name>    # For new features
fix/<issue-description>      # For bug fixes
enhance/<capability-name>    # For improvements
docs/<documentation-update>  # For documentation only
```

### Step 4: Make Changes

Follow these standards:
- **All files** require file headers per FILE_HEADER_STANDARDS.md
- **All plugins** require AGENT_INSTRUCTIONS.md and README.md
- **All changes** update relevant documentation
- **YAML files** validate before committing
- **Commit messages** follow conventional commits format

### Step 5: Validate Changes

Run validation:
```bash
# Validate YAML files
python3 -c "import yaml; yaml.safe_load(open('plugins/PLUGIN_MANIFEST.yaml'))"
python3 -c "import yaml; yaml.safe_load(open('.ai/index.yaml'))"

# Test plugin installation (if plugin changed)
# Create test directory and verify plugin works standalone
```

### Step 6: Commit and Merge

```bash
# Stage changes
git add -A

# Commit with conventional format
git commit -m "feat(pr<N>): Brief description

Detailed explanation

Changes:
- Specific change 1
- Specific change 2

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>"

# Merge to main
git checkout main
git merge <branch-name>

# Delete feature branch
git branch -d <branch-name>
```

### Framework Development Examples

**Example 1**: "Add branching requirement to Python plugin"
```
Analysis:
- Working directory: /path/to/ai-projen (THIS repo = Type 2)
- Task: Update existing plugin
- File: plugins/languages/python/core/AGENT_INSTRUCTIONS.md

Actions:
1. Classify as Type 2: Framework Developer
2. Read PLUGIN_GIT_WORKFLOW_STANDARD.md
3. Create branch: fix/add-branching-to-python-plugin
4. Update AGENT_INSTRUCTIONS.md with Step 2 (branching)
5. Renumber subsequent steps
6. Validate YAML still parses
7. Commit with conventional message
8. Merge to main
```

**Example 2**: "Continue with PR 20 from roadmap"
```
Analysis:
- Working directory: /path/to/ai-projen (THIS repo = Type 2)
- Task: Continue roadmap implementation
- Reference: roadmap/ai_projen_implementation/PR_BREAKDOWN.md

Actions:
1. Classify as Type 2: Framework Developer
2. Read PROGRESS_TRACKER.md for current state
3. Read PR_BREAKDOWN.md for PR 20 requirements
4. Create branch: feature/pr20-full-stack-integration-test
5. Follow PR 20 implementation steps exactly
6. Update PROGRESS_TRACKER.md when complete
7. Commit and merge
```

### Critical Rules for Framework Developer Mode

1. **ALWAYS create feature branch** before changes
2. **NEVER push to develop** (per CLAUDE.md user instruction)
3. **ALWAYS update PROGRESS_TRACKER.md** when completing PRs
4. **FOLLOW all standards** in .ai/docs/
5. **TEST plugins standalone** before considering complete
6. **VALIDATE YAML** before committing
7. **UPDATE index.yaml** when adding new files/sections
8. **MAINTAIN backward compatibility** or document breaking changes

---

## Navigation Reference

### Essential Starting Points
- **`.ai/index.yaml`** - Complete repository map (READ THIS FIRST)
- **`.ai/layout.yaml`** - Directory organization rules

### Plugin System
- **`plugins/PLUGIN_MANIFEST.yaml`** - All available plugins and their options
- **`plugins/*/AGENT_INSTRUCTIONS.md`** - Plugin installation instructions
- **`.ai/docs/PLUGIN_ARCHITECTURE.md`** - How plugins work
- **`.ai/docs/PLUGIN_GIT_WORKFLOW_STANDARD.md`** - Required Git workflow for plugins

### Workflow Guides (for Repository Assistant Mode)
- **`.ai/howto/how-to-create-new-ai-repo.md`** - Create new repository
- **`.ai/howto/how-to-upgrade-to-ai-repo.md`** - Upgrade existing repository
- **`.ai/howto/how-to-add-capability.md`** - Add single capability

### Standards (for Framework Developer Mode)
- **`.ai/docs/FILE_HEADER_STANDARDS.md`** - File documentation requirements
- **`.ai/docs/HOWTO_STANDARDS.md`** - How-to guide standards
- **`.ai/docs/MANIFEST_VALIDATION.md`** - Plugin manifest schema

### Roadmap (for Framework Developer Mode)
- **`roadmap/ai_projen_implementation/PROGRESS_TRACKER.md`** - Current state
- **`roadmap/ai_projen_implementation/PR_BREAKDOWN.md`** - Detailed PR requirements
- **`roadmap/ai_projen_implementation/AI_CONTEXT.md`** - Feature overview

---

## Quick Decision Tree

```
START
  │
  ├─ User mentions external repository path?
  │  │
  │  YES → Type 1: Repository Assistant Mode
  │  │      ├─ Read /path/to/ai-projen/.ai/index.yaml
  │  │      ├─ Classify intent (create/upgrade/add)
  │  │      ├─ Route to appropriate ai-projen how-to guide
  │  │      ├─ Execute workflow in USER'S repository
  │  │      └─ Validate and report
  │  │
  │  NO → Type 2: Framework Developer Mode
  │         ├─ Read ai-projen/.ai/index.yaml
  │         ├─ Classify task type
  │         ├─ Review relevant standards
  │         ├─ Create feature branch in ai-projen
  │         ├─ Make changes following standards
  │         ├─ Validate changes
  │         └─ Commit and merge to ai-projen
```

---

## Failure Handling

### If Prerequisites Not Met
1. **STOP** - Do not proceed
2. **INFORM** user what is missing
3. **PROVIDE** clear instructions to resolve
4. **WAIT** for user confirmation before continuing

### If Workflow Step Fails
1. **IDENTIFY** which step failed
2. **READ** step's success criteria
3. **CHECK** what actually happened vs expected
4. **REPORT** specific error to user
5. **SUGGEST** remediation steps
6. **OFFER** to rollback if needed

### If Ambiguous Intent
1. **DO NOT GUESS** - Ambiguity = high failure risk
2. **ASK** user for clarification with specific options
3. **PRESENT** decision matrix if helpful
4. **WAIT** for explicit user choice

---

## Success Criteria

### Repository Assistant Mode Success
- [ ] Correct how-to guide selected and followed
- [ ] All changes on feature branch (not main)
- [ ] Plugin installation successful
- [ ] Validation checks pass
- [ ] User informed of next steps

### Framework Developer Mode Success
- [ ] Feature branch created before changes
- [ ] All standards followed (headers, YAML, docs)
- [ ] Relevant documentation updated
- [ ] YAML files validate
- [ ] Changes committed with conventional message
- [ ] PROGRESS_TRACKER.md updated (if roadmap work)

---

**Core Principle**: This repository teaches AI-ready patterns. It must exemplify those patterns. Be deterministic, explicit, and defensive. When in doubt, ask the user.