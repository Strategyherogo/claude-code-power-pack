# Skill: preflight
Feasibility check before building - verify API capabilities, credentials, and package health.

## Auto-Trigger
**When:** "preflight", "before we build", "can we do this", "feasibility", "check first", "will this work"

**Also auto-run before:** Any build, deploy, or publish workflow.

## Overview
Prevents the "build first, discover limits later" pattern. Run this before starting any non-trivial build to catch blockers early. Based on patterns from past sessions where 3+ sessions were wasted building on broken foundations.

---

## Preflight Checklist

### 1. Credential Check (< 1 min)
Verify all needed credentials exist BEFORE writing any code.

```bash
echo "=== CREDENTIAL CHECK ==="
SERVICE=$1  # Pass target service: "jira", "appstore", "chrome", "aws", etc.

# Quick checks per service
case "$SERVICE" in
  jira|atlassian)
    grep -q "JIRA_API_TOKEN\|ATLASSIAN" ~/.zshrc 2>/dev/null && echo "✅ Jira token" || echo "❌ No JIRA_API_TOKEN"
    atlas auth status 2>/dev/null && echo "✅ Atlas CLI" || echo "⚠️  Atlas CLI not authed"
    ;;
  appstore|ios|macos)
    ls ~/.appstoreconnect/private_keys/*.p8 2>/dev/null && echo "✅ ASC API key" || echo "❌ No ASC API key"
    security find-identity -v -p codesigning 2>/dev/null | head -1 && echo "✅ Signing identity" || echo "❌ No signing identity"
    ;;
  chrome|cws)
    [ -f ~/.config/chrome-webstore-upload/config.json ] && echo "✅ CWS config" || echo "❌ No CWS config"
    ;;
  aws)
    [ -f ~/.aws/credentials ] && echo "✅ AWS creds" || echo "❌ No AWS credentials"
    ;;
  gcp|google)
    gcloud auth list 2>/dev/null | grep -q ACTIVE && echo "✅ GCP" || echo "❌ GCP not authed"
    ;;
  cloudflare|cf)
    [ -f ~/.wrangler/config/default.toml ] && echo "✅ Wrangler" || echo "❌ No wrangler config"
    ;;
  npm)
    npm whoami 2>/dev/null && echo "✅ npm" || echo "❌ npm not logged in"
    ;;
  github|gh)
    gh auth status 2>/dev/null && echo "✅ GitHub" || echo "❌ GitHub not authed"
    ;;
  *)
    echo "Running general credential scan..."
    gh auth status 2>&1 | head -2
    npm whoami 2>/dev/null || echo "npm: not logged in"
    gcloud auth list 2>/dev/null | head -3
    grep -q "JIRA_API_TOKEN" ~/.zshrc 2>/dev/null && echo "Jira: configured" || echo "Jira: not found"
    ;;
esac
```

### 2. API Capability Check (< 2 min)
Before building a workflow around an API, verify it can actually do what you need.

```markdown
Answer these questions BEFORE writing code:

□ Is the API read-only or read-write?
  - Jira Org Admin API: READ-ONLY (learned the hard way)
  - App Store Connect API: read-write for metadata, NOT for uploads
  - Monday.com GraphQL: full CRUD

□ Does the API have rate limits that affect your use case?
  - Atlassian: 100 req/min per user
  - GitHub: 5000 req/hr authenticated
  - App Store: variable, undocumented

□ Does the API require specific auth scopes you may not have?
  - Chrome Web Store: needs consent screen in "Production" mode
  - Forge apps: licensing requires Developer Console distribution config

□ Are there known quirks or workarounds needed?
  - Forge: can't use resource:icon in production → use external URL
  - Forge: licensing + install is a chicken-and-egg → disable licensing first
  - MCP env vars: don't expand in args array → use sh -c wrapper
```

### 3. Package/Tool Health (< 1 min)
Check that the tools you'll use actually work.

```bash
echo "=== TOOL HEALTH ==="
# Check if target MCP server responds
# (Don't spend >2 min on broken MCP — fallback to direct API)

# Check Node/npm for JS projects
if [ -f package.json ]; then
  node -v && echo "✅ Node" || echo "❌ Node broken"
  npm ls --depth=0 2>&1 | grep -c "ERR!" | xargs -I{} test {} -eq 0 && echo "✅ Dependencies" || echo "⚠️  npm dependency issues"
fi

# Check Python for Python projects
if [ -f requirements.txt ] || [ -f pyproject.toml ]; then
  python3 -c "print('ok')" && echo "✅ Python" || echo "❌ Python broken"
  [ -d venv ] && echo "✅ venv exists" || echo "⚠️  No venv"
fi

# Check Forge for Jira apps
if [ -f manifest.yml ]; then
  forge --version 2>/dev/null && echo "✅ Forge CLI" || echo "❌ Forge CLI not found"
fi

# Check Xcode for Swift/iOS
if [ -f *.xcodeproj ] 2>/dev/null || [ -f project.yml ]; then
  xcodebuild -version 2>/dev/null | head -1 && echo "✅ Xcode" || echo "❌ Xcode issue"
fi
```

