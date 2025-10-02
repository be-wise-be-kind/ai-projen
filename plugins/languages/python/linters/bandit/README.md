# Bandit - Python Security Scanner

**What is Bandit?**

Bandit is a security linter for Python code. It scans your codebase for common security vulnerabilities and issues, helping you catch potential security problems before they reach production.

**Why Bandit?**

- **Proactive security**: Find vulnerabilities during development
- **Common issues**: Detects hardcoded passwords, SQL injection, weak crypto, and more
- **Easy integration**: Works with CI/CD pipelines
- **Low false positives**: Focused on real security issues
- **Well documented**: Clear explanations and fix recommendations

**What This Plugin Provides**

- Pre-configured Bandit settings for Python security scanning
- Sensible exclusions (test directories, virtual environments)
- MEDIUM confidence level to reduce false positives
- Ready-to-use .bandit configuration file

**Security Issues Detected**

- 🔐 Hardcoded credentials (passwords, API keys)
- 💉 Injection vulnerabilities (SQL, command, code)
- 🔓 Weak cryptography (MD5, SHA1, insecure random)
- 📦 Unsafe deserialization (pickle, yaml)
- 📁 Insecure file operations
- ⚙️ Dangerous configuration (debug mode, insecure SSL)

**Commands**

```bash
# Scan all files
bandit -r .

# Scan with config file
bandit -r . -c .bandit

# Show only high severity issues
bandit -r . -ll

# Quiet mode (only issues)
bandit -r . -q
```

**Example Output**

```
>> Issue: [B201:flask_debug_true] Flask app run with debug=True
   Severity: High   Confidence: Medium
   Location: app.py:10
```

**Configuration Location**

- `config/.bandit` - Bandit configuration file (copy to project root)

**Learn More**

- [Bandit Documentation](https://bandit.readthedocs.io/)
- [Bandit Plugins](https://bandit.readthedocs.io/en/latest/plugins/)
- [OWASP Python Security](https://owasp.org/www-project-python-security/)
