# Telegram Bot Debugging
Troubleshoot and test Telegram bots.

## Auto-Trigger
**When:** Working on 08-telegram-support-bot or Telegram integration

## Quick Setup

### 1. Get Bot Token
1. Message @BotFather on Telegram
2. `/newbot` or `/token` for existing bot
3. Copy token: `123456789:ABCdefGHIjklMNOpqrSTUvwxYZ`

### 2. Test Bot Locally
```bash
# Set token
export TELEGRAM_BOT_TOKEN="your-token"

# Run bot
python bot.py
# or
node bot.js
```

### 3. Webhook vs Polling

**Polling (Development):**
```python
# Python (python-telegram-bot)
from telegram.ext import Application
app = Application.builder().token(TOKEN).build()
app.run_polling()
```

**Webhook (Production):**
```python
# Set webhook
import requests
url = f"https://api.telegram.org/bot{TOKEN}/setWebhook"
requests.post(url, json={"url": "https://your-domain.com/webhook"})
```

### 4. Common Issues

#### Bot not responding
```bash
# Check bot info
curl "https://api.telegram.org/bot<TOKEN>/getMe"

# Check webhook status
curl "https://api.telegram.org/bot<TOKEN>/getWebhookInfo"

# Delete webhook (switch to polling)
curl "https://api.telegram.org/bot<TOKEN>/deleteWebhook"
```

#### "Conflict: terminated by other getUpdates"
- Another instance is running
- Kill other processes or use webhook

#### Message not received
```bash
# Get recent updates
curl "https://api.telegram.org/bot<TOKEN>/getUpdates"
```

### 5. Debugging Commands
```python
# Add logging
import logging
logging.basicConfig(level=logging.DEBUG)

# Echo handler for testing
async def echo(update, context):
    print(f"Received: {update.message.text}")
    await update.message.reply_text(update.message.text)
```

### 6. Testing Checklist
- [ ] Bot responds to /start
- [ ] Bot handles text messages
- [ ] Bot handles errors gracefully
- [ ] Webhook SSL certificate valid
- [ ] Rate limiting in place

## Your Telegram Projects
- **08-telegram-support-bot** - Customer support automation

## Deployment
```bash
# Deploy to Cloudflare Workers
npx wrangler deploy

# Or Railway
railway up
```

---
Last updated: 2026-01-27
