# Skill: cred-map
Map and manage credentials and API keys.

## Auto-Trigger
**When:** "credentials", "api keys", "secrets", "tokens"

## ⚠️ Security Warning
NEVER store actual credentials in files. This skill helps you track WHERE credentials are stored, not the credentials themselves.

## Credential Inventory Template
```markdown
## Credential Map
**Last Updated:** [date]
**Owner:** [name]

---

### Production Credentials

| Service | Type | Location | Expires | Notes |
|---------|------|----------|---------|-------|
| Stripe | API Key | Doppler | Never | Live key |
| Google | OAuth | GCP Console | Annual | IR Email |
| Cloudflare | API Token | CF Dashboard | Never | Workers |
| Resend | API Key | Doppler | Never | Emails |

---

### Development Credentials

| Service | Type | Location | Notes |
|---------|------|----------|-------|
| Stripe | Test Key | .env.local | sk_test_* |
| Supabase | Anon Key | .env.local | Local dev |
| OpenAI | API Key | 1Password | Personal |

---

### Service Accounts

| Account | Purpose | Location | Access |
|---------|---------|----------|--------|
| gcp-ir-email@project.iam | IR Email Monitor | GCP | Owner |
| github-actions | CI/CD | GitHub Secrets | Admin |

---

### OAuth Apps

| App | Provider | Client ID Location | Scopes |
|-----|----------|-------------------|--------|
| IR Email | Google | Doppler | Gmail readonly |
| Notion Sync | Notion | 1Password | Read/Write |

---

### Rotation Schedule

| Credential | Last Rotated | Next Due | Owner |
|------------|--------------|----------|-------|
| Stripe Live | 2025-01-01 | 2026-01-01 | Me |
| JWT Secret | 2025-06-01 | 2025-12-01 | Me |

---

### Access Matrix

| Person | Stripe | GCP | Cloudflare | GitHub |
|--------|--------|-----|------------|--------|
| Me | Admin | Owner | Admin | Owner |
| Partner | - | Viewer | - | Write |
```

## Secure Storage Options

### 1Password / Bitwarden
```
Best for: Personal credentials, shared team secrets
Access: Manual or CLI
Example: op read "op://Vault/Item/password"
```

### Doppler
```
Best for: Environment variables, team sharing
Access: CLI, CI/CD integration
Example: doppler secrets get STRIPE_KEY
```

### AWS Secrets Manager
```
Best for: Production secrets, auto-rotation
Access: AWS SDK, IAM roles
Example: aws secretsmanager get-secret-value --secret-id prod/stripe
```

### HashiCorp Vault
```
Best for: Enterprise, complex rotation
Access: API, CLI
Example: vault kv get secret/stripe
```

## Environment Variable Patterns

### Development (.env.local)
```bash
# Development credentials - DO NOT COMMIT
STRIPE_KEY=sk_test_xxx
DATABASE_URL=postgres://localhost/dev
```

### Production (Doppler/Secrets Manager)
```bash
# Set via secrets manager, not .env files
STRIPE_KEY=<from-doppler>
DATABASE_URL=<from-secrets-manager>
```

### CI/CD (GitHub Secrets)
```yaml
# .github/workflows/deploy.yml
env:
  STRIPE_KEY: ${{ secrets.STRIPE_KEY }}
```

## Credential Checklist

### Before Using
```
□ Credential is for correct environment (dev/prod)
□ Minimal required permissions/scopes
□ Not hardcoded in source code
□ Not committed to git
□ Rotation date set
□ Access logged
```

### When Rotating
```
□ New credential created
□ Deployed to all environments
□ Old credential still working (parallel)
□ Application verified working
□ Old credential revoked
□ Rotation logged
```

### After Leak/Exposure
```
□ Immediately rotate affected credential
□ Check access logs for unauthorized use
□ Identify scope of exposure
□ Revoke old credential
□ Audit git history (git filter-branch)
□ Notify affected parties if data accessed
□ Document incident
```

---
Last updated: 2026-01-27
