# Skill: Quick Deploy
Rapid deployment with minimal verification.

## Auto-Trigger
**When:** "quick deploy", "ship it", "just deploy", "push to prod"

## ⚠️ Gate: Soft Confirmation
Before quick deploy, confirm:
- [ ] Tests passed recently
- [ ] No critical changes since last deploy
- [ ] Rollback plan exists

## Quick Deploy Commands

### Cloudflare Workers
```bash
# Deploy immediately
npx wrangler deploy

# Deploy specific environment
npx wrangler deploy --env production
```

### Vercel
```bash
# Production deploy
vercel --prod

# Preview deploy
vercel
```

### Railway
```bash
railway up
```

### Fly.io
```bash
flyctl deploy
```

### Docker/Container
```bash
docker build -t myapp:latest .
docker push myapp:latest
kubectl rollout restart deployment/myapp
```

## Post-Deploy Checklist
```
□ Check deployment URL responds
□ Run smoke test
□ Monitor logs for 2 minutes
□ Verify critical functionality
```

## Rollback Commands
```bash
# Cloudflare
npx wrangler rollback

# Vercel
vercel rollback

# Kubernetes
kubectl rollout undo deployment/myapp
```

---
Last updated: 2026-01-27
