# Skill: gws-email-report
Generate reports from Google Workspace email data.

## Auto-Trigger
**When:** "email report", "email analysis", "inbox report", "email stats"

## Report Types

### Volume Report
```markdown
## Email Volume Report
**Period:** [start] to [end]
**Account:** [email]

### Summary
- Total received: [X]
- Total sent: [X]
- Avg daily received: [X]
- Avg daily sent: [X]

### By Day
| Day | Received | Sent |
|-----|----------|------|
| Mon | [X] | [X] |
| Tue | [X] | [X] |
| ... | ... | ... |

### By Hour (Received)
| Hour | Count |
|------|-------|
| 9 AM | [X] |
| 10 AM | [X] |
| ... | ... |

### Top Senders
| Sender | Count |
|--------|-------|
| [email] | [X] |
| [email] | [X] |
| ... | ... |
```

### Response Time Report
```markdown
## Response Time Analysis
**Period:** [start] to [end]

### Summary
- Total threads analyzed: [X]
- Threads with response: [X]
- Avg response time: [X hours]
- Median response time: [X hours]

### By Category
| Category | Avg Response | Threads |
|----------|--------------|---------|
| Client | [X hours] | [X] |
| Internal | [X hours] | [X] |
| External | [X hours] | [X] |

### Response Time Distribution
- <1 hour: [X]%
- 1-4 hours: [X]%
- 4-24 hours: [X]%
- >24 hours: [X]%

### Outliers (>48h response)
- [Thread subject] - [X hours]
- [Thread subject] - [X hours]
```

### Sender Analysis Report
```markdown
## Sender Analysis Report
**Period:** [start] to [end]

### Top 20 Senders
| Rank | Sender | Count | Avg Thread Length |
|------|--------|-------|-------------------|
| 1 | [email] | [X] | [X] |
| 2 | [email] | [X] | [X] |
| ... | ... | ... | ... |

### By Domain
| Domain | Count | % of Total |
|--------|-------|------------|
| @company.com | [X] | [X]% |
| @client.com | [X] | [X]% |
| ... | ... | ... |

### Communication Patterns
- Regular correspondents (weekly+): [X]
- Occasional (monthly): [X]
- One-time: [X]
```

### Attachment Report
```markdown
## Attachment Analysis
**Period:** [start] to [end]

### Summary
- Emails with attachments: [X]
- Total attachments: [X]
- Total size: [X GB]

### By Type
| Type | Count | Size |
|------|-------|------|
| PDF | [X] | [X MB] |
| XLSX | [X] | [X MB] |
| DOCX | [X] | [X MB] |
| Images | [X] | [X MB] |

### Largest Attachments
| File | Size | From | Date |
|------|------|------|------|
| [name] | [X MB] | [email] | [date] |
| ... | ... | ... | ... |
```

## Report Generation Script
```python
# Using Gmail API
from googleapiclient.discovery import build
from collections import Counter
from datetime import datetime, timedelta

def generate_email_report(service, days=30):
    # Calculate date range
    after_date = (datetime.now() - timedelta(days=days)).strftime('%Y/%m/%d')

    # Search for emails
    query = f'after:{after_date}'
    results = service.users().messages().list(
        userId='me', q=query, maxResults=500
    ).execute()

    messages = results.get('messages', [])

    # Analyze
    senders = Counter()
    dates = Counter()

    for msg in messages:
        full_msg = service.users().messages().get(
            userId='me', id=msg['id'], format='metadata'
        ).execute()

        # Extract sender
        headers = {h['name']: h['value'] for h in full_msg['payload']['headers']}
        sender = headers.get('From', 'Unknown')
        senders[sender] += 1

        # Extract date
        date = headers.get('Date', '')[:10]
        dates[date] += 1

    return {
        'total': len(messages),
        'top_senders': senders.most_common(20),
        'by_date': dict(dates)
    }
```

## Scheduled Reports
```bash
# Daily summary (cron)
0 8 * * * /path/to/email-report.py --period=1d --type=summary

# Weekly detailed (cron)
0 9 * * 1 /path/to/email-report.py --period=7d --type=full

# Monthly analytics
0 9 1 * * /path/to/email-report.py --period=30d --type=analytics
```

---
Last updated: 2026-01-27
