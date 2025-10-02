# pip-audit Dependency Auditor - Agent Instructions

**Purpose**: Install and configure pip-audit for comprehensive dependency vulnerability auditing

**Scope**: PyPI vulnerability database scanning, OSV database integration

**Overview**: pip-audit audits Python dependencies using multiple vulnerability databases including
    the Python Packaging Advisory Database and OSV (Open Source Vulnerabilities).

**Dependencies**: Python 3.11+

---

## What is pip-audit?

pip-audit is Python's official dependency auditor:
- Maintained by PyPA (Python Packaging Authority)
- Uses PyPI Advisory Database + OSV
- More comprehensive than Safety (free tier)
- Scans installed packages and requirements files
- Cross-references multiple vulnerability sources

## Installation

Using pip:
```bash
pip install pip-audit
```

Using poetry:
```bash
poetry add --group dev pip-audit
```

## Usage

### Audit Dependencies

```bash
# Audit installed packages
pip-audit

# Audit requirements file
pip-audit -r requirements.txt

# Audit with detailed output
pip-audit --desc

# JSON output
pip-audit --format json
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
security-pip-audit: ## Audit dependencies with pip-audit
	pip-audit
```

## CI/CD Integration

```yaml
- name: Audit Dependencies
  run: |
    pip install pip-audit
    pip-audit --desc
```

## Output Example

```
Found 2 known vulnerabilities in 1 package
Name    Version ID             Fix Versions
------- ------- -------------- ------------
requests 2.25.1 PYSEC-2021-59  2.26.0
                GHSA-j8r2-6x86-q33q 2.26.0
```

## Handling Vulnerabilities

### Review and Fix
```bash
# Show details
pip-audit --desc

# Update package
poetry update requests

# Re-audit
pip-audit
```

### Ignore Known Issues
```bash
# Ignore specific vulnerability
pip-audit --ignore-vuln PYSEC-2021-59
```

### Generate Fix Requirements
```bash
# Show what needs updating
pip-audit --fix --dry-run
```

## Comparison: Safety vs pip-audit

| Feature | Safety | pip-audit |
|---------|--------|-----------|
| **Maintainer** | pyup.io | PyPA (official) |
| **Database** | Commercial CVE DB | PyPI Advisory + OSV |
| **Free tier** | Limited updates | Full access |
| **Coverage** | Good | Comprehensive |
| **Speed** | Fast | Fast |
| **Recommendation** | Use both | Primary tool |

## Best Practices

1. **Use pip-audit as primary**: Official, comprehensive, free
2. **Run Safety as secondary**: Cross-reference findings
3. **Automated scanning**: Weekly in CI/CD
4. **Fix promptly**: Security updates are high priority
5. **Document ignores**: Track false positives

## Docker Integration

Already in Python linting container:
```dockerfile
RUN pip install --no-cache-dir \
    safety \
    pip-audit
```

## Success Criteria

- ✅ `pip-audit --version` works
- ✅ `pip-audit` scans dependencies
- ✅ `make security-full` includes pip-audit
- ✅ CI/CD runs pip-audit
- ✅ Vulnerabilities tracked and remediated
