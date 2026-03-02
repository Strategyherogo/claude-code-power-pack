# Skill: asc-rejection
Read Apple App Store review rejection details from Mail.app when the ASC API won't expose them.

## Auto-Trigger
**When:** "rejection", "rejected app", "review rejection", "why was my app rejected", "resolution center"

## Why This Exists
App Store Connect's Resolution Center messages are **not accessible via API**. The `appStoreVersionSubmissions` and `reviewSubmissions` endpoints return 403 for state transitions. This skill extracts rejection details from Apple's notification emails synced to Mail.app via IMAP.

## Workflow

### 1. Find Rejection Emails
Query Mail.app's sqlite database for Apple review emails:
```bash
sqlite3 ~/Library/Mail/V10/MailData/Envelope\ Index "
SELECT m.ROWID, s.subject,
       datetime(m.date_sent + 978307200, 'unixepoch', 'localtime') as sent,
       a.address
FROM messages m
JOIN subjects s ON m.subject = s.ROWID
JOIN addresses a ON m.sender = a.ROWID
WHERE (s.subject LIKE '%issue%submission%'
       OR s.subject LIKE '%App Store%Review%'
       OR s.subject LIKE '%has been rejected%')
AND a.address LIKE '%apple%'
ORDER BY m.date_sent DESC
LIMIT 10;"
```

### 2. Locate the .emlx File
Use the ROWID from step 1 to find the actual email file:
```bash
# Search for .emlx file by ROWID
find ~/Library/Mail/V10/ -name "[ROWID].emlx" -type f 2>/dev/null
```

### 3. Parse Rejection Details
Extract the HTML body from the .emlx file and decode it:
```python
import sys, re, email, html
from pathlib import Path

emlx_path = sys.argv[1]
content = Path(emlx_path).read_text(errors='replace')

# .emlx format: first line is byte count, then RFC822 message, then Apple plist
lines = content.split('\n', 1)
msg = email.message_from_string(lines[1] if len(lines) > 1 else content)

# Extract body
for part in msg.walk():
    ct = part.get_content_type()
    if ct == 'text/html':
        body = part.get_payload(decode=True).decode('utf-8', errors='replace')
        # Strip HTML tags for readable output
        clean = re.sub(r'<[^>]+>', ' ', body)
        clean = re.sub(r'\s+', ' ', clean).strip()
        clean = html.unescape(clean)
        print(clean)
        break
    elif ct == 'text/plain':
        print(part.get_payload(decode=True).decode('utf-8', errors='replace'))
        break
```

### 4. Cross-Reference with ASC
After reading the rejection reason, check current app status:
```bash
# Use asc-mcp to check app version status
# apps_list → apps_get_details → app_versions_list
```

## Output Format
```
## Rejection: [App Name] — [Date]
**Guideline:** [number and name]
**Reason:** [extracted from email]
**Current Status:** [from ASC API]
**Action:** [what to fix]
```

## Notes
- Mail.app uses Apple's **Core Data epoch** (2001-01-01) — add `978307200` to convert to Unix epoch
- `.emlx` format: first line = byte count, then standard RFC822, then Apple plist metadata
- Emails arrive at the Apple ID email (check `jenyagoes@gmail.com` or forwarding rules)
- If Mail.app database is locked, close Mail.app first or use `sqlite3 -readonly`

---
Last updated: 2026-03-02
