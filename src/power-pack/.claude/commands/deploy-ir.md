# Skill: Deploy IR Email Monitor
Specific deployment for IR Email Monitor project.

## Auto-Trigger
**When:** "deploy ir", "ir deploy", "email monitor deploy"

## Project Context
- **Name:** IR Email Monitor
- **Platform:** Cloudflare Workers
- **Database:** D1
- **Queue:** Cloudflare Queues

## Pre-Deploy Checklist
```
□ wrangler.toml configured
□ D1 migrations applied
□ Environment variables set
□ API keys valid (Google Workspace)
```

## Deploy Commands

### Development
```bash
cd YOUR_PROJECT
npm run dev
# or
npx wrangler dev
```

### Staging
```bash
npx wrangler deploy --env staging
```

### Production
```bash
# Run migrations first
npx wrangler d1 migrations apply ir-email-db --remote

# Deploy worker
npx wrangler deploy --env production
```

## Environment Variables Required
```bash
# Set via wrangler secret
npx wrangler secret put GOOGLE_CLIENT_ID
npx wrangler secret put GOOGLE_CLIENT_SECRET
npx wrangler secret put GOOGLE_REFRESH_TOKEN
npx wrangler secret put ALERT_EMAIL
```

## Health Check
```bash
# Check worker status
curl https://ir-email.workers.dev/health

# Check queue status
npx wrangler queues info ir-email-queue

# Check D1 status
npx wrangler d1 info ir-email-db
```

## Monitoring
```bash
# Live logs
npx wrangler tail ir-email-monitor

# Recent logs
npx wrangler tail ir-email-monitor --format=json | jq '.logs[]'
```

## Rollback
```bash
# Quick rollback
npx wrangler rollback

# Rollback to specific version
npx wrangler deployments list
npx wrangler rollback --version <id>
```

## Troubleshooting
```
Issue: Queue not processing
→ Check: npx wrangler queues info ir-email-queue
→ Fix: Ensure consumer is bound in wrangler.toml

Issue: D1 queries failing
→ Check: npx wrangler d1 execute ir-email-db --command "SELECT 1"
→ Fix: Run pending migrations

Issue: Auth failing
→ Check: Verify GOOGLE_* secrets are set
→ Fix: Refresh OAuth tokens
```

---
Last updated: 2026-01-27