### 4. Source Code Check (< 30 sec)
Verify the source exists and builds.

```bash
echo "=== SOURCE CHECK ==="
# Verify project directory exists and has source files
[ -d "src" ] || [ -d "Sources" ] || [ -d "lib" ] && echo "✅ Source directory found" || echo "⚠️  No standard source dir"

# Check git state
git status --porcelain 2>/dev/null | head -5
BRANCH=$(git branch --show-current 2>/dev/null)
echo "Branch: $BRANCH"

# Check for build artifacts / previous builds
[ -d "build" ] || [ -d ".build" ] || [ -d "dist" ] && echo "ℹ️  Previous build artifacts exist"
```

---

## Preflight Report

After running all checks, output a summary:

```markdown
## Preflight Report: [PROJECT/TASK]

### Credentials: ✅ Ready | ⚠️ Partial | ❌ Blocked
[list findings]

### API Capability: ✅ Verified | ⚠️ Unverified | ❌ Known Limitation
[list any API constraints discovered]

### Tools: ✅ Healthy | ⚠️ Issues | ❌ Broken
[list tool status]

### Source: ✅ Found | ❌ Missing
[list source status]

### GO / NO-GO Decision
- **GO:** All checks pass, proceed with build
- **NO-GO:** [specific blocker] must be resolved first
- **GO WITH CAVEAT:** [limitation] — plan fallback approach
```

### 5. Security Pre-Deploy Check (< 2 min)
Critical security issues to catch BEFORE deployment. Based on production incidents.

```bash
echo "=== SECURITY CHECK ==="

# Check for debug mode in production code
grep -rn "debug\s*=\s*True" src/ app/ 2>/dev/null && echo "❌ CRITICAL: debug=True found" || echo "✅ No debug mode"
grep -rn "DEBUG\s*=\s*true" . --include="*.env*" 2>/dev/null && echo "⚠️  Debug in env files"

# Check for hardcoded secrets
grep -rn "password\s*=\s*['\"]" src/ app/ 2>/dev/null && echo "❌ CRITICAL: Hardcoded password"
grep -rn "api[_-]key\s*=\s*['\"]" src/ app/ 2>/dev/null && echo "❌ CRITICAL: Hardcoded API key"
grep -rn "token\s*=\s*['\"]" src/ app/ 2>/dev/null && echo "⚠️  Hardcoded token found"

# Check for exposed error details
grep -rn "traceback\.print_exc\|console\.error" src/ app/ 2>/dev/null && echo "⚠️  Error details may leak"

# Check for production config
[ -f ".env.production" ] && echo "✅ Production env file exists" || echo "ℹ️  No .env.production"

# Verify .gitignore has secrets
grep -q "\.env" .gitignore 2>/dev/null && echo "✅ .env in gitignore" || echo "❌ CRITICAL: .env not ignored"
grep -q "secrets\|credentials\|keys" .gitignore 2>/dev/null && echo "✅ Secrets pattern in gitignore"
```

**Critical Security Checklist:**
```
□ No debug=True in production code
□ No hardcoded API keys, tokens, passwords
□ No exposed tracebacks or detailed errors to end users
□ Secrets files in .gitignore
□ Environment-specific configs exist (.env.production)
□ CORS properly configured (not allow all)
□ Input validation on all endpoints
□ Rate limiting configured
```

**Fast Security Scan Command:**
```bash
# One-liner security scan
grep -rn --include="*.py" --include="*.js" --include="*.ts" -E "(debug\s*=\s*True|password\s*=\s*['\"]|api[_-]?key\s*=\s*['\"])" src/ || echo "✅ Quick scan clean"
```

---

## Known Gotchas (from past sessions)
These caused wasted sessions. Check for them explicitly:

| Gotcha | Service | Workaround |
|--------|---------|------------|
| Org Admin API is read-only | Jira | Use UI for writes |
| Consent screen must be "Production" | Chrome Web Store | Publish consent screen first |
| `resource:icon` fails in prod | Forge | Host icon externally |
| Licensing blocks install | Forge | Disable licensing → deploy → install → re-enable |
| MCP env vars don't expand | MCP config | Use `sh -c` wrapper |
| Monday MCP package broken | Monday.com | Use direct GraphQL via urllib |
| `screencapture` can't do native windows programmatically without permissions | macOS | Use `screencapture -l <windowID>` |
| Bundle ID mismatch | App Store | Verify PRODUCT_BUNDLE_IDENTIFIER matches ASC |
| `INFOPLIST_KEY_*` silently ignores third-party keys | XcodeGen/Xcode | Use `postBuildScripts` + PlistBuddy for AdMob, Firebase, etc. |
| Apple 2FA blocks browser automation for ASC | App Store Connect | Always plan manual workflow; automation can't handle Apple login |

---

## Integration
This skill should be called by:
- `/deploy-verify` - before any deployment
- `/swift:app-store-prep` - before App Store submission
- `/publish` - before any marketplace publishing
- `/build-test` - before building

## Related Skills
- `/cred-discover` - Deep credential search
- `/system-health` - Full system audit
- `/morning-check` - Quick daily check

---
Last updated: 2026-02-06
