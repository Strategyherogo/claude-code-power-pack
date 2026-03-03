# Skill: share-code
Securely share code with external collaborators (developers, contractors, etc.)

## Auto-Trigger
**When:** "share code", "send to developer", "handoff code", "share with contractor", "package for sharing"

## SECURITY RULES (ENFORCED)

**BEFORE ANY SHARING:**
1. **NEVER create public gists/repos** - Use `--public` only if user explicitly says "make it public"
2. **Default to local zip** - Safest option, user shares manually
3. **Scan for sensitive patterns** - Warn about hostnames, IDs, schemas
4. **Ask before external upload** - Even private gists need confirmation

---

## Workflow

### Step 1: Identify Files to Share
```
User request: "share the [project/file] code"

□ Identify all relevant files
□ Check for dependencies (imports, configs)
□ List files that will be included
```

### Step 2: Security Scan
```
Scan for sensitive patterns:
□ AWS/cloud hostnames (*.rds.amazonaws.com, *.s3.*, etc.)
□ Database schemas and table names
□ API endpoints and URLs
□ Slack/Discord channel IDs
□ Google Sheet/Doc IDs
□ IP addresses
□ Jira project keys
□ Any hardcoded IDs

If found → WARN user before proceeding
```

### Step 3: Choose Sharing Method

**Ask user:**
> How would you like to share this?
> 1. **Zip file (Recommended)** - Local only, you share via Slack/email
> 2. **Private gist** - Link sharing, only people with link can view
> 3. **Private repo** - Full version control

**NEVER offer public option by default.**

### Step 4: Create Package

#### Option A: Zip File (Default/Safest)
```bash
cd [project-dir]
zip -r [name]-handoff.zip [files] -x "*.env" -x "*credentials*" -x "*.pyc" -x "__pycache__/*" -x ".git/*" -x "node_modules/*"
```

Output location: `3. Resources/shareable/[name]-handoff.zip`

#### Option B: Private Gist
```bash
# NOTE: No --public flag!
gh gist create [files] -d "[description]"
```

#### Option C: Private Repo
```bash
# Create private repo
gh repo create [name] --private
# Push code
```

### Step 5: Create Handoff Doc
```markdown
# [Project] - Developer Handoff

## Files Included
- [file1]: [purpose]
- [file2]: [purpose]

## Setup Requirements
- [dependency 1]
- [dependency 2]

## Environment Variables Needed
- `VAR_NAME`: [description]

## Quick Start
[instructions]

## Questions?
[contact info]
```

### Step 6: Confirm Delivery
```
✅ Package created: [location]
📦 Size: [size]
🔒 Security: [local/private gist/private repo]

Share via: [Slack DM / Email / Link]
```

---

## Security Checklist (Run Every Time)

```
Before sharing ANY code:

□ Credentials removed? (passwords, API keys, tokens)
□ Infrastructure details noted? (hostnames, schemas, IDs)
  → If yes: User warned, user approved
□ Sharing method confirmed with user?
□ Default is private/local?
□ NO --public flag used?
```

---

## Sensitive Patterns to Detect

```regex
# Cloud hostnames
.*\.rds\.amazonaws\.com
.*\.s3\.amazonaws\.com
.*\.ondigitalocean\.app
.*\.cloudflare\.com
.*\.herokuapp\.com

# Database patterns
"[A-Z]+"\."[A-Z_]+"     # Schema.Table format
(postgres|mysql|mongodb):\/\/

# IDs and tokens
(sk-|pk_|api[_-]?key|token|secret)
[A-Z0-9]{20,}           # Long alphanumeric (possible keys)

# Service IDs
C[A-Z0-9]{8,}           # Slack channel IDs
1[a-zA-Z0-9_-]{40,}     # Google Sheet/Doc IDs

# Internal URLs
https?:\/\/[^\/]*\.(atlassian|slack|notion)
```

---

## Example Usage

### User: "share the ir-monitor code with my developer"

**Claude response:**
```
I'll prepare the IR Monitor code for sharing.

⚠️ **Security Notice:**
This code contains:
- AWS RDS hostname (prod-reporting-read-only...rds.amazonaws.com)
- Database schema names (CUSTOMER, merchant)
- Slack channel IDs
- Google Sheet IDs

These are infrastructure details (not credentials), but should stay private.

**How would you like to share?**
1. **Zip file (Recommended)** - You share via Slack DM/email
2. **Private gist** - Shareable link (only with link)

[Wait for user choice before proceeding]
```

---

## Error Prevention

### NEVER Do This:
```bash
# ❌ WRONG - public by default
gh gist create file.py --public

# ❌ WRONG - pushing to public repo
gh repo create project --public
git push
```

### Always Do This:
```bash
# ✅ CORRECT - private gist (no --public flag)
gh gist create file.py -d "description"

# ✅ CORRECT - local zip
zip -r handoff.zip files/

# ✅ CORRECT - explicit private repo
gh repo create project --private
```

---

## Output Locations

| Type | Location |
|------|----------|
| Zip files | `3. Resources/shareable/[name]-handoff.zip` |
| Handoff docs | `3. Resources/shareable/[name]-HANDOFF.md` |
| Private gists | Returns URL (user shares link) |

---

## Related Skills
- `/save` - Save session state
- `/session-retro` - Review what was shared
- `/env-sync` - Check environment variables

---
Last updated: 2026-01-29
Created after: Public gist security incident
