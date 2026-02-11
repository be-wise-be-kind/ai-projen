# AI Agent Instructions for ai-projen

---

## MANDATORY: First Action for Every Task

**BEFORE working on ANY task, you MUST:**

1. **READ** `.ai/ai-context.md` - Project context and patterns
2. **READ** `.ai/ai-rules.md` - Quality gates and mandatory rules
3. **READ** `.ai/index.yaml` - Navigation and resource index
4. **IDENTIFY** relevant howtos, docs, and templates for your task
5. **INFORM** the user which documents you will use
6. **PROCEED** with the task

**Process:**
```
1. Read the three core documents:
   - .ai/ai-context.md (understand what ai-projen does and how)
   - .ai/ai-rules.md (understand quality gates and mandatory rules)
   - .ai/index.yaml (navigate to task-specific resources)

2. Scan index.yaml sections for task-relevant resources:
   - howto: (orchestration guides, roadmap guides, plugin creation)
   - documentation: (architectural context and standards)
   - templates: (feature, initiative, and code templates)
   - roadmap: (active features and initiatives)

3. Read applicable documents in this order:
   - Roadmap documents first (if continuing roadmap work)
   - How-to guides second
   - Standards/documentation third
   - Templates fourth

4. Tell the user:
   "I will use these resources to solve this problem:
    - [document 1]: [why it's relevant]
    - [document 2]: [why it's relevant]"

5. Then proceed with the task following the guidance
```

**This is NOT optional.** Skipping this step leads to incomplete work and not following established patterns.

---

## Project Overview

ai-projen is a plugin-based framework that helps AI agents create and upgrade repositories to be "AI-ready" - where AI agents can be trusted to generate code that is well-written, durable, scalable, performant, secure, and follows industry best practices.

**Services**: Create new repos, upgrade existing repos, add capabilities, lint and evaluate repos.

---

## Determine Your Role: Two Agent Types

### Type 1: Repository Assistant (User Working on DIFFERENT Repository)

**Detection**:
- User mentions a repository path OTHER than ai-projen
- User asks about "my repo", "my project", or provides a path to their app
- User wants to create, upgrade, or add capabilities to THEIR repository

**Your Role**: Software development consultant helping users build production-ready repositories

**Proceed to**: Section "Repository Assistant Mode" below

### Type 2: Framework Developer (User Working on THIS Repository)

**Detection**:
- Working directory is ai-projen
- User asks about improving ai-projen itself
- User mentions adding plugins, updating documentation, or fixing framework code

**Your Role**: Developer working to improve the ai-projen framework

**Proceed to**: Section "Framework Developer Mode" below

---

## Repository Assistant Mode

**When**: User is working on THEIR repository (not ai-projen)

**First Actions**: Read three core documents from ai-projen:
1. `/path/to/ai-projen/.ai/ai-context.md` - Project context and architecture
2. `/path/to/ai-projen/.ai/ai-rules.md` - Quality gates and mandatory rules
3. `/path/to/ai-projen/.ai/index.yaml` - Navigation and resource index

### Step 1: Understand User Intent

Classify the request into ONE category:

1. **Create New Repository**
   - Intent signals: "create new", "start from scratch", "empty directory", "new project"
   - Route to: `.ai/howto/how-to-create-new-ai-repo.md`

2. **Upgrade Existing Repository**
   - Intent signals: "upgrade existing", "add AI patterns", "already have code", "enhance my repo"
   - Route to: `.ai/howto/how-to-upgrade-to-ai-repo.md`

3. **Add Specific Capability**
   - Intent signals: "add Docker", "install Python plugin", "add [specific tool]"
   - Route to: `.ai/howto/how-to-add-capability.md`

**Confirm Intent with User**:
```
I understand you want to: [CREATE NEW / UPGRADE EXISTING / ADD CAPABILITY]

Specifically:
- Repository: [path or "new directory"]
- Goal: [concise description]
- Approach: [which how-to guide]

Is this correct? (yes/no)
```

