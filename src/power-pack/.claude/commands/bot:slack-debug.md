# Slack Bot Debugging
Troubleshoot and test Slack bots and integrations.

## Auto-Trigger
**When:** Working on 06-slack-jira-bot, 07-slack-autofill-bot, or Slack integration

## Quick Setup

### 1. Create Slack App
1. Go to https://api.slack.com/apps
2. "Create New App" → "From scratch"
3. Add Bot Token Scopes under OAuth & Permissions

### 2. Required Scopes
```
# Basic bot functionality
chat:write
channels:read
channels:history
users:read

# For slash commands
commands

# For app mentions
app_mentions:read

# For reactions
reactions:read
reactions:write
```

### 3. Test Locally with ngrok
```bash
# Start ngrok
ngrok http 3000

# Copy HTTPS URL to Slack app settings
# Event Subscriptions → Request URL
```

### 4. Common Issues

#### "not_authed" or "invalid_auth"
```bash
# Check token
echo $SLACK_BOT_TOKEN
# Should start with xoxb-

# Test token
curl -X POST "https://slack.com/api/auth.test" \
  -H "Authorization: Bearer $SLACK_BOT_TOKEN"
```

#### Bot not receiving messages
1. Check Event Subscriptions enabled
2. Verify Request URL is correct (ngrok for local)
3. Check bot is in the channel (`/invite @botname`)

#### "channel_not_found"
```bash
# List channels bot can see
curl -X GET "https://slack.com/api/conversations.list" \
  -H "Authorization: Bearer $SLACK_BOT_TOKEN"
```

### 5. Debugging with Bolt
```javascript
// Enable debug logging
const app = new App({
  token: process.env.SLACK_BOT_TOKEN,
  signingSecret: process.env.SLACK_SIGNING_SECRET,
  logLevel: LogLevel.DEBUG
});

// Log all events
app.use(async ({ next, logger, body }) => {
  logger.info('Received event:', body.type);
  await next();
});
```

### 6. Testing Checklist
- [ ] Bot responds to mentions
- [ ] Slash commands work
- [ ] Messages post to correct channels
- [ ] Error handling in place
- [ ] Rate limiting respected

## Your Slack Projects
- **06-slack-jira-bot** - Jira integration
- **07-slack-autofill-bot** - Form automation

## Socket Mode (No Public URL Needed)
```javascript
const app = new App({
  token: process.env.SLACK_BOT_TOKEN,
  appToken: process.env.SLACK_APP_TOKEN,
  socketMode: true
});
```

---
Last updated: 2026-01-27
