# Skill: morning-check
Quick morning status check - MCP health, credentials, packages, Monday boards, and stuck items.

## Auto-Trigger
**When:** "morning", "good morning", "start day", "daily check", "what's stuck", "update", "updates", "packages", "maintenance"

## Quick Check (Run All)

Execute steps 1-4 in sequence. Stop and report any failures.

### 1. MCP Server Health
Check all configured MCP servers are responding before anything else.
```bash
echo "=== MCP HEALTH ==="
# Test each MCP server with a simple tool call
for server in atlassian playwright slack postgres fetch sequential-thinking gdrive notion github memory filesystem docker; do
  if claude mcp list 2>/dev/null | grep -q "$server"; then
    echo "  ✅ $server - configured"
  fi
done 2>/dev/null

# Quick connectivity test via Claude's MCP
echo ""
echo "Ping test (try a simple operation on each):"
echo "  - Atlassian: check /jira-quick can reach API"
echo "  - Slack: check channel list loads"
echo "  - GitHub: check gh auth status"
gh auth status 2>&1 | head -3
```

**If any server fails:** Note it and suggest direct API fallback. Do NOT spend more than 2 minutes debugging MCP — use curl/API directly.

### 2. Credential Pre-Flight
Verify credentials for services you'll likely need today.
```bash
echo "=== CREDENTIALS ==="
# GitHub
gh auth status 2>/dev/null && echo "✅ GitHub" || echo "❌ GitHub - run: gh auth login"

# Atlassian
if grep -q "JIRA_API_TOKEN\|ATLASSIAN" ~/.zshrc 2>/dev/null; then
  echo "✅ Atlassian (in .zshrc)"
else
  echo "⚠️  Atlassian - check ~/.zshrc or .env"
fi

# npm
npm whoami 2>/dev/null && echo "✅ npm" || echo "⚠️  npm - not logged in"

# AWS
[ -f ~/.aws/credentials ] && echo "✅ AWS" || echo "⚠️  AWS - no credentials file"

# GCP
gcloud auth list 2>/dev/null | grep -q ACTIVE && echo "✅ GCP" || echo "⚠️  GCP - run: gcloud auth login"

# Cloudflare
[ -f ~/.wrangler/config/default.toml ] && echo "✅ Cloudflare" || echo "⚠️  Cloudflare - no wrangler config"

# App Store Connect
[ -f ~/.appstoreconnect/private_keys/*.p8 ] 2>/dev/null && echo "✅ App Store Connect" || echo "⚠️  ASC - no API key found"
```

### 3. Package Status
```bash
echo "=== PACKAGES ==="
# Homebrew
OUTDATED=$(brew outdated 2>/dev/null | wc -l | tr -d ' ')
echo "Homebrew: $OUTDATED outdated"
[ "$OUTDATED" -gt 0 ] && brew outdated 2>/dev/null | head -5

# npm global
NPM_OUT=$(npm outdated -g 2>/dev/null | tail -n +2 | wc -l | tr -d ' ')
echo "npm global: $NPM_OUT outdated"
[ "$NPM_OUT" -gt 0 ] && npm outdated -g 2>/dev/null | head -5
```

### 4. Monday Boards
```bash
echo "=== MONDAY ==="
~/.claude/scripts/daily-monday-check.sh 2>/dev/null || echo "Monday check script not available - skip"
```

### 5. Git Multi-Project Status
```bash
echo "=== GIT STATUS ==="
for dir in ~/ClaudeCodeWorkspace/"1. Projects"/*/; do
  name=$(basename "$dir")
  if [ -d "$dir/.git" ]; then
    changes=$(git -C "$dir" status --porcelain 2>/dev/null | wc -l | tr -d ' ')
    unpushed=$(git -C "$dir" log --oneline @{u}..HEAD 2>/dev/null | wc -l | tr -d ' ')
    [ "$changes" -gt 0 ] || [ "$unpushed" -gt 0 ] && echo "  ⚠️  $name: ${changes} uncommitted, ${unpushed} unpushed"
  fi
done
echo "  (only showing projects with changes)"
```

## Quick Actions
```bash
update-all   # Updates brew, npm global, App Store
pkg-check    # Just check status without updating
```

## Plan the Day
After checks complete, show:
```markdown
## Today's Focus

### Must Do (from blockers above)
- [ ] [fix any ❌ credential issues]
- [ ] [blocked item from Monday]

### Should Do
- [ ] [update packages if >5 outdated]
- [ ] [commit uncommitted projects]

### Could Do
- [ ] [nice to have]
```

## Related Skills
- `/monday` - Full Monday.com operations
- `/cred-discover` - Deep credential search
- `/system-health` - Full system audit
- `/preflight` - Pre-build feasibility check
- `/standup` - Standup format
- `/focus` - Focus session setup

---
Last updated: 2026-02-06