### Step 2: Verify Repository Context

Before proceeding, confirm:
- [ ] User has provided repository path
- [ ] Repository exists and is accessible
- [ ] Git repository is initialized
- [ ] Current working directory or target path is clear

### Step 3: Execute Workflow

**CRITICAL**: Follow the selected how-to guide's instructions EXACTLY.

1. Read the entire how-to guide first
2. Follow steps sequentially
3. Create feature branch BEFORE making changes
4. Validate each step's success criteria
5. Report results to user

### Step 4: Validate and Report

After execution:
- [ ] All success criteria met
- [ ] Changes on feature branch (not main)
- [ ] User informed of next steps

### Critical Rules for Repository Assistant Mode

**ANTI-SHORTCUT WARNING:**

If you are thinking any of the following, STOP immediately:
- "I can just copy the files and get this working quickly"
- "I'll skip asking the user to save time"
- "The end result is the same, so I can skip steps"
- "This is taking too long, I need to wrap it up"

**You are about to make a critical error that will create a broken installation.**

**Why shortcuts ALWAYS fail:**
1. **Missing Infrastructure**: Plugins create infrastructure that application code depends on
2. **User Control**: Users MUST be asked about optional features
3. **Repeatability**: Shortcuts create unpredictable results
4. **Hidden Dependencies**: Plugin execution order matters

**Mandatory Directives:**

1. **"Follow:" directive is MANDATORY** - Execute the referenced plugin's installation completely
2. **"ASK USER" means STOP and ASK** - Present the question and wait for response
3. **Create granular todo items** for multi-phase tasks
4. **NEVER work directly on main branch**
5. **FOLLOW plugin AGENT_INSTRUCTIONS.md EXACTLY**
6. **PRESERVE existing code** in upgrade scenarios

**Process correctness > Speed > End result**

---

## Framework Developer Mode

**When**: User is working on ai-projen repository ITSELF

**First Actions**: Read three core documents:
1. `.ai/ai-context.md` - Project context and architecture
2. `.ai/ai-rules.md` - Quality gates and mandatory rules
3. `.ai/index.yaml` - Navigation and resource index

### Step 1: Determine Development Task Type

Classify the request:

1. **Add New Plugin**
   - Guide: `.ai/docs/PLUGIN_GIT_WORKFLOW_STANDARD.md` + relevant how-to-create-a-*-plugin.md

2. **Update Existing Plugin**
   - Guide: Locate plugin's AGENT_INSTRUCTIONS.md, update following standards

3. **Improve Documentation**
   - Guide: `.ai/docs/FILE_HEADER_STANDARDS.md`, `.ai/docs/HOWTO_STANDARDS.md`

4. **Fix Bugs**
   - Guide: Standard Git workflow

5. **Plan Feature**
   - Detection: "plan", "roadmap", "break down", "design"
   - Guide: `.ai/howto/how-to-plan-a-feature.md`
   - Creates: `.roadmap/features/planning/<feature-name>/` with three documents

6. **Plan Initiative**
   - Detection: "initiative", "strategic", "multiple features", "program"
   - Guide: `.ai/howto/how-to-plan-an-initiative.md`
   - Creates: `.roadmap/initiatives/planning/<initiative-name>/` with three documents

7. **Continue Feature Work**
   - Detection: "continue", "resume", "next milestone", provides roadmap path
   - Guide: `.ai/howto/how-to-continue-feature-work.md`
   - Process:
     1. Read PROGRESS_TRACKER.md from feature directory
     2. Read MILESTONE_BREAKDOWN.md
     3. Read AI_CONTEXT.md (if exists)
     4. Inform user which milestone is next
     5. Follow implementation steps

8. **Continue Initiative Work**
   - Detection: references initiative, asks about initiative progress
   - Guide: `.ai/howto/how-to-continue-initiative-work.md`
   - Routes to the appropriate active feature within the initiative

9. **Update Progress**
   - Detection: "update progress", "mark complete", "status update"
   - Guide: `.ai/howto/how-to-update-progress.md`

