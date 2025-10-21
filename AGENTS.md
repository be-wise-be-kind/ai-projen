# AI Agent Instructions for ai-projen

---

## MANDATORY: First Action for Every Task

**BEFORE working on ANY task, you MUST:**

1. ✅ **READ** `.ai/index.yaml` to understand available resources
2. ✅ **IDENTIFY** relevant documentation, howtos, templates, and roadmaps for your task
3. ✅ **READ** all applicable documents completely before proceeding
4. ✅ **INFORM** the user which documents you are using to solve the problem

**Process:**
```
1. Scan .ai/index.yaml sections:
   - howto: (orchestration guides like how-to-create-new-ai-repo.md)
   - documentation: (architectural context and standards)
   - templates: (roadmap and file templates)
   - roadmap: (active feature roadmaps)

2. Read applicable documents in this order:
   - Roadmap documents first (if continuing roadmap work)
   - How-to guides second
   - Standards/documentation third
   - Templates fourth

3. Tell the user:
   "I will use these resources to solve this problem:
    - [document 1]: [why it's relevant]
    - [document 2]: [why it's relevant]"

4. Then proceed with the task following the guidance
```

**Examples:**

- **Task: "Continue with PR2 on roadmap X"** →
  1. Read `.ai/index.yaml` to locate roadmap
  2. Read roadmap's `PROGRESS_TRACKER.md`, `PR_BREAKDOWN.md`, `AI_CONTEXT.md`
  3. Inform user: "Using roadmap X/PROGRESS_TRACKER.md for PR2 implementation"

- **Task: "Create new AI repo"** →
  1. Read `.ai/index.yaml`
  2. Read `how-to-create-new-ai-repo.md`
  3. Inform user: "Using how-to-create-new-ai-repo.md orchestration guide"

- **Task: "Add capability to repo"** →
  1. Read `.ai/index.yaml`
  2. Read `how-to-add-capability.md`
  3. Inform user: "Using how-to-add-capability.md for adding capabilities"

- **Task: "Improve ai-projen plugin"** →
  1. Read `.ai/index.yaml`
  2. Read `PLUGIN_GIT_WORKFLOW_STANDARD.md`
  3. Inform user: "Using PLUGIN_GIT_WORKFLOW_STANDARD.md for framework development"

**This is NOT optional.** Skipping this step leads to incomplete work and not following established patterns.

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

**First Actions**: Read these three documents from ai-projen:
1. `/path/to/ai-projen/.ai/index.yaml` - Complete structure and navigation
2. `/path/to/ai-projen/.ai/docs/PROJECT_CONTEXT.md` - Architecture and philosophy
3. `/path/to/ai-projen/.ai/layout.yaml` - Directory organization rules

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

**Confirm Intent with User**:

After classification, present your understanding to the user and wait for confirmation:

```
I understand you want to: [CREATE NEW / UPGRADE EXISTING / ADD CAPABILITY]

Specifically:
- Repository: [path or "new directory to be created"]
- Goal: [concise description of what will be done]
- Approach: [which how-to guide will be used]

Is this correct? (yes/no)
```

**If user says NO**: Ask for clarification and reclassify
**If user says YES**: Proceed to Step 2

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
2. Read ai-projen's three core documents:
   - /path/to/ai-projen/.ai/index.yaml
   - /path/to/ai-projen/.ai/docs/PROJECT_CONTEXT.md
   - /path/to/ai-projen/.ai/layout.yaml
3. Present to user:
   "I understand you want to: ADD CAPABILITY

   Specifically:
   - Repository: /home/user/my-app
   - Goal: Setup proper environment variable handling with direnv and .env files
   - Approach: Use .ai/howto/how-to-add-capability.md to install environment-setup plugin

   Is this correct? (yes/no)"
4. Wait for user confirmation
5. Route to: /path/to/ai-projen/.ai/howto/how-to-add-capability.md
6. Follow guide to discover environment-setup plugin
7. Execute plugin's AGENT_INSTRUCTIONS.md in /home/user/my-app
8. Create feature branch in /home/user/my-app before changes
9. Validate installation
10. Report completion and next steps
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
3. Read ai-projen's three core documents:
   - /path/to/ai-projen/.ai/index.yaml
   - /path/to/ai-projen/.ai/docs/PROJECT_CONTEXT.md
   - /path/to/ai-projen/.ai/layout.yaml
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
3. Read ai-projen's three core documents:
   - /path/to/ai-projen/.ai/index.yaml
   - /path/to/ai-projen/.ai/docs/PROJECT_CONTEXT.md
   - /path/to/ai-projen/.ai/layout.yaml
