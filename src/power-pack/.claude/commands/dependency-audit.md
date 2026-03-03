# Skill: dependency-audit
Check for outdated and vulnerable dependencies.

## Auto-Trigger
**When:** "dependency audit", "check deps", "outdated packages", "vulnerable", "npm audit", "security scan"

## Quick Audit Commands

### Node.js/npm
```bash
# Check outdated
npm outdated

# Security audit
npm audit

# Fix vulnerabilities
npm audit fix

# Major updates
npx npm-check-updates
```

### Python/pip
```bash
# Check outdated
pip list --outdated

# Security check
pip-audit

# Or with safety
safety check
```

### Homebrew
```bash
brew outdated
brew doctor
```

### All Package Managers
```bash
# Run comprehensive check
/system-health  # Uses health check skill
```

## Audit Report Template

```markdown
## Dependency Audit Report
**Date:** [YYYY-MM-DD]
**Project:** [name]

### Summary
| Severity | Count |
|----------|-------|
| Critical | X |
| High | X |
| Medium | X |
| Low | X |

### Critical/High Issues

#### [Package Name]
- **Current:** v1.2.3
- **Vulnerable:** < v1.2.5
- **Fixed in:** v1.2.5
- **CVE:** CVE-2026-XXXX
- **Action:** `npm update [package]`

### Outdated (Non-Security)

| Package | Current | Latest | Type |
|---------|---------|--------|------|
| react | 18.0.0 | 18.2.0 | minor |
| lodash | 4.17.0 | 4.17.21 | patch |

### Recommendations
1. [Immediate action for critical]
2. [Scheduled update for others]
```

## Automated Checks

### GitHub Dependabot
```yaml
# .github/dependabot.yml
version: 2
updates:
  - package-ecosystem: "npm"
    directory: "/"
    schedule:
      interval: "weekly"
```

### Pre-commit Hook
```bash
# Run audit before commit
npm audit --audit-level=high
```

## Update Strategies

### Safe Updates (Patch)
```bash
# Update all patch versions
npm update
```

### Minor Updates
```bash
# Check what would change
npx npm-check-updates --target minor

# Apply
npx npm-check-updates -u --target minor
npm install
```

### Major Updates (Careful)
```bash
# One at a time
npm install [package]@latest

# Test after each
npm test
```

## Security Resources
- [npm advisories](https://www.npmjs.com/advisories)
- [Snyk vulnerability DB](https://snyk.io/vuln)
- [CVE database](https://cve.mitre.org)

## Schedule
- **Weekly:** Quick `npm audit`
- **Monthly:** Full dependency review
- **Quarterly:** Major version updates

## Quick Commands
```
/dependency-audit              # Full audit
/dependency-audit security     # Security only
/dependency-audit outdated     # Outdated only
/dependency-audit fix          # Auto-fix safe updates
```

---
Last updated: 2026-01-29
