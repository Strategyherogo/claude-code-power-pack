# Skill: gate
**TIER 1 — BLOCKING GATE.** Pre-build feasibility check that MUST pass before any build, deploy, or integration task begins.

## Auto-Trigger
**When:** "build", "deploy", "integrate", "add [service] to", "connect to [API]", "publish", "ship"
**Behavior:** BLOCKS — must pass all checks or explicitly acknowledge failures before proceeding.

## Why This Exists
TC1 violations are the #1 recurring failure pattern. Sessions wasted building before verifying:
- API enabled on project (Vertex AI on GCP — 45 min wasted)
- Auth tokens not expired (gcloud auth — blocked entire session)
- Service account has correct permissions
- Target API actually supports the needed operations

**Rule: Test access BEFORE writing code. Always.**

---

## Gate Checklist (run ALL in parallel, < 2 min total)

### 1. Auth Status Check
```bash
# Check all relevant auth in parallel
echo "=== AUTH STATUS ==="

# GCP
gcloud auth list 2>/dev/null | grep -q ACTIVE && echo "✅ GCP auth active" || echo "❌ GCP auth expired → run: gcloud auth login"

# GitHub
gh auth status 2>/dev/null | head -1 && echo "✅ GitHub" || echo "❌ GitHub → run: gh auth login"

# Jira
[ -n "$JIRA_API_TOKEN" ] && echo "✅ Jira token set" || echo "❌ No JIRA_API_TOKEN"

# DigitalOcean
doctl account get 2>/dev/null | head -1 && echo "✅ DigitalOcean" || echo "❌ doctl not authed"

# npm
npm whoami 2>/dev/null && echo "✅ npm" || echo "⚠️ npm not logged in"
```

### 2. Target API Reachability
Before building anything that calls an external API:
```markdown
□ Can you reach the API endpoint? (curl -s -o /dev/null -w "%{http_code}" [endpoint])
□ Does the API return a non-error response with your credentials?
□ Is the specific API/service ENABLED on the target project?
  - GCP: gcloud services list --enabled --project=PROJECT | grep SERVICE
  - AWS: aws service get-* calls
□ Does your service account/token have the required permissions?
```

**Hard requirement:** Run an actual API test call BEFORE writing any integration code.

### 3. Branch Strategy Decision
```markdown
□ What branch will you push to? (main vs feature branch)
□ If main: does user explicitly approve pushing to main?
□ If feature: create branch now before any changes
```

### 4. Environment & Dependencies
```bash
# Check project-specific requirements
[ -f package.json ] && npm ls --depth=0 2>&1 | grep -c "ERR!" | xargs -I{} echo "npm issues: {}"
[ -f requirements.txt ] && python3 -c "import pkg_resources; pkg_resources.require(open('requirements.txt').readlines())" 2>&1 | grep -c "not found" | xargs -I{} echo "Python missing: {}"
[ -f manifest.yml ] && forge --version 2>/dev/null || echo "⚠️ Forge CLI needed"
```

---

## Gate Report

```markdown
## 🚦 Gate Report: [TASK]

| Check | Status | Details |
|-------|--------|---------|
| Auth | ✅/❌ | [which services checked] |
| API Access | ✅/❌ | [endpoint tested, response code] |
| Branch | ✅ | [branch name, strategy] |
| Dependencies | ✅/⚠️ | [any issues] |

### Decision: GO / NO-GO / GO WITH CAVEAT

**If NO-GO:**
- Blocker: [specific issue]
- Fix: [exact command to run]
- Estimated fix time: [X minutes]

**If GO WITH CAVEAT:**
- Limitation: [what won't work]
- Fallback: [alternative approach]
```

---

## Blocking Behavior

When gate finds a blocker:
1. **STOP** — Do not proceed to code/build/deploy
2. **SHOW** the Gate Report with the specific blocker
3. **OFFER** the fix command
4. **WAIT** for user to resolve or explicitly say "proceed anyway"

If user says "skip gate" or "proceed anyway":
- Log it as a conscious decision
- Note: "⚠️ Gate skipped — proceeding at user's request"

---

## Known Gotchas (from past failures)

| Service | Gotcha | Check Command |
|---------|--------|---------------|
| GCP Vertex AI | API must be ENABLED per-project | `gcloud services list --enabled --project=X \| grep aiplatform` |
| GCP auth | Tokens expire after ~7 days inactivity | `gcloud auth list` |
| Jira Org Admin API | Read-only — can't write | Check API docs first |
| Forge | Licensing blocks install | Disable licensing → deploy → install → re-enable |
| Chrome Web Store | Consent screen must be "Production" | Check OAuth config |
| Monday.com | Status labels immutable after creation | Plan labels before creating columns |
| MCP env vars | Don't expand in args array | Use `sh -c` wrapper |

---

## Integration
This skill is the enhanced Tier 1 version of `/preflight`. It should be:
- **Auto-triggered** before build/deploy/integrate keywords
- **Called by** `/deploy-verify`, `/swift:app-store-prep`, `/publish`
- **Chained with** `/write-plan` for multi-step tasks

## Related Skills
- `/preflight` — original version (now superseded by this gate)
- `/cred-discover` — deep credential search
- `/deploy-verify` — post-deploy verification

---
Last updated: 2026-02-07
