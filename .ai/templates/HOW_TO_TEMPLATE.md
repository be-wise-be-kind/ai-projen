# How-To: {{TASK_NAME}}

**Purpose**: {{ONE_SENTENCE_DESCRIPTION_OF_WHAT_THIS_ACCOMPLISHES}}

**Scope**: {{WHAT_THIS_COVERS}} and {{WHAT_THIS_DOES_NOT_COVER}}

**Overview**: {{2_3_SENTENCES_EXPLAINING_THE_TASK_WHY_NEEDED_WHAT_READER_WILL_LEARN}}

**Dependencies**: {{REQUIRED_PLUGINS}}, {{REQUIRED_TOOLS}}, {{REQUIRED_SETUP}}

**Exports**: {{WHAT_READER_WILL_HAVE_AFTER_COMPLETING}}

**Related**: {{LINKS_TO_RELATED_HOWTOS_DOCS_STANDARDS}}

**Implementation**: {{BRIEF_TECHNICAL_SUMMARY_OF_APPROACH}}

**Difficulty**: beginner | intermediate | advanced

**Estimated Time**: 5min | 15min | 30min | 1hr | 2hr

---

## Prerequisites

Before starting, ensure you have:

- **{{PREREQUISITE_1}}**: {{DESCRIPTION_OR_VERSION_REQUIREMENT}}
- **{{PREREQUISITE_2}}**: {{INSTALLATION_OR_SETUP_REFERENCE}}
- **{{PREREQUISITE_3}}**: Understanding of {{REQUIRED_CONCEPT}}
- **{{REQUIRED_STATE}}**: {{FILE_DIRECTORY_OR_CONFIG}} must exist

## Overview

{{PROVIDE_CONTEXT_IN_2_4_PARAGRAPHS}}

{{WHAT_PROBLEM_DOES_THIS_SOLVE}}

{{WHEN_WOULD_SOMEONE_USE_THIS_GUIDE}}

{{WHAT_ARE_THE_KEY_CONCEPTS}}

{{HOW_DOES_THIS_FIT_INTO_THE_LARGER_SYSTEM}}

## Steps

### Step 1: {{ACTION_VERB}} {{OBJECT}}

{{BRIEF_EXPLANATION_OF_WHAT_THIS_STEP_ACCOMPLISHES_AND_WHY}}

**Using Docker (Recommended)**:
```bash
# {{DESCRIPTION_OF_DOCKER_COMMAND}}
{{DOCKER_COMMAND}}
```

**Using {{FALLBACK_TOOL}}** (if Docker unavailable):
```bash
# {{DESCRIPTION_OF_FALLBACK_COMMAND}}
{{FALLBACK_COMMAND}}
```

**Code Example**:
```{{LANGUAGE}}
{{CODE_EXAMPLE}}
```

**Template Reference**:
If applicable, reference a template from `.ai/templates/` or `plugins/*/templates/`:
```bash
# Copy the template
cp .ai/templates/{{TEMPLATE_NAME}}.template {{DESTINATION}}

# Or from plugin:
cp plugins/{{PLUGIN_TYPE}}/{{PLUGIN_NAME}}/templates/{{TEMPLATE}} {{DESTINATION}}
```

**Why This Matters**: {{BRIEF_EXPLANATION}}

### Step 2: {{ACTION_VERB}} {{OBJECT}}

{{CONTINUE_PATTERN_FOR_EACH_STEP}}

{{INCLUDE_CODE_EXAMPLES_COMMANDS_TEMPLATE_REFERENCES}}

### Step N: {{FINAL_STEP}}

{{FINAL_VERIFICATION_OR_TESTING_STEP}}

## Verification

Verify your implementation works correctly:

**Check 1: {{VERIFICATION_NAME}}**
```bash
{{VERIFICATION_COMMAND}}
```

**Expected Output**:
```
{{EXPECTED_OUTPUT_EXAMPLE}}
```

**Check 2: {{ANOTHER_VERIFICATION}}**
```bash
{{VERIFICATION_COMMAND}}
```

**Success Criteria**:
- [ ] {{CRITERION_1}}
- [ ] {{CRITERION_2}}
- [ ] {{CRITERION_3}}

## Common Issues

### Issue: {{PROBLEM_DESCRIPTION}}

**Symptoms**: {{HOW_TO_RECOGNIZE_THIS_ISSUE}}

**Cause**: {{WHY_THIS_HAPPENS}}

**Solution**:
```bash
# {{SOLUTION_STEPS}}
{{FIX_COMMANDS}}
```

### Issue: {{ANOTHER_COMMON_PROBLEM}}

{{REPEAT_PATTERN}}

## Best Practices

- **{{PRACTICE_1}}**: {{EXPLANATION}}
- **{{PRACTICE_2}}**: {{EXPLANATION}}
- **{{PRACTICE_3}}**: {{EXPLANATION}}
- **{{SECURITY_CONSIDERATION}}**: {{IMPORTANT_SECURITY_NOTE}}

## Next Steps

After completing this how-to:

- **{{RELATED_TASK}}**: See [{{RELATED_HOWTO}}.md]({{PATH_TO_RELATED_HOWTO}})
- **{{ADVANCED_TOPIC}}**: See [{{ADVANCED_HOWTO}}.md]({{PATH}})
- **{{REFERENCE_DOC}}**: Read [{{DOC_NAME}}.md]({{PATH}}) for more details

## Checklist

Use this checklist to ensure completeness:

- [ ] {{COMPLETION_CRITERION_1}}
- [ ] {{COMPLETION_CRITERION_2}}
- [ ] {{COMPLETION_CRITERION_3}}
- [ ] {{VERIFICATION_PASSED}}
- [ ] {{DOCUMENTATION_UPDATED}}
- [ ] {{TESTS_ADDED_IF_APPLICABLE}}

## Related Documentation

- [{{STANDARD_NAME}}](../docs/{{STANDARD}}.md) - {{DESCRIPTION}}
- [{{PLUGIN_DOC}}](../plugins/{{PATH}}/README.md) - {{DESCRIPTION}}
- [{{TEMPLATE_USED}}](../templates/{{TEMPLATE}}.template) - {{DESCRIPTION}}
- [{{EXTERNAL_RESOURCE}}]({{URL}}) - {{DESCRIPTION}}

---

**Notes**:
- Replace all `{{PLACEHOLDERS}}` with actual content
- Delete placeholder instructions before saving
- Follow HOWTO_STANDARDS.md for detailed writing guidelines
- Test all commands and code examples before publishing
- Ensure all links work and references are correct
