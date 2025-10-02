# How-To: {{TASK_NAME}}

**Purpose**: {{ONE_SENTENCE_DESCRIPTION}}

**Scope**: {{WHAT_IS_COVERED}} and {{WHAT_IS_NOT_COVERED}}

**Overview**: {{2_3_SENTENCES_PROVIDING_CONTEXT}}
    {{EXPLAIN_WHY_NEEDED_AND_WHAT_READER_WILL_LEARN}}

**Dependencies**: {{LANGUAGE_NAME}} plugin, {{REQUIRED_TOOLS}}, {{REQUIRED_SETUP}}

**Exports**: {{WHAT_WILL_BE_CREATED}}

**Related**: {{RELATED_HOWTOS_AND_DOCS}}

**Implementation**: {{BRIEF_TECHNICAL_SUMMARY}}

**Difficulty**: beginner | intermediate | advanced

**Estimated Time**: 5min | 15min | 30min | 1hr

---

## Prerequisites

Before starting, ensure you have:

- **{{LANGUAGE_NAME}} plugin installed**: Follow [../AGENT_INSTRUCTIONS.md](../AGENT_INSTRUCTIONS.md)
- **{{REQUIRED_TOOL_1}}**: Version {{VERSION}} or higher
- **{{REQUIRED_TOOL_2}}**: {{INSTALLATION_REFERENCE}}
- **{{REQUIRED_KNOWLEDGE}}**: Understanding of {{CONCEPT}}
- **{{REQUIRED_FILE_STATE}}**: {{FILE_OR_DIRECTORY}} must exist

## Overview

{{PROVIDE_2_4_PARAGRAPHS_OF_CONTEXT}}

{{WHAT_PROBLEM_DOES_THIS_SOLVE}}

{{WHEN_WOULD_AN_AI_AGENT_USE_THIS_GUIDE}}

{{WHAT_ARE_THE_KEY_CONCEPTS_INVOLVED}}

{{HOW_DOES_THIS_FIT_INTO_LARGER_ARCHITECTURE}}

## Steps

### Step 1: {{ACTION_TITLE_1}}

{{BRIEF_EXPLANATION_OF_WHAT_THIS_STEP_ACCOMPLISHES_AND_WHY}}

```bash
# {{EXPLAIN_WHAT_THIS_COMMAND_DOES}}
{{COMMAND_WITH_OPTIONS}}
```

**Expected Result**: {{WHAT_SHOULD_HAPPEN_AFTER_THIS_STEP}}

**Template Reference** (if applicable):
```bash
# Copy the template
cp plugins/languages/{{LANGUAGE_NAME}}/templates/{{TEMPLATE_FILE}}.template {{DESTINATION_PATH}}

# Or if plugin is installed in a project:
cp .ai/plugins/{{LANGUAGE_NAME}}/templates/{{TEMPLATE_FILE}}.template {{DESTINATION_PATH}}
```

**Customize the template**:
- Replace `{{PLACEHOLDER_1}}` with {{DESCRIPTION}}
- Replace `{{PLACEHOLDER_2}}` with {{DESCRIPTION}}
- Adjust {{SECTION}} for your use case

**Code Example**:
```{{LANGUAGE}}
{{COMPLETE_RUNNABLE_CODE_EXAMPLE}}
{{INCLUDE_ALL_IMPORTS}}
{{SHOW_ACTUAL_VALUES_NOT_PLACEHOLDERS}}
```

**Common Issues for This Step**:
- **Issue**: {{PROBLEM_DESCRIPTION}}
  - **Solution**: {{HOW_TO_FIX}}

### Step 2: {{ACTION_TITLE_2}}

{{EXPLANATION_OF_STEP_2}}

Create the file at `{{FILE_PATH}}`:

```{{LANGUAGE}}
{{COMPLETE_CODE_FOR_THIS_STEP}}
```

**Why this matters**: {{EXPLAIN_IMPORTANCE_OF_THIS_STEP}}

**Expected Result**: {{VERIFICATION_FOR_THIS_STEP}}

### Step 3: {{INTEGRATION_OR_REGISTRATION_STEP}}

{{IF_TASK_REQUIRES_INTEGRATION_WITH_EXISTING_SYSTEMS}}

Edit `{{FILE_PATH}}` and add:

```{{LANGUAGE}}
{{CODE_SHOWING_WHERE_AND_HOW_TO_INTEGRATE}}
{{SHOW_SURROUNDING_CONTEXT}}
```

**What this does**: {{EXPLAIN_THE_INTEGRATION}}

**Verify integration**:
```bash
{{COMMAND_TO_CHECK_INTEGRATION}}
```

## Verification

Confirm the implementation works correctly.

### 1. Manual Testing

```bash
# {{DESCRIBE_WHAT_THIS_TESTS}}
{{COMMAND_TO_TEST_FUNCTIONALITY}}
```

**Expected output**:
```
{{SHOW_EXACT_EXPECTED_OUTPUT}}
```

### 2. Automated Testing

```bash
# Run the relevant tests
{{TEST_COMMAND}}
```

**Expected result**:
```
{{SHOW_TEST_PASSING_OUTPUT}}
```

### 3. Additional Verification

- **{{VERIFICATION_METHOD_1}}**: {{HOW_TO_CHECK}}
- **{{VERIFICATION_METHOD_2}}**: {{WHAT_TO_LOOK_FOR}}
- **{{VERIFICATION_METHOD_3}}**: {{EXPECTED_BEHAVIOR}}

## Common Issues and Solutions

### Issue 1: {{COMMON_PROBLEM_DESCRIPTION}}

**Symptoms**: {{WHAT_AGENT_WILL_OBSERVE}}

