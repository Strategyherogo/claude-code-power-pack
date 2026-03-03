# Skill: Alert Test
Test alerting and notification systems.

## Auto-Trigger
**When:** "test alert", "test notification", "verify alerts"

## Alert Channels

### Email (via Resend MCP)
```typescript
// Test email alert
await resend.emails.send({
  from: 'alerts@yourdomain.com',
  to: 'you@example.com',
  subject: '🧪 Test Alert',
  text: 'This is a test alert from your monitoring system.'
});
```

### Slack (via Slack MCP)
```bash
# Post test message
curl -X POST https://slack.com/api/chat.postMessage \
  -H "Authorization: Bearer $SLACK_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "channel": "#alerts",
    "text": "🧪 Test Alert: Monitoring system verification",
    "attachments": [{
      "color": "#36a64f",
      "text": "If you see this, alerts are working!"
    }]
  }'
```

### Telegram
```bash
curl -X POST "https://api.telegram.org/bot$BOT_TOKEN/sendMessage" \
  -d "chat_id=$CHAT_ID" \
  -d "text=🧪 Test Alert: Monitoring active"
```

### PagerDuty
```bash
curl -X POST https://events.pagerduty.com/v2/enqueue \
  -H "Content-Type: application/json" \
  -d '{
    "routing_key": "'$PAGERDUTY_KEY'",
    "event_action": "trigger",
    "payload": {
      "summary": "Test Alert - Please acknowledge",
      "severity": "info",
      "source": "test-script"
    }
  }'
```

## Alert Test Checklist
```
□ Email alerts delivered
□ Slack messages posted
□ Telegram notifications received
□ PagerDuty incident created
□ Webhook endpoints responding
□ SMS delivered (if configured)
```

## Alert Scenarios to Test

### 1. Service Down
```bash
# Simulate service failure
./alert-test.sh --type=service-down --service=ir-email
```

### 2. High Error Rate
```bash
# Simulate error spike
./alert-test.sh --type=error-rate --rate=10%
```

### 3. Performance Degradation
```bash
# Simulate slow responses
./alert-test.sh --type=slow-response --latency=5000ms
```

### 4. Security Alert
```bash
# Simulate security event
./alert-test.sh --type=security --event="unusual-login"
```

## Alert Test Script
```bash
#!/bin/bash
# alert-test.sh

echo "🧪 Alert System Test"
echo "===================="

# Test email
echo "Testing email..."
curl -X POST https://api.resend.com/emails \
  -H "Authorization: Bearer $RESEND_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"from":"test@domain.com","to":"you@email.com","subject":"Test","text":"Test"}'

# Test Slack
echo "Testing Slack..."
curl -X POST $SLACK_WEBHOOK_URL \
  -d '{"text":"🧪 Test alert"}'

# Test health endpoint
echo "Testing health endpoint..."
curl -s https://your-app.workers.dev/health

echo ""
echo "✅ Alert test complete - check your channels!"
```

## Verification Report
```markdown
## Alert Test Report
**Date:** 2026-01-27
**Tester:** Claude

### Results
| Channel | Status | Latency |
|---------|--------|---------|
| Email | ✅ Delivered | 2.3s |
| Slack | ✅ Posted | 0.8s |
| Telegram | ✅ Received | 1.1s |
| PagerDuty | ✅ Triggered | 1.5s |

### Next Test
Scheduled: 2026-02-03 (weekly)
```

---
Last updated: 2026-01-27
