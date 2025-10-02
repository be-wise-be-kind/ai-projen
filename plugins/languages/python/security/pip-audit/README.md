# pip-audit Plugin

Official Python dependency auditor - comprehensive vulnerability scanning using PyPI Advisory Database + OSV.

## What This Does

pip-audit audits Python dependencies for:
- PyPI Advisory Database vulnerabilities
- OSV (Open Source Vulnerabilities) data
- CVE cross-references
- Fix version recommendations

## Why pip-audit?

**Official PyPA tool**:
- Maintained by Python Packaging Authority
- Free, comprehensive database access
- Multiple vulnerability sources
- Primary recommendation for dependency auditing

**Use alongside Safety for maximum coverage**

## Usage

```bash
# Audit dependencies
pip-audit

# Detailed output
pip-audit --desc

# Via Makefile
make security-full  # Runs Bandit + Safety + pip-audit
```

## Output

```
Found 2 known vulnerabilities in 1 package
Name    Version ID             Fix Versions
------- ------- -------------- ------------
requests 2.25.1 PYSEC-2021-59  2.26.0
                GHSA-j8r2-6x86-q33q 2.26.0
```

## Remediation

```bash
# Show what needs fixing
pip-audit --fix --dry-run

# Update packages
poetry update requests
```

## Integration

- ✅ CI/CD: Weekly automated scans
- ✅ Makefile: `make security-full`
- ✅ Primary tool (Safety as secondary)
- ✅ Docker-first execution

## Comparison

| Tool | Database | Free Access | Official |
|------|----------|-------------|----------|
| **pip-audit** | PyPI + OSV | ✅ Full | ✅ PyPA |
| **Safety** | Commercial | Limited | ❌ Third-party |

**Best practice**: Run both, prioritize pip-audit findings.