**Cause**: {{WHY_THIS_HAPPENS}}

**Solution**:
```bash
# {{STEP_TO_RESOLVE}}
{{COMMAND_TO_FIX}}
```

**Verification**:
```bash
{{COMMAND_TO_VERIFY_FIX}}
```

### Issue 2: {{ANOTHER_COMMON_PROBLEM}}

**Symptoms**: {{OBSERVABLE_SYMPTOMS}}

**Cause**: {{ROOT_CAUSE}}

**Solution**:
{{STEP_BY_STEP_FIX}}

1. {{STEP_1}}
2. {{STEP_2}}
3. {{STEP_3}}

### Issue 3: {{CONFIGURATION_OR_SETUP_ISSUE}}

**Symptoms**: {{ERROR_MESSAGE_OR_BEHAVIOR}}

**Cause**: {{EXPLANATION}}

**Solution**:
Edit `{{CONFIG_FILE}}`:
```{{CONFIG_FORMAT}}
{{CORRECTED_CONFIGURATION}}
```

## Best Practices

- **{{PRACTICE_1}}**: {{EXPLANATION_AND_EXAMPLE}}
- **{{PRACTICE_2}}**: {{WHY_THIS_MATTERS}}
- **{{PRACTICE_3}}**: {{WHEN_TO_APPLY_THIS}}

## Next Steps

After completing this guide, consider:

- **[{{RELATED_HOWTO_1}}]({{PATH_TO_HOWTO}})** - {{BRIEF_DESCRIPTION}}
- **[{{RELATED_HOWTO_2}}]({{PATH_TO_HOWTO}})** - {{WHEN_TO_USE}}
- **[{{DOCUMENTATION_REFERENCE}}]({{PATH_TO_DOC}})** - {{WHAT_IT_COVERS}}

## Checklist

Track your progress through this guide:

- [ ] Prerequisites verified and in place
- [ ] Step 1: {{SUMMARY_OF_STEP_1}}
- [ ] Step 2: {{SUMMARY_OF_STEP_2}}
- [ ] Step 3: {{SUMMARY_OF_STEP_3}}
- [ ] Manual verification completed successfully
- [ ] Automated tests passing
- [ ] Common issues addressed if encountered
- [ ] Code follows plugin standards
- [ ] Related files updated (tests, configs, etc.)

## Related Resources

- **Plugin Documentation**: [../README.md](../README.md)
- **Agent Instructions**: [../AGENT_INSTRUCTIONS.md](../AGENT_INSTRUCTIONS.md)
- **Plugin Standards**: [../standards/](../standards/)
- **Templates Directory**: [../templates/](../templates/)
- **Related How-Tos**:
  - [{{RELATED_GUIDE_1}}]({{PATH}})
  - [{{RELATED_GUIDE_2}}]({{PATH}})
- **External Documentation**:
  - [{{OFFICIAL_DOCS_1}}]({{URL}}) - {{DESCRIPTION}}
  - [{{OFFICIAL_DOCS_2}}]({{URL}}) - {{DESCRIPTION}}

---

## Template Customization Guide

When creating a new how-to from this template:

### 1. Replace All Placeholders

Replace all `{{PLACEHOLDER}}` markers with actual content:

- **{{TASK_NAME}}**: Specific task name (e.g., "Create an API Endpoint")
- **{{LANGUAGE_NAME}}**: Your language (e.g., "Python", "TypeScript")
- **{{LANGUAGE}}**: Language identifier for code blocks (e.g., "python", "typescript")
- **{{TEMPLATE_FILE}}**: Actual template filename
- **All other placeholders**: Replace with specific, concrete information

### 2. Remove Unused Sections

Delete sections that don't apply to your how-to:
- Optional subsections in Steps
- Verification methods not relevant
- Common issues that don't apply
- Best practices if none specific

### 3. Add Specialized Sections

Add sections if your how-to needs them:
- Security considerations
- Performance considerations
- Architecture decisions
- Migration paths

### 4. Complete Code Examples Only

- Replace all code blocks with COMPLETE, RUNNABLE examples
- Include ALL necessary imports
- Show ACTUAL values, not placeholders
- Provide file path context

### 5. Test Everything

Before finalizing:
1. Follow your guide from scratch
2. Verify all commands execute successfully
3. Test all code examples
4. Confirm verification steps work
5. Validate estimated time

### 6. Template Reference Pattern

If your how-to uses templates, always show:
```bash
# Copy from plugin location
cp plugins/languages/{{LANGUAGE_NAME}}/templates/{{TEMPLATE}}.template destination

# Copy from installed plugin
cp .ai/plugins/{{LANGUAGE_NAME}}/templates/{{TEMPLATE}}.template destination
```

Then document:
- All template placeholders
- What to replace them with
- Example before/after

### 7. Difficulty Assignment

Choose honestly:
- **Beginner**: Single focus, minimal prerequisites, 3-5 steps, 5-15min
- **Intermediate**: Framework knowledge needed, 5-10 steps, 15-45min
- **Advanced**: Deep knowledge required, 10+ steps, 45+min

### 8. Verification is Mandatory

Always include:
- Commands to test functionality
- Expected outputs (exact)
- Success criteria
- Failure indicators

### 9. Common Issues Discovery

Add issues as you discover them:
- During self-testing
- From user reports
- From clean environment testing
- From edge cases

### 10. Cross-References

Link to:
- Related how-tos in this plugin
- How-tos in other plugins
- Plugin documentation
- External official docs
- Project standards

---

**Template Version**: 1.0
**Last Updated**: 2025-10-01
**Maintained By**: ai-projen framework
