# Skill: Env Sync
Synchronize environment variables across environments.

## Auto-Trigger
**When:** "env", "environment", "secrets", "config sync"

## Environment Management

### Local → Remote Sync
```bash
# Export local env
cat .env | grep -v "^#" | grep "=" > .env.export

# Set in Cloudflare Workers
while IFS='=' read -r key value; do
  echo "Setting $key..."
  echo "$value" | npx wrangler secret put "$key"
done < .env.export

# Set in Vercel
while IFS='=' read -r key value; do
  vercel env add "$key" production <<< "$value"
done < .env.export
```

### Remote → Local Sync
```bash
# From Vercel
vercel env pull .env.local

# From Railway
railway env > .env.local

# From Doppler (secret manager)
doppler secrets download --no-file --format env > .env.local
```

### Cross-Environment Diff
```bash
# Compare local vs production
diff <(sort .env) <(vercel env ls production | sort)

# Compare staging vs production
diff <(vercel env ls staging | sort) <(vercel env ls production | sort)
```

## Environment Variables Audit

### Security Check
```bash
# Find potential secrets in code
grep -r "sk_live\|password\|secret\|api_key\|token" src/ --include="*.ts"

# Check .env isn't committed
git log --all --full-history -- .env

# Verify .gitignore
grep ".env" .gitignore
```

### Required Variables Template
```bash
# .env.example
# ============
# Database
DATABASE_URL=

# Auth
JWT_SECRET=
GOOGLE_CLIENT_ID=
GOOGLE_CLIENT_SECRET=

# Services
STRIPE_SECRET_KEY=
RESEND_API_KEY=
SLACK_WEBHOOK_URL=

# Monitoring
SENTRY_DSN=
```

## Sync Checklist
```
□ .env.example up to date
□ All required vars documented
□ No secrets in .env.example
□ Production secrets rotated recently
□ Staging uses separate credentials
□ Local uses test/dev credentials
```

## Multi-Environment Matrix
```markdown
| Variable | Local | Staging | Production |
|----------|-------|---------|------------|
| NODE_ENV | development | staging | production |
| API_URL | localhost:3000 | staging.api.com | api.com |
| DB_URL | local_db | staging_db | prod_db |
| LOG_LEVEL | debug | info | warn |
```

## Secret Rotation
```bash
# Generate new secret
NEW_SECRET=$(openssl rand -base64 32)

# Update in secret manager
doppler secrets set JWT_SECRET="$NEW_SECRET"

# Or update in Cloudflare
echo "$NEW_SECRET" | npx wrangler secret put JWT_SECRET

# Verify deployment picks up new secret
npx wrangler tail --format=json | grep -i "jwt"
```

## Emergency: Leaked Secret
```bash
# 1. Rotate immediately
./rotate-secret.sh JWT_SECRET

# 2. Revoke old credentials
# (platform-specific)

# 3. Deploy with new secret
npx wrangler deploy

# 4. Audit access logs
grep "JWT" /var/log/app.log | tail -100

# 5. Document incident
echo "$(date): JWT_SECRET rotated due to exposure" >> security-log.md
```

---
Last updated: 2026-01-27