4. Route to: /path/to/ai-projen/.ai/howto/how-to-add-capability.md
5. Discover github-actions CI/CD plugin
6. Execute plugin's AGENT_INSTRUCTIONS.md in user's Django app
7. Create feature branch in user's Django app
8. Integrate with existing Django setup
9. Validate workflows
```

### Critical Rules for Repository Assistant Mode

#### Core Behavioral Rules

**⚠️ ANTI-SHORTCUT WARNING:**

If you are thinking any of the following, STOP immediately:
- "I can just copy the files and get this working quickly"
- "I'll skip asking the user to save time"
- "The end result is the same, so I can skip steps"
- "Following all these steps is too slow, let me take a shortcut"
- "I see the final application files, so I don't need to run the plugins"
- "This is taking too long, I need to wrap it up"
- "We are using too many tokens, I should stop or skip steps"

**You are about to make a critical error that will create a broken installation.**

**Token usage and time are NOT valid reasons to skip steps.** The user expects:
- Complete, correct installations even if they take time
- All questions to be asked even if it requires more tokens
- Full process adherence regardless of token count or duration

**Why shortcuts ALWAYS fail:**
1. **Missing Infrastructure**: Plugins create infrastructure (like `.docker/` folders, CI/CD configs, etc.) that application code depends on - copying files WITHOUT running plugins creates broken systems
2. **User Control**: Users MUST be asked about optional features - skipping questions violates their autonomy
3. **Repeatability**: Shortcuts create unpredictable, non-repeatable results
4. **Hidden Dependencies**: Plugin execution order matters - shortcuts break dependency chains

**The correct priority order is:**
1. FIRST: Follow instructions exactly as written
2. SECOND: Ask all required questions
3. THIRD: Execute all steps in order
4. LAST: Achieve the end goal

**Process correctness > Speed > End result**

#### Mandatory Directives

1. **"Follow:" directive is MANDATORY**
   - When you see: `Follow: plugins/some-plugin/AGENT_INSTRUCTIONS.md`
   - This means: Execute that plugin's installation completely
   - NOT: "This is optional" or "I can skip this" or "Files exist, so I don't need to"

2. **"ASK USER" means STOP and ASK**
   - When instructions say "Ask the user" or "STOP and ASK THE USER"
   - You MUST stop execution and present the question to the user
   - You MUST wait for their response before proceeding
   - Do NOT assume answers or skip questions to "save time"

3. **Create granular todo items for multi-phase tasks**
   - For meta-plugins or complex installations, create separate todo items for EACH phase
   - WRONG: `☐ Execute react-python-fullstack plugin installation`
   - CORRECT:
     ```
     ☐ Phase 1: Install foundation plugin
     ☐ Phase 2: Install language plugins
     ☐ Phase 3: Ask user about Docker, then install if yes
     ☐ Phase 4: Install standards plugins
     ...
     ```

#### General Rules

4. **NEVER work directly on main branch** - Always create feature branch per plugin instructions
5. **ALWAYS validate prerequisites** before starting
6. **FOLLOW plugin AGENT_INSTRUCTIONS.md EXACTLY** - No improvisation, no shortcuts
7. **ASK for clarification** if intent is ambiguous
8. **REPORT results** with clear next steps for user
9. **EXIT early** if prerequisites not met
10. **PRESERVE existing code** in upgrade scenarios - never break working functionality
11. **ROADMAP validation overrides plugin instructions** - When executing a roadmap PR:
   - Primary source: PROGRESS_TRACKER.md validation section for that PR
   - Reference only: Individual plugin AGENT_INSTRUCTIONS.md for understanding
   - Rule: Validate what the ROADMAP says, not what the plugin says
   - If roadmap validation checks file existence, do NOT run tool commands
   - Prerequisites (poetry/npm installed) are checked once at start, not per-PR

---

## Framework Developer Mode

**When**: User is working on ai-projen repository ITSELF

**First Actions**: Read these three documents from ai-projen:
1. `.ai/index.yaml` - Complete structure and navigation
2. `.ai/docs/PROJECT_CONTEXT.md` - Architecture and philosophy
3. `.ai/layout.yaml` - Directory organization rules

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
   - **Detection signals**: User says "continue with PR", "lets continue", provides roadmap directory path, or mentions "roadmap"
   - **CRITICAL**: When user provides a DIRECTORY PATH (not a file), this is likely a roadmap directory
   - **Process**:
     1. Check if path is a directory containing roadmap documents
     2. Read `PROGRESS_TRACKER.md` from that directory
     3. Read `PR_BREAKDOWN.md` from that directory
     4. Read `AI_CONTEXT.md` from that directory (if exists)
     5. Inform user: "Using roadmap at [path] for PR[N] implementation"
     6. Follow the "Next PR to Implement" section in PROGRESS_TRACKER.md
   - **If roadmap path not provided**: Ask user for roadmap directory path (e.g., `.roadmap/in-progress/my-feature/`)
   - Guide: Use roadmap's `PR_BREAKDOWN.md` and `PROGRESS_TRACKER.md` from provided path

6. **Create New Feature Roadmap**
   - Intent: Plan a new major feature or upgrade
   - Templates: `.ai/templates/roadmap-*.md.template`
   - Guide: Use roadmap templates to create comprehensive planning documents

### Step 2: Review Relevant Standards

Before making changes, review:
- `.ai/index.yaml` - Repository structure
- `.ai/docs/PLUGIN_GIT_WORKFLOW_STANDARD.md` - Git workflow requirements
- `.ai/docs/FILE_HEADER_STANDARDS.md` - File documentation requirements
- Roadmap's `PROGRESS_TRACKER.md` - Current state (if working on roadmap)
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

**Example 2**: "Continue with PR2 on roadmap at .roadmap/in-progress/my-feature/"
```
Analysis:
- Working directory: /path/to/ai-projen (THIS repo = Type 2)
- Task: Continue roadmap implementation
- Roadmap path: PROVIDED as directory path

