# Skill: Log Errors
Analyze and categorize error logs.

## Auto-Trigger
**When:** "errors", "logs", "what went wrong", "failures", "exceptions"

## Log Sources

### Cloudflare Workers
```bash
# Real-time logs
npx wrangler tail --format=pretty

# Filter errors only
npx wrangler tail --format=json | jq 'select(.level == "error")'

# Search historical (requires Logpush)
# Check Cloudflare dashboard → Workers → Logs
```

### Node.js Applications
```bash
# PM2 logs
pm2 logs --err

# Docker logs
docker logs <container> 2>&1 | grep -i error

# Systemd
journalctl -u myapp -p err
```

### Vercel
```bash
vercel logs <deployment-url> --since 1h
```

## Error Categorization

### By Type
```
□ Network Errors (timeout, connection refused)
□ Auth Errors (401, 403, token expired)
□ Validation Errors (400, malformed input)
□ Server Errors (500, unhandled exception)
□ Resource Errors (404, not found)
□ Rate Limit Errors (429, too many requests)
```

### By Severity
```
🔴 CRITICAL: Service down, data loss risk
🟠 HIGH: Feature broken, many users affected
🟡 MEDIUM: Degraded experience, workaround exists
🟢 LOW: Minor issue, cosmetic
```

## Error Analysis Template
```markdown
## Error Analysis Report
**Period:** Last 24 hours
**Generated:** 2026-01-27

### Summary
- Total errors: 47
- Unique error types: 5
- Services affected: 2

### Top Errors

#### 1. TimeoutError (28 occurrences)
**Service:** ir-email-monitor
**Message:** "Request timed out after 30000ms"
**First seen:** 2026-01-27 08:15
**Last seen:** 2026-01-27 11:45
**Pattern:** Spikes during 08:00-09:00
**Root cause:** Google API rate limiting during peak
**Recommended fix:** Implement exponential backoff

#### 2. AuthenticationError (12 occurrences)
**Service:** webhook-handler
**Message:** "Invalid or expired token"
**Pattern:** All from same IP
**Root cause:** Bot attempting invalid auth
**Recommended fix:** Rate limit by IP

### Error Rate Trend
| Hour | Errors | Rate |
|------|--------|------|
| 08:00 | 15 | 2.5% |
| 09:00 | 12 | 2.0% |
| 10:00 | 8 | 1.3% |
| 11:00 | 7 | 1.2% |

### Actions
- [ ] Implement exponential backoff for Google API
- [ ] Add IP-based rate limiting
- [ ] Set up alerting for error rate > 5%
```

## Quick Error Commands
```bash
# Count errors by type
grep -h "Error" *.log | sort | uniq -c | sort -rn

# Find error patterns
grep -E "(Error|Exception|Failed)" app.log | \
  sed 's/[0-9]//g' | sort | uniq -c | sort -rn | head -10

# Time-based error distribution
grep "Error" app.log | cut -d' ' -f1-2 | cut -d':' -f1-2 | \
  sort | uniq -c
```

---
Last updated: 2026-01-27
