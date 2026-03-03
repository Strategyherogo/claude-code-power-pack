# Skill: Deploy Verify
Comprehensive deployment verification.

## Auto-Trigger
**When:** "deploy", "release", "ship" (without "quick")

## Gate Type: BLOCKING
Must pass all checks before deployment proceeds.

## Pre-Deploy Verification

### Code Quality
```bash
# Run all checks
npm run lint && npm run typecheck && npm test

# Check for secrets
git secrets --scan
grep -r "sk_live\|password\|api_key" src/
```

### Git Status
```bash
# Ensure clean state
git status
git log --oneline -5

# Ensure on correct branch
git branch --show-current
```

### Dependencies
```bash
# Check vulnerabilities
npm audit --audit-level=high

# Ensure lockfile matches
npm ci
```

### Environment
```bash
# Verify env vars
printenv | grep -E "^(NODE_ENV|API_|DATABASE_)"

# Check required vars exist
[ -z "$REQUIRED_VAR" ] && echo "Missing REQUIRED_VAR"
```

## Deploy Process

### Step 1: Build
```bash
npm run build
ls -la dist/
```

### Step 2: Deploy
```bash
# Cloudflare Workers
npx wrangler deploy --dry-run  # Preview first
npx wrangler deploy            # Actual deploy
```

### Step 3: Verify
```bash
# Health check
curl -s https://your-app.workers.dev/health | jq .

# Smoke test
curl -s https://your-app.workers.dev/api/status
```

### Step 4: Monitor
```bash
# Watch logs for 5 minutes
npx wrangler tail --format=pretty

# Check error rates
# (platform-specific dashboard)
```

## Output Format
```markdown
## Deployment Report

**Project:** [name]
**Version:** [old] → [new]
**Environment:** production
**Status:** ✅ SUCCESS

### Pre-Deploy Checks
- [x] Lint: passed
- [x] Types: passed
- [x] Tests: 45/45 passed
- [x] Security: no vulnerabilities
- [x] Git: clean, on main

### Deployment
- Build time: 12s
- Deploy time: 8s
- URL: https://app.workers.dev

### Post-Deploy
- Health check: ✅
- Smoke tests: ✅
- Error rate: 0%
```

---
Last updated: 2026-01-27