Actions:
1. Classify as Type 2: Framework Developer
2. Detect directory path → likely roadmap
3. Read .ai/index.yaml to confirm roadmap location
4. Read .roadmap/in-progress/my-feature/PROGRESS_TRACKER.md
5. Read .roadmap/in-progress/my-feature/PR_BREAKDOWN.md
6. Read .roadmap/in-progress/my-feature/AI_CONTEXT.md (if exists)
7. Inform user: "Using roadmap at .roadmap/in-progress/my-feature/ for PR2 implementation"
8. Identify next PR from "Next PR to Implement" section
9. Create branch: feature/pr2-<description>
10. Follow PR implementation steps exactly from PR_BREAKDOWN.md
11. Update PROGRESS_TRACKER.md when complete
12. Commit and merge
```

**Example 3**: "Continue with next PR from roadmap" (no path provided)
```
Analysis:
- Working directory: /path/to/ai-projen (THIS repo = Type 2)
- Task: Continue roadmap implementation
- Roadmap path: NOT PROVIDED (must ask)

Actions:
1. Classify as Type 2: Framework Developer
2. Ask user: "What is the roadmap directory path?" (e.g., .roadmap/in-progress/my-feature/)
3. Wait for user to provide path
4. Then follow Example 2 process
```

### Critical Rules for Framework Developer Mode

1. **ALWAYS create feature branch** before changes
2. **NEVER push to develop** (per CLAUDE.md user instruction)
3. **ALWAYS update roadmap's PROGRESS_TRACKER.md** when completing PRs (if working on roadmap)
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

### Roadmap (for Framework Developer Mode - if applicable)
When working on a roadmap, ask user for roadmap directory path. Typical structure:
- **`<roadmap-path>/PROGRESS_TRACKER.md`** - Current state and next PR to implement
- **`<roadmap-path>/PR_BREAKDOWN.md`** - Detailed PR requirements
- **`<roadmap-path>/AI_CONTEXT.md`** - Feature overview (optional)

### Roadmap Templates (for creating new roadmaps)
When planning a major feature or repository upgrade:
- **`.ai/templates/roadmap-progress-tracker.md.template`** - Track current progress and AI agent handoff
- **`.ai/templates/roadmap-pr-breakdown.md.template`** - Break features into atomic PRs with implementation steps
- **`.ai/templates/roadmap-ai-context.md.template`** - Provide comprehensive feature context for AI agents

**Three-Document Roadmap Structure**:
1. **PROGRESS_TRACKER.md** (Required) - Primary handoff document, tracks current state, shows next PR to implement
2. **PR_BREAKDOWN.md** (Required for multi-PR features) - Detailed implementation steps for each PR
3. **AI_CONTEXT.md** (Optional) - Architectural decisions, feature vision, integration points

**When to Use**:
- Major features requiring multiple PRs
- Large repository upgrades or migrations
- Complex features needing AI agent coordination
- Features requiring explicit progress tracking

**How to Use**:
1. Copy templates from `.ai/templates/` to `roadmap/<feature-name>/`
2. Replace `{{PLACEHOLDERS}}` with actual values
3. Commit roadmap documents before starting work
4. Update PROGRESS_TRACKER.md after each PR completion

---

## Quick Decision Tree

```
START
  │
  ├─ User mentions external repository path?
  │  │
  │  YES → Type 1: Repository Assistant Mode
  │  │      ├─ Read ai-projen's 3 core docs (index, context, layout)
  │  │      ├─ Classify intent (create/upgrade/add)
  │  │      ├─ Confirm understanding with user
  │  │      ├─ Route to appropriate ai-projen how-to guide
  │  │      ├─ Execute workflow in USER'S repository
  │  │      └─ Validate and report
  │  │
  │  NO → Type 2: Framework Developer Mode
  │         ├─ Read ai-projen's 3 core docs (index, context, layout)
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
- [ ] Roadmap's PROGRESS_TRACKER.md updated (if working on roadmap)

---

**Core Principle**: This repository teaches AI-ready patterns. It must exemplify those patterns. Be deterministic, explicit, and defensive. When in doubt, ask the user.