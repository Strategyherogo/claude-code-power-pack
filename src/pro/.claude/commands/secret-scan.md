# Skill: secret-scan
Find leaked secrets in code and git history.

## Auto-Trigger
**When:** "secret scan", "find secrets", "leaked credentials", "check for secrets", "security scan"

## Quick Scan Commands

### Using Gitleaks (Recommended)
```bash
# Install
brew install gitleaks

# Scan current directory
gitleaks detect --source . -v

# Scan git history
gitleaks detect --source . --log-opts="--all" -v

# Generate report
gitleaks detect --source . -f json -r secrets-report.json
```

### Using truffleHog
```bash
# Install
pip install trufflehog

# Scan directory
trufflehog filesystem .

# Scan git repo
trufflehog git file://. --since-commit HEAD~50

# Scan GitHub repo
trufflehog github --repo https://github.com/org/repo
```

### Using git-secrets
```bash
# Install
brew install git-secrets

# Add AWS patterns
git secrets --register-aws

# Scan
git secrets --scan
git secrets --scan-history
```

## Common Secret Patterns

### What to Look For
| Type | Pattern Example |
|------|-----------------|
| AWS Keys | `AKIA[0-9A-Z]{16}` |
| GitHub Token | `ghp_[a-zA-Z0-9]{36}` |
| Slack Token | `xox[baprs]-[0-9a-zA-Z-]+` |
| Private Key | `-----BEGIN RSA PRIVATE KEY-----` |
| Generic API Key | `api[_-]?key[_-]?['\"]?[a-zA-Z0-9]{20,}` |
| JWT | `eyJ[a-zA-Z0-9_-]*\.eyJ[a-zA-Z0-9_-]*\.[a-zA-Z0-9_-]*` |
| Password in URL | `://[^:]+:[^@]+@` |

### Manual Grep
```bash
# AWS Keys
grep -rE "AKIA[0-9A-Z]{16}" .

# Private Keys
grep -rE "BEGIN (RSA|DSA|EC|OPENSSH) PRIVATE KEY" .

# Generic secrets
grep -rE "(password|secret|api_key|apikey|token)\s*[=:]\s*['\"][^'\"]+['\"]" .

# Connection strings
grep -rE "(postgres|mysql|mongodb)://[^:]+:[^@]+@" .
```

## Pre-commit Prevention

### .pre-commit-config.yaml
```yaml
repos:
  - repo: https://github.com/gitleaks/gitleaks
    rev: v8.18.0
    hooks:
      - id: gitleaks
```

### Git Hook (Manual)
```bash
#!/bin/bash
# .git/hooks/pre-commit

gitleaks protect --staged --verbose
if [ $? -ne 0 ]; then
  echo "Secret detected! Commit blocked."
  exit 1
fi
```

## .gitleaksignore
```
# Ignore test files
tests/*
*_test.go
*.test.js

# Ignore specific false positives
path/to/file.js:123  # reason for ignoring

# Ignore specific rules
*.md:generic-api-key
```

## Remediation

### If Secret Found in Code
1. **Remove immediately** from code
2. **Rotate the credential** (generate new key)
3. **Check access logs** for unauthorized use
4. **Update .gitignore** to prevent future commits

### If Secret Found in Git History
```bash
# Option 1: BFG Repo Cleaner (easier)
brew install bfg
bfg --replace-text secrets.txt repo.git
git reflog expire --expire=now --all
git gc --prune=now --aggressive

# Option 2: git filter-branch
git filter-branch --force --index-filter \
  "git rm --cached --ignore-unmatch path/to/file" \
  --prune-empty --tag-name-filter cat -- --all
```

**Warning:** This rewrites history. Coordinate with team.

### After Cleaning
```bash
# Force push (coordinate with team!)
git push origin --force --all
git push origin --force --tags

# Team members must re-clone or:
git fetch origin
git reset --hard origin/main
```

## Audit Report Template

```markdown
## Secret Scan Report
**Date:** [date]
**Repository:** [repo name]
**Tool:** gitleaks v[version]

### Summary
- **Files scanned:** [X]
- **Commits scanned:** [X]
- **Secrets found:** [X]

### Findings

| Severity | Type | File | Line | Status |
|----------|------|------|------|--------|
| HIGH | AWS Key | config.js | 45 | Remediated |
| MEDIUM | API Key | .env | 12 | False Positive |

### Actions Taken
1. [Action 1]
2. [Action 2]

### Recommendations
1. [Recommendation]
```

## Quick Commands
```
/secret-scan               # Scan current directory
/secret-scan history       # Scan git history
/secret-scan report        # Generate report
/secret-scan remediate     # Help fix found secrets
```

---
Last updated: 2026-01-29
