# Skill: system-health
Comprehensive system and package health check for macOS.

## Auto-Trigger
**When:** "system health", "check system", "health check", "package audit", "lib check", "security scan"

## Quick Check (Default)
Run these commands in sequence:

### 0. MCP Server Connectivity
```bash
echo "=== MCP SERVERS ==="
# Check each known MCP server is reachable
# Servers from MASTER.md: atlassian, playwright, slack, postgres, fetch, sequential-thinking, gdrive, notion, github, memory, filesystem, docker

# Test GitHub (most reliable indicator)
gh auth status 2>&1 | head -2

# Test Atlassian
if printenv | grep -q JIRA_API_TOKEN 2>/dev/null || grep -q JIRA_API_TOKEN ~/.zshrc 2>/dev/null; then
  echo "✅ Atlassian: token configured"
else
  echo "⚠️  Atlassian: no JIRA_API_TOKEN found"
fi

# Test Slack (check if MCP can list channels)
echo "Slack: check via /bot:slack-debug if needed"

# Test Postgres
if printenv | grep -q DATABASE_URL 2>/dev/null; then
  echo "✅ Postgres: DATABASE_URL set"
else
  echo "⚠️  Postgres: no DATABASE_URL"
fi

# Summary
echo ""
echo "If any MCP server fails during session:"
echo "  → Use direct API (curl/python) as fallback"
echo "  → Don't spend >2 min debugging MCP issues"
```

### 1. Package Managers
```bash
# Homebrew
echo "=== HOMEBREW ===" && brew doctor 2>&1 | head -5
brew outdated
brew autoremove --dry-run

# Node (if exists)
if command -v npm &> /dev/null; then
  echo "=== NPM ===" && npm outdated -g 2>/dev/null | head -10
fi

# Python (if exists)
if command -v pip &> /dev/null; then
  echo "=== PIP ===" && pip list --outdated 2>/dev/null | head -10
fi
```

### 2. System Integrity
```bash
# SIP Status
echo "=== SYSTEM INTEGRITY ===" && csrutil status

# Check for unsigned binaries in common locations
echo "Unsigned in /usr/local/bin:"
find /usr/local/bin -type f -perm +111 -exec sh -c 'codesign -v "$1" 2>&1 | grep -q "not signed" && echo "$1"' _ {} \; 2>/dev/null | head -5
```

### 3. Suspicious Locations
```bash
echo "=== LAUNCH AGENTS (User) ===" && ls -la ~/Library/LaunchAgents/ 2>/dev/null
echo "=== LAUNCH AGENTS (System) ===" && ls /Library/LaunchAgents/ 2>/dev/null
echo "=== LAUNCH DAEMONS ===" && ls /Library/LaunchDaemons/ 2>/dev/null | grep -v com.apple
```

### 4. Active Connections
```bash
echo "=== ACTIVE CONNECTIONS ===" && lsof -i -P 2>/dev/null | grep ESTABLISHED | head -15
```

## Full Audit
For comprehensive check, run the script:
```bash
~/ClaudeCodeWorkspace/scripts/system-health-check.sh
```

## Baseline Management

### Create Baseline
```bash
# Create baseline of critical directories
sudo mtree -c -K sha256 -p /usr/local/bin > ~/.system-baseline-usrlocalbin.txt
sudo mtree -c -K sha256 -p /opt/homebrew/bin > ~/.system-baseline-homebrew.txt
```

### Verify Against Baseline
```bash
# Check for modifications
sudo mtree -p /usr/local/bin < ~/.system-baseline-usrlocalbin.txt
sudo mtree -p /opt/homebrew/bin < ~/.system-baseline-homebrew.txt
```

## Cleanup Commands

### Safe Cleanup
```bash
# Homebrew
brew autoremove && brew cleanup --prune=all

# npm
npm cache clean --force

# pip
pip cache purge

# System caches
rm -rf ~/Library/Caches/com.apple.dt.Xcode/* 2>/dev/null
rm -rf ~/Library/Developer/Xcode/DerivedData/* 2>/dev/null
```

### Remove Duplicates
```bash
# Find duplicate Homebrew formulae
brew list --formula | xargs -I {} sh -c 'brew info {} 2>/dev/null | grep -q "Not installed" && echo {}'

# Find duplicate Python packages
pip list --format=freeze | cut -d= -f1 | sort | uniq -d
```

## Security Checklist

### Weekly Review
- [ ] `brew doctor` - no warnings
- [ ] `npm audit` - no critical vulnerabilities
- [ ] Launch agents - all recognized
- [ ] Kernel extensions - only expected ones (`kextstat | grep -v com.apple`)
- [ ] Login items - all legitimate

### Monthly Review
- [ ] Verify system baseline
- [ ] Update all packages
- [ ] Review network connections
- [ ] Check disk usage for anomalies
- [ ] Review browser extensions

## Red Flags to Watch

| Location | Suspicious Signs |
|----------|-----------------|
| ~/Library/LaunchAgents | Unknown .plist files |
| /Library/LaunchDaemons | Non-Apple daemons |
| /usr/local/bin | Unsigned executables |
| ~/.bash_profile, ~/.zshrc | Unknown PATH additions |
| /etc/hosts | Unexpected entries |

## Report Output
Save to: `2. Areas/01-device-security/health-reports/[YYYY-MM-DD]-health.md`

---
Last updated: 2026-02-06
