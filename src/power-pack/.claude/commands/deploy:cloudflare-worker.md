# Deploy to Cloudflare Workers
Quick deployment workflow for serverless functions.

## Auto-Trigger
**When:** "deploy to cloudflare", "ship worker", "publish function"

## Pre-Deployment Checklist
- [ ] Code compiles without errors
- [ ] Environment variables set in wrangler.toml
- [ ] Tests pass locally
- [ ] No secrets in code (use env vars)
- [ ] Rate limiting configured (if needed)

## Quick Deploy Commands

### 1. Initialize New Worker
```bash
npm create cloudflare@latest my-worker
cd my-worker
```

### 2. Configure wrangler.toml
```toml
name = "my-worker"
main = "src/index.ts"
compatibility_date = "2024-01-01"

[vars]
ENVIRONMENT = "production"

[[kv_namespaces]]
binding = "MY_KV"
id = "your-kv-id"
```

### 3. Deploy
```bash
# Preview (staging)
npx wrangler deploy --env staging

# Production
npx wrangler deploy
```

### 4. Verify
```bash
# Check logs
npx wrangler tail

# Test endpoint
curl https://my-worker.your-subdomain.workers.dev
```

## Your Projects Using Workers
| Project | Worker Name | Purpose |
|---------|-------------|---------|
| YOUR_PROJECT | ir-email-worker | Email processing |
| 08-telegram-support-bot | telegram-bot | Bot backend |
| 11-infra-llm-hub | llm-router | API routing |

## Rollback
```bash
# List deployments
npx wrangler deployments list

# Rollback to previous
npx wrangler rollback
```

## Secrets Management
```bash
# Add secret
npx wrangler secret put API_KEY

# List secrets
npx wrangler secret list
```

---
Last updated: 2026-01-27
