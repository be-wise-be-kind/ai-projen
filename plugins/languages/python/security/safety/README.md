# Safety Plugin

CVE database scanning for Python dependencies - identifies known security vulnerabilities.

## What This Does

Scans dependencies for:
- Known CVEs (Common Vulnerabilities and Exposures)
- Security advisories
- Severity ratings (Low/Medium/High/Critical)
- Remediation recommendations

## Usage

```bash
# Scan dependencies
safety check

# JSON output
safety check --json

# Via Makefile
make security-full  # Runs Bandit + Safety + pip-audit
```

## Output

```
| package  | installed | affected   | ID    | severity |
|----------|-----------|------------|-------|----------|
| requests | 2.25.1    | <2.26.0    | 42853 | high     |
```

## Remediation

```bash
# Update vulnerable package
poetry update requests

# Or pip
pip install --upgrade requests
```

## Integration

- ✅ CI/CD: Weekly scans
- ✅ Makefile: `make security-full`
- ✅ Combined with pip-audit for coverage
