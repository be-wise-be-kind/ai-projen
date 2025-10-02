# PR7.7 Correction - Template Placement

**Purpose**: Document the correction made to PR7.7 template file placement

**Scope**: Template file organization and agent instruction clarity

**Overview**: During PR7.7 implementation, a template file was incorrectly placed in `.ai/docs/`
    instead of `plugins/_template/howtos/`. This document explains the issue, root cause,
    correction made, and lessons learned for future agent instructions.

**Date**: 2025-10-01

---

## Issue Identified

**File**: `.ai/docs/HOW_TO_TEMPLATE.md`

**Problem**: Template file placed in documentation directory instead of template directory.

**Correct Location**: `.ai/templates/HOW_TO_TEMPLATE.md` (project-level template)

**Additional Correct Locations**: `plugins/*/_ template/howtos/HOWTO_TEMPLATE.md` (plugin-specific variants)

---

## Root Cause Analysis

### Agent Instructions Given

The framework agent was instructed to create:

```markdown
### File 1: `.ai/docs/HOW_TO_TEMPLATE.md`
Create a comprehensive template that all how-tos should follow.

### File 4: `plugins/_template/howtos/HOWTO_TEMPLATE.md`
Create the actual template file (copy from `.ai/docs/HOW_TO_TEMPLATE.md`
with plugin-specific placeholders)
```

### Agent Interpretation

The agent interpreted these as two different purposes:
- `.ai/docs/HOW_TO_TEMPLATE.md` = **Master reference/documentation** about the template
- `plugins/_template/howtos/HOWTO_TEMPLATE.md` = **Actual copyable template** with placeholders

### Why This Happened

The instruction used "HOW_TO_TEMPLATE.md" as a filename in `.ai/docs/`, which:
1. **Confused purpose**: Templates don't belong in documentation directories
2. **Created ambiguity**: Two files with similar names but different purposes
3. **Violated separation of concerns**: `.ai/docs/` is for standards/documentation, not templates

---

## Correct Organization

### .ai/docs/ Should Contain:

✅ **Standards and Documentation**:
- `HOWTO_STANDARDS.md` - Standards for writing how-tos
- `HOWTO_INTEGRATION.md` - How to integrate how-tos with manifests
- `PLUGIN_ARCHITECTURE.md` - Plugin system documentation
- `FILE_HEADER_STANDARDS.md` - File header requirements
- etc.

❌ **NOT Templates**:
- ~~`HOW_TO_TEMPLATE.md`~~ - This is a template, not documentation

### plugins/_template/howtos/ Should Contain:

✅ **Templates** (copyable files with placeholders):
- `HOWTO_TEMPLATE.md` - Template for creating how-tos
- Example how-to files

✅ **Index files**:
- `README.md` - Index of available how-tos

---

## Correction Made

### Files Removed:
- `/home/stevejackson/Projects/ai-projen/.ai/docs/HOW_TO_TEMPLATE.md` (was in wrong location)

### Files Created:
- `/home/stevejackson/Projects/ai-projen/.ai/templates/HOW_TO_TEMPLATE.md` (correct location) ✅

### Files Updated:
- `/home/stevejackson/Projects/ai-projen/.ai/index.yaml` - Updated to reference correct location
- `/home/stevejackson/Projects/ai-projen/.ai/docs/PR7.7_CORRECTION.md` - This document

### Files That Already Exist Correctly:
- `plugins/languages/_template/howtos/HOWTO_TEMPLATE.md` ✅ (plugin-specific variant)
- `plugins/infrastructure/ci-cd/_template/howtos/HOWTO_TEMPLATE.md` ✅ (plugin-specific)
- `plugins/infrastructure/iac/_template/howtos/HOWTO_TEMPLATE.md` ✅ (plugin-specific)
- `plugins/infrastructure/containerization/_template/howtos/HOWTO_TEMPLATE.md` ✅ (plugin-specific)
- `plugins/standards/_template/howtos/HOWTO_TEMPLATE.md` ✅ (plugin-specific)

---

## Lessons Learned for Future Agent Instructions

### ❌ Don't Say:

```markdown
Create `.ai/docs/HOW_TO_TEMPLATE.md` - Comprehensive template
```