### Step 2: Review Relevant Standards

Before making changes, review:
- `.ai/ai-rules.md` - Mandatory rules
- `.ai/docs/PLUGIN_GIT_WORKFLOW_STANDARD.md` - Git workflow (if plugin work)
- `.ai/docs/FILE_HEADER_STANDARDS.md` - File documentation (if creating files)

### Step 3: Create Feature Branch

**MANDATORY**: Create feature branch BEFORE any changes

```bash
feature/add-<plugin-name>    # For new features
fix/<issue-description>      # For bug fixes
enhance/<capability-name>    # For improvements
docs/<documentation-update>  # For documentation only
```

### Step 4: Make Changes

Follow these standards:
- **All files** require file headers per FILE_HEADER_STANDARDS.md
- **All plugins** require AGENT_INSTRUCTIONS.md and README.md
- **YAML files** validate before committing
- **Commit messages** follow conventional commits format

### Step 5: Validate and Commit

```bash
# Validate YAML files
python3 -c "import yaml; yaml.safe_load(open('plugins/PLUGIN_MANIFEST.yaml'))"
python3 -c "import yaml; yaml.safe_load(open('.ai/index.yaml'))"
```

### Critical Rules for Framework Developer Mode

1. **ALWAYS create feature branch** before changes
2. **NEVER push to main** (per CLAUDE.md user instruction)
3. **ALWAYS update PROGRESS_TRACKER.md** when completing milestones (if working on roadmap)
4. **FOLLOW all standards** in .ai/docs/
5. **VALIDATE YAML** before committing
6. **UPDATE index.yaml** when adding new files/sections

---

## Roadmap-Driven Development

### Feature vs Initiative

| Concept | Scope | Location | Documents |
|---------|-------|----------|-----------|
| **Feature** | Single deliverable, 1+ milestones | `.roadmap/features/` | PROGRESS_TRACKER.md, MILESTONE_BREAKDOWN.md, AI_CONTEXT.md |
| **Initiative** | Strategic grouping of features | `.roadmap/initiatives/` | INITIATIVE_TRACKER.md, FEATURE_BREAKDOWN.md, AI_CONTEXT.md |

### Lifecycle

```
planning/ -> active/ -> completed/
```

### Detection Patterns

**Plan a feature** - User says:
- "Plan feature X", "Roadmap X", "Break down X", "Design X"
- Route to: `.ai/howto/how-to-plan-a-feature.md`

**Plan an initiative** - User says:
- "Plan initiative X", "Strategic plan for X", "Group these features"
- Route to: `.ai/howto/how-to-plan-an-initiative.md`

**Continue feature work** - User says:
- "Continue with X", "Resume X", "Next milestone", provides feature path
- Route to: `.ai/howto/how-to-continue-feature-work.md`

**Continue initiative work** - User says:
- "Continue initiative X", "What's next in initiative X"
- Route to: `.ai/howto/how-to-continue-initiative-work.md`

**Update progress** - User says:
- "Update progress on X", "Mark X complete", "Status update"
- Route to: `.ai/howto/how-to-update-progress.md`

**Convert feature to initiative** - User says:
- "This feature is too big", "Promote to initiative", "Split into sub-features"
- Route to: `.ai/howto/how-to-convert-feature-to-initiative.md`

### Templates

Feature templates in `.ai/templates/`:
- `feature-progress-tracker.md.template`
- `feature-milestone-breakdown.md.template`
- `feature-ai-context.md.template`

Initiative templates in `.ai/templates/`:
- `initiative-tracker.md.template`
- `initiative-feature-breakdown.md.template`
- `initiative-ai-context.md.template`

---

## Navigation Reference

### Three Core Documents
- **`.ai/ai-context.md`** - Project context, architecture, patterns
- **`.ai/ai-rules.md`** - Quality gates, mandatory rules
- **`.ai/index.yaml`** - Complete repository map (READ THIS FIRST)

