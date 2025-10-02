# Safety Dependency Scanner - Agent Instructions

**Purpose**: Install and configure Safety for dependency vulnerability scanning

**Scope**: CVE database scanning, known vulnerability detection in dependencies

**Overview**: Safety checks Python dependencies against the CVE (Common Vulnerabilities and Exposures)
    database to identify known security vulnerabilities.

**Dependencies**: Python 3.11+

---

## What is Safety?

Safety scans `requirements.txt` or `pyproject.toml` for:
- Known security vulnerabilities (CVEs)
- Outdated packages with security fixes
- Severity ratings (Low/Medium/High/Critical)
- Remediation advice

**Database**: Safety uses a curated CVE database updated regularly.

## Installation

Using pip:
```bash
pip install safety
```

Using poetry:
```bash
poetry add --group dev safety
```

## Usage

### Scan Dependencies

```bash
# Scan current environment
safety check

# Scan requirements file
safety check -r requirements.txt

# Scan poetry lock file
safety check --json | python -m json.tool
```

### Makefile Integration

Already in `makefile-python.mk`:
```makefile
security-full: ## Run all security tools (Bandit + Safety + pip-audit)
	bandit -r src/
	safety check
	pip-audit
```

Or individually:
```makefile
security-safety: ## Scan dependencies with Safety
	safety check
```

## CI/CD Integration

```yaml
- name: Security Scan Dependencies
  run: |
    pip install safety
    safety check --json  # JSON output for parsing
```

## Output Example

```
+==============================================================================+
|                                                                              |
|                               /$$$$$$            /$$                         |
|                              /$$__  $$          | $$                         |
|           /$$$$$$$  /$$$$$$ | $$  \__//$$$$$$  /$$$$$$   /$$   /$$           |
|          /$$_____/ |____  $$| $$$$   /$$__  $$|_  $$_/  | $$  | $$           |
|         |  $$$$$$   /$$$$$$$| $$_/  | $$$$$$$$  | $$    | $$  | $$           |
|          \____  $$ /$$__  $$| $$    | $$_____/  | $$ /$$| $$  | $$           |
|          /$$$$$$$/|  $$$$$$$| $$    |  $$$$$$$  |  $$$$/|  $$$$$$$           |
|         |_______/  \_______/|__/     \_______/   \___/   \____  $$           |
|                                                           /$$  | $$           |
|                                                          |  $$$$$$/           |
|  by pyup.io                                              \______/            |
|                                                                              |
+==============================================================================+
| REPORT                                                                       |
+==============================================================================+
| checked 45 packages, using free database (updated once a month)             |
+==============================================================================+
| package  | installed | affected   | ID        | severity |
+==============================================================================+
| requests | 2.25.1    | <2.26.0    | 42853     | high     |
+==============================================================================+
```

## Handling Vulnerabilities

### Review and Update
```bash
# Update vulnerable package
poetry update requests

# Or with pip
pip install --upgrade requests
```

### Ignore False Positives
```bash
# Ignore specific vulnerability
safety check --ignore 42853
```

## Best Practices

1. **Run regularly**: Weekly in CI/CD minimum
2. **Monitor severity**: Prioritize High/Critical
3. **Update promptly**: Security fixes should be fast-tracked
4. **Combine with pip-audit**: Cross-reference findings
5. **Track false positives**: Document ignored CVEs

## Success Criteria

- ✅ `safety --version` works
- ✅ `safety check` scans dependencies
- ✅ `make security-full` includes Safety
- ✅ CI/CD runs Safety scans
- ✅ Vulnerabilities are tracked and remediated