This implies creating a template in the docs directory.

### ✅ Do Say:

```markdown
1. Update `.ai/docs/HOWTO_STANDARDS.md` to document the template structure
   - Include required sections
   - Show example structure
   - Reference actual templates in plugins/_template/

2. Create `plugins/_template/howtos/HOWTO_TEMPLATE.md` - Copyable template
   - Include {{PLACEHOLDERS}}
   - Complete structure ready to copy and customize
```

### Key Principles:

1. **Separation of Concerns**:
   - `.ai/docs/` = **Documentation and Standards**
   - `plugins/_template/` = **Copyable Templates**

2. **Clear Purpose in File Names**:
   - `*_STANDARDS.md` = Standards/documentation
   - `*_TEMPLATE.md` = Copyable template (only in template directories)

3. **Explicit Instructions**:
   - State WHERE and WHY for each file
   - Explain the PURPOSE clearly
   - Show RELATIONSHIP between files

4. **Reference, Don't Duplicate**:
   - Documentation can REFERENCE templates
   - Templates can REFERENCE standards
   - Don't create similar files in different locations

---

## Correct File Organization

```
.ai/
├── docs/
│   ├── HOWTO_STANDARDS.md          # Documents how to write how-tos
│   ├── HOWTO_INTEGRATION.md        # Documents integration patterns
│   └── [other standards].md        # Other documentation
│
├── templates/
│   ├── HOW_TO_TEMPLATE.md          # ✅ Project-level template for creating how-tos
│   ├── fastapi-endpoint.py.template  # (future) Code templates
│   └── react-component.tsx.template # (future) Code templates

plugins/
├── languages/
│   └── _template/
│       └── howtos/
│           ├── HOWTO_TEMPLATE.md   # Copyable template
│           └── README.md            # Index/instructions
│
├── infrastructure/
│   ├── ci-cd/_template/howtos/
│   │   └── HOWTO_TEMPLATE.md       # Copyable template
│   ├── iac/_template/howtos/
│   │   └── HOWTO_TEMPLATE.md       # Copyable template
│   └── containerization/_template/howtos/
│       └── HOWTO_TEMPLATE.md       # Copyable template
│
└── standards/
    └── _template/howtos/
        └── HOWTO_TEMPLATE.md       # Copyable template
```

---

## Impact Assessment

### What Broke:
- ❌ `.ai/index.yaml` referenced non-existent file (now fixed)
- ❌ Some documentation references invalid path (need manual review)

### What Didn't Break:
- ✅ All actual plugin templates exist correctly
- ✅ Python and TypeScript plugins created how-tos properly
- ✅ HOWTO_STANDARDS.md correctly documents structure

### What Was Redundant:
- The deleted file duplicated information already in HOWTO_STANDARDS.md
- Plugin-specific templates already existed with proper placeholders

---

## Action Items

### Completed:
- ✅ Removed `.ai/docs/HOW_TO_TEMPLATE.md`
- ✅ Updated `.ai/index.yaml` to remove reference
- ✅ Created this correction document

### Manual Review Needed:
- ⚠️ Check `HOWTO_INTEGRATION.md` for any references to deleted file
- ⚠️ Check `PR7.7_HOWTO_FRAMEWORK_SUMMARY.md` for references
- ⚠️ Update references to point to `plugins/_template/howtos/HOWTO_TEMPLATE.md`

### For Future PRs:
- ✅ Be explicit about `.ai/docs/` vs `plugins/_template/` distinction
- ✅ Use clear naming: `*_STANDARDS.md` for docs, `*_TEMPLATE.*` for templates only in template dirs
- ✅ Emphasize separation of concerns in agent instructions

---

## Conclusion

The correction maintains proper separation between:
- **Documentation** (`.ai/docs/`) - Standards, guides, architecture docs
- **Templates** (`plugins/_template/`) - Copyable files with placeholders

This aligns with ai-projen's architecture principle that templates belong in plugin template directories,
while documentation belongs in `.ai/docs/`.

The actual how-to framework (PR7.7) is still complete and functional - this was just a misplaced file
that duplicated information already properly documented elsewhere.
