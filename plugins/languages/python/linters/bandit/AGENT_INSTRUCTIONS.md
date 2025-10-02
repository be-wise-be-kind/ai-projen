# Bandit Security Scanner - Agent Instructions

**Purpose**: Install and configure Bandit for Python security vulnerability scanning

**Scope**: Security scanning setup for Python projects

**Overview**: Bandit is a security linter for Python that scans code for common security
    issues, helping identify vulnerabilities before they reach production.

**Dependencies**: Python 3.11+, pip or poetry

---

## Installation Steps

### Step 1: Install Bandit

Add Bandit to your Python development dependencies:

**Using pip**:
```bash
pip install bandit
```

**Using poetry** (recommended):
```bash
poetry add --group dev bandit
```

**Using requirements-dev.txt**:
```
bandit>=1.7.5
```

### Step 2: Copy Configuration

Copy the Bandit configuration to your project root:

```bash
cp plugins/languages/python/linters/bandit/config/.bandit ./.bandit
```

**Alternative**: You can also configure Bandit in `pyproject.toml`:

```toml
[tool.bandit]
exclude_dirs = ["/tests/", "/test/", "/.venv/", "/venv/"]
skips = ["B101"]  # Skip assert_used
```

### Step 3: Verify Installation

Test that Bandit is working:

```bash
# Check version
bandit --version

# Run security scan
bandit -r .

# Run with config file
bandit -r . -c .bandit

# Run quietly (only show issues)
bandit -r . -q
```

## What Bandit Checks For

Bandit scans for common security vulnerabilities:

1. **Hardcoded Credentials**
   - Hardcoded passwords, API keys, tokens
   - SQL connection strings with passwords

2. **Injection Vulnerabilities**
   - SQL injection risks
   - Command injection via subprocess
   - Code injection via eval/exec

3. **Unsafe Deserialization**
   - pickle, yaml.load, marshal
   - XML external entity attacks

4. **Cryptographic Issues**
   - Weak cryptographic algorithms (MD5, SHA1)
   - Insecure random number generation
   - Missing SSL/TLS certificate verification

5. **File Operations**
   - Unsafe file permissions
   - Path traversal vulnerabilities
   - Temporary file creation issues

6. **Configuration Issues**
   - Debug mode enabled in production
   - Unsafe Flask/Django settings

## Configuration Details

The provided configuration:
- **Excludes**: Test directories, virtual environments, cache directories
- **Skips**: B101 (assert statements - safe in tests and internal code)
- **Severity level**: LOW (catches all issues)
- **Confidence level**: MEDIUM (reduces false positives)

## Usage Examples

```bash
# Scan all Python files recursively
bandit -r .

# Scan specific directory
bandit -r src/

# Show only high severity issues
bandit -r . -ll

# Show only high confidence issues
bandit -r . -iii

# Output to file
bandit -r . -o bandit-report.txt

# JSON output for CI/CD
bandit -r . -f json -o bandit-report.json

# Quiet mode (only show issues)
bandit -r . -q
```

## Integration with Make

Add to your Makefile:

```makefile
.PHONY: security-scan

security-scan:
	bandit -r . -c .bandit -q
```

## Understanding Bandit Output

Bandit reports include:
- **Issue ID**: B### (e.g., B201 for flask_debug_true)
- **Severity**: LOW, MEDIUM, HIGH
- **Confidence**: LOW, MEDIUM, HIGH
- **Location**: File path and line number
- **Description**: What the issue is
- **Recommendation**: How to fix it

Example output:
```
>> Issue: [B201:flask_debug_true] Flask app appears to be run with debug=True
   Severity: High   Confidence: Medium
   Location: app.py:10
   More Info: https://bandit.readthedocs.io/en/latest/plugins/b201_flask_debug_true.html
9       app = Flask(__name__)
10      app.run(debug=True)  # <-- Issue here
11
```

## Common Security Issues and Fixes

### 1. Hardcoded Passwords (B105, B106)
**Bad**:
```python
password = "MySecretPassword123"
```

**Good**:
```python
import os
password = os.environ.get("DB_PASSWORD")
```

### 2. SQL Injection (B608)
**Bad**:
```python
query = f"SELECT * FROM users WHERE id = {user_id}"
```

**Good**:
```python
query = "SELECT * FROM users WHERE id = ?"
cursor.execute(query, (user_id,))
```

### 3. Command Injection (B602, B603)
**Bad**:
```python
os.system(f"rm {filename}")
```

**Good**:
```python
import subprocess
subprocess.run(["rm", filename], check=True)
```

### 4. Weak Cryptography (B303, B304)
**Bad**:
```python
import md5
hash = md5.new(data).digest()
```

**Good**:
```python
import hashlib
hash = hashlib.sha256(data).digest()
```

## Suppressing False Positives

For legitimate cases, you can suppress Bandit warnings:

```python
# Suppress specific issue on one line
value = eval(expression)  # nosec B307

# Suppress all issues on one line
dangerous_function()  # nosec

# Suppress for entire function/class
# nosec: B201, B301
def legacy_function():
    ...
```

**Warning**: Only suppress warnings when you're certain the code is safe!

## Integration with CI/CD

Bandit can fail CI builds if security issues are found:

```yaml
# In GitHub Actions workflow
- name: Security scan with Bandit
  run: |
    bandit -r . -c .bandit -ll -iii --exit-zero
    # Use --exit-zero to not fail the build, or remove it to fail on issues
```

## Success Criteria

Bandit is successfully installed when:
- ✅ `bandit --version` works
- ✅ `.bandit` configuration file exists
- ✅ `bandit -r .` runs and scans code
- ✅ No HIGH severity issues in production code
- ✅ Make target works (if Makefile integration completed)

## Best Practices

1. **Run in CI/CD**: Catch security issues before merge
2. **Review all findings**: Don't blindly suppress warnings
3. **Use environment variables**: Never hardcode secrets
4. **Parameterize queries**: Prevent SQL injection
5. **Validate inputs**: Check user input before processing
6. **Keep dependencies updated**: Security fixes in libraries
7. **Regular scans**: Run Bandit frequently during development
