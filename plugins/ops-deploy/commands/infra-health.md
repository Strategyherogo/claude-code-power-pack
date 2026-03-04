# Skill: infra-health
Check health of all deployed services (Cloudflare, Vercel, Railway, Docker/K8s).

## Auto-Trigger
**When:** "infra health", "service health", "is it running", "service status"

## Multi-Platform Health Check

### Cloudflare Workers
```bash
# List all workers
npx wrangler deployments list

# Health check each
for worker in $(npx wrangler list --json | jq -r '.[].name'); do
  echo "Checking $worker..."
  curl -s "https://$worker.workers.dev/health" || echo "No /health endpoint"
done
```

### Vercel
```bash
# List deployments
vercel ls

# Check status
vercel inspect <deployment-url>
```

### Railway
```bash
railway status
railway logs --latest
```

### Docker/Kubernetes
```bash
# List pods
kubectl get pods

# Check health
kubectl describe pod <pod-name>
kubectl logs <pod-name> --tail=50
```

## Comprehensive Health Report

### Template
```markdown
## Service Health Report
**Generated:** 2026-01-27 12:00 UTC

### Services Status

| Service | Status | Response Time | Last Deploy |
|---------|--------|---------------|-------------|
| ir-email-monitor | ✅ Healthy | 45ms | 2h ago |
| api-gateway | ✅ Healthy | 120ms | 1d ago |
| webhook-handler | ⚠️ Slow | 2.5s | 3d ago |

### Alerts
- ⚠️ webhook-handler response time > 1s threshold

### Actions Required
- [ ] Investigate webhook-handler slowdown
```

## Quick Health Script
```bash
#!/bin/bash
# health-check-all.sh

SERVICES=(
  "https://ir-email.workers.dev/health"
  "https://api.example.com/health"
  "https://webhook.example.com/health"
)

echo "🏥 Service Health Check"
echo "======================="

for url in "${SERVICES[@]}"; do
  response=$(curl -s -o /dev/null -w "%{http_code} %{time_total}s" "$url")
  status=$(echo $response | cut -d' ' -f1)
  time=$(echo $response | cut -d' ' -f2)

  if [ "$status" = "200" ]; then
    echo "✅ $url - $time"
  else
    echo "❌ $url - HTTP $status"
  fi
done
```

## Automated Monitoring Setup
```bash
# Cron job for health checks (every 5 min)
*/5 * * * * /path/to/health-check-all.sh >> /var/log/health.log 2>&1

# Or use Cloudflare Workers scheduled trigger
# Add to wrangler.toml:
# [triggers]
# crons = ["*/5 * * * *"]
```

---
Last updated: 2026-01-27
