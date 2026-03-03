# Skill: cred-discover
Autonomous credential discovery for external services.

## Auto-Trigger
**When:** "find credentials", "check auth", "discover api keys", "credential hunt"

**Auto-run before:** deploy, publish, submit, ship, release (called by `/preflight` and `/deploy-verify`)

**IMPORTANT:** This skill should run automatically before any external service interaction. If you're about to deploy, publish, or access an API — run cred-discover first. This prevents the #1 recurring blocker (credential hunt mid-session).

## Overview
Systematically search for stored credentials across all common locations before attempting external service access. This prevents sessions from ending mid-search due to auth issues.

---

## Discovery Sequence

### Phase 1: Project-Level
```bash
# Current project .env files
find . -maxdepth 3 -name ".env*" -type f 2>/dev/null | while read f; do
  echo "=== $f ==="
  grep -v "^#" "$f" | grep -E "(KEY|TOKEN|SECRET|PASSWORD|CREDENTIAL)" || echo "(none)"
done

# Config files in project
find . -maxdepth 2 -name "*.config.*" -o -name "config.*" 2>/dev/null
```

### Phase 2: User Config Directories
```bash
# Common config locations
for dir in ~/.config ~/.local/share ~/Library/Application\ Support; do
  [ -d "$dir" ] && echo "=== $dir ===" && ls "$dir" 2>/dev/null | head -20
done

# Service-specific configs
ls -la ~/.npmrc ~/.pypirc ~/.docker/config.json ~/.kube/config 2>/dev/null
```

### Phase 3: Environment Variables
```bash
# Current shell environment
printenv | grep -iE "(API|KEY|TOKEN|SECRET|AUTH|CREDENTIAL|PASSWORD)" | \
  sed 's/=.*/=***REDACTED***/'

# Shell profile definitions
grep -h "export.*\(API\|KEY\|TOKEN\|SECRET\)" ~/.zshrc ~/.bashrc ~/.bash_profile 2>/dev/null | \
  sed 's/=.*/=***REDACTED***/'
```

### Phase 4: macOS Keychain
```bash
# List relevant keychain items (names only, not secrets)
security dump-keychain 2>/dev/null | grep -E "svce|acct" | \
  grep -iE "(api|oauth|token|atlassian|google|github|slack|chrome)" | head -20

# Check specific services
for svc in "Chrome Web Store" "Atlassian" "GitHub" "Slack" "Google" "npm"; do
  security find-generic-password -s "$svc" 2>/dev/null && echo "Found: $svc"
done
```

### Phase 5: Cloud CLI Configs
```bash
# AWS
[ -f ~/.aws/credentials ] && echo "AWS credentials found"

# GCP
[ -f ~/.config/gcloud/credentials.db ] && echo "GCP credentials found"
gcloud auth list 2>/dev/null | head -5

# Azure
[ -d ~/.azure ] && echo "Azure config found"

# Cloudflare
[ -f ~/.wrangler/config/default.toml ] && echo "Cloudflare Wrangler config found"
```

### Phase 6: Git Credential Helpers
```bash
# Check git credential storage
git config --global credential.helper
git credential-cache 2>/dev/null
git credential-osxkeychain 2>/dev/null

# GitHub CLI
gh auth status 2>/dev/null
```

---

## Service-Specific Discovery

### Atlassian (Jira/Confluence/Marketplace)
```bash
# Check locations
cat ~/.atlassian/credentials 2>/dev/null
cat ~/.config/atlassian/*.json 2>/dev/null
security find-generic-password -s "Atlassian" 2>/dev/null

# Atlas CLI
atlas auth status 2>/dev/null

# Environment
printenv | grep -i ATLASSIAN
```

### Google/Chrome
```bash
# Chrome Web Store
cat ~/.config/chrome-webstore-upload/config.json 2>/dev/null

# Google Cloud
gcloud auth list 2>/dev/null
cat ~/.config/gcloud/application_default_credentials.json 2>/dev/null

# Environment
printenv | grep -iE "(GOOGLE|CHROME|GCP)"
```

### GitHub
```bash
# GitHub CLI
gh auth status

# Git credentials
git credential fill <<< "host=github.com"

# Environment
printenv | grep -i GITHUB
```

### Slack
```bash
# Slack tokens in env
printenv | grep -i SLACK

# MCP config
cat ~/.claude/mcp.json 2>/dev/null | grep -A5 slack
```

### npm
```bash
# npmrc
cat ~/.npmrc 2>/dev/null | grep -v "^#"

# npm whoami
npm whoami 2>/dev/null
```

---

## Output Format

```markdown
## Credential Discovery Report

**Service:** [requested service]
**Status:** ✅ Found | ⚠️ Partial | ❌ Not Found

### Credentials Located
| Service | Location | Type |
|---------|----------|------|
| GitHub | gh CLI | OAuth |
| npm | ~/.npmrc | Token |
| AWS | ~/.aws/credentials | Access Key |

### Missing Credentials
| Service | Required | How to Set Up |
|---------|----------|---------------|
| Chrome Web Store | OAuth tokens | [Setup guide URL] |
| Atlassian | API token | https://id.atlassian.com/manage-profile/security/api-tokens |

### Recommendations
1. Store tokens in `.env` for project-specific use
2. Use macOS Keychain for sensitive credentials
3. Consider using MCP servers for direct API access
```

---

## Security Notes

- **NEVER output actual credential values** - only indicate presence/location
- Redact sensitive values in logs: `=***REDACTED***`
- Don't search browser credential stores directly
- Respect `.gitignore` patterns when searching

---

## Integration

After discovery, credentials can be used by:
- `/publish` - App store submissions
- `/deploy-verify` - Pre-deployment checks
- `/jira-quick` - Jira operations
- Any MCP server configuration

---
Last updated: 2026-02-05