### Plugin System
- **`plugins/PLUGIN_MANIFEST.yaml`** - All available plugins and options
- **`plugins/*/AGENT_INSTRUCTIONS.md`** - Plugin installation instructions
- **`.ai/docs/PLUGIN_ARCHITECTURE.md`** - How plugins work
- **`.ai/docs/PLUGIN_GIT_WORKFLOW_STANDARD.md`** - Required Git workflow

### Workflow Guides (Repository Assistant Mode)
- **`.ai/howto/how-to-create-new-ai-repo.md`** - Create new repository
- **`.ai/howto/how-to-upgrade-to-ai-repo.md`** - Upgrade existing repository
- **`.ai/howto/how-to-add-capability.md`** - Add single capability

### Roadmap Guides
- **`.ai/howto/how-to-plan-a-feature.md`** - Plan a new feature
- **`.ai/howto/how-to-plan-an-initiative.md`** - Plan a strategic initiative
- **`.ai/howto/how-to-continue-feature-work.md`** - Continue feature implementation
- **`.ai/howto/how-to-continue-initiative-work.md`** - Continue initiative work
- **`.ai/howto/how-to-update-progress.md`** - Update progress on features/initiatives
- **`.ai/howto/how-to-convert-feature-to-initiative.md`** - Promote feature to initiative

### Standards (Framework Developer Mode)
- **`.ai/docs/FILE_HEADER_STANDARDS.md`** - File documentation requirements
- **`.ai/docs/HOWTO_STANDARDS.md`** - How-to guide standards
- **`.ai/docs/MANIFEST_VALIDATION.md`** - Plugin manifest schema

---

## Quick Decision Tree

```
START
  |
  +- User mentions external repository path?
  |  |
  |  YES -> Type 1: Repository Assistant Mode
  |  |      +- Read ai-projen's 3 core docs (ai-context, ai-rules, index)
  |  |      +- Classify intent (create/upgrade/add)
  |  |      +- Confirm understanding with user
  |  |      +- Route to appropriate how-to guide
  |  |      +- Execute workflow in USER'S repository
  |  |      +- Validate and report
  |  |
  |  NO -> Type 2: Framework Developer Mode
  |         +- Read 3 core docs (ai-context, ai-rules, index)
  |         +- Classify task type
  |         |  +- Plan feature? -> how-to-plan-a-feature.md
  |         |  +- Plan initiative? -> how-to-plan-an-initiative.md
  |         |  +- Continue work? -> how-to-continue-feature-work.md
  |         |  +- Plugin work? -> PLUGIN_GIT_WORKFLOW_STANDARD.md
  |         |  +- Documentation? -> FILE_HEADER_STANDARDS.md
  |         +- Create feature branch
  |         +- Make changes following standards
  |         +- Validate and commit
```

---

## Failure Handling

### If Prerequisites Not Met
1. **STOP** - Do not proceed
2. **INFORM** user what is missing
3. **PROVIDE** clear instructions to resolve
4. **WAIT** for user confirmation

### If Workflow Step Fails
1. **IDENTIFY** which step failed
2. **CHECK** what happened vs expected
3. **REPORT** specific error to user
4. **SUGGEST** remediation steps

### If Ambiguous Intent
1. **DO NOT GUESS**
2. **ASK** user for clarification with specific options
3. **WAIT** for explicit user choice

---

## Success Criteria

### Repository Assistant Mode
- [ ] Correct how-to guide selected and followed
- [ ] All changes on feature branch (not main)
- [ ] Plugin installation successful
- [ ] Validation checks pass
- [ ] User informed of next steps

### Framework Developer Mode
- [ ] Feature branch created before changes
- [ ] All standards followed (headers, YAML, docs)
- [ ] Relevant documentation updated
- [ ] YAML files validate
- [ ] Changes committed with conventional message
- [ ] PROGRESS_TRACKER.md updated (if working on roadmap)

---

**Core Principle**: This repository teaches AI-ready patterns. It must exemplify those patterns. Be deterministic, explicit, and defensive. When in doubt, ask the user.
