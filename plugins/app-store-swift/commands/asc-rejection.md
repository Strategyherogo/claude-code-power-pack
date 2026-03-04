# Skill: asc-rejection
Read Apple App Store review rejection details from Mail.app and run pre-submission checks to prevent repeat rejections.

## Auto-Trigger
**When:** "rejection", "rejected app", "review rejection", "why was my app rejected", "resolution center", "pre-submission check"

## Why This Exists
App Store Connect's Resolution Center messages are **not accessible via API**. This skill extracts rejection details from Apple's notification emails synced to Mail.app via IMAP, and includes a pre-submission checklist based on real rejection patterns.

---

## Part 1: Extract Rejection Details

### 1. Find Rejection Emails
```bash
sqlite3 ~/Library/Mail/V10/MailData/Envelope\ Index "
SELECT m.ROWID, s.subject,
       datetime(m.date_sent + 978307200, 'unixepoch', 'localtime') as sent
FROM messages m
JOIN subjects s ON m.subject = s.ROWID
JOIN addresses a ON m.sender = a.ROWID
WHERE s.subject LIKE '%issue%submission%'
AND a.address LIKE '%apple%'
ORDER BY m.date_sent DESC
LIMIT 10;"
```

### 2. Locate and Parse .emlx
```bash
find ~/Library/Mail/V10/ -name "[ROWID].emlx" -type f 2>/dev/null
```

```python
import re, email, html
from pathlib import Path

content = Path(emlx_path).read_text(errors='replace')
lines = content.split('\n', 1)
msg = email.message_from_string(lines[1] if len(lines) > 1 else content)

for part in msg.walk():
    ct = part.get_content_type()
    if ct == 'text/html':
        body = part.get_payload(decode=True).decode('utf-8', errors='replace')
        sections = re.split(r'<h3>', body)
        for s in sections[1:]:
            clean = re.sub(r'<[^>]+>', ' ', s)
            clean = re.sub(r'\s+', ' ', clean).strip()
            clean = html.unescape(clean)
            if 'Guideline' in clean[:50]:
                print(clean[:600])
                print()
        break
```

### 3. Cross-Reference with ASC
```bash
# Use asc-mcp: apps_get_metadata, app_versions_list
```

### Output Format
```
## Rejection: [App Name] — [Date]
**Guideline:** [number and name]
**Reason:** [extracted from email]
**Current Status:** [from ASC API]
**Action:** [what to fix]
```

---

## Part 2: Pre-Submission Checklist

Run these checks BEFORE uploading a build. Based on real rejection history (11 rejections across 4 apps).

### Gate 1: Branding & IP (Guideline 4.1, 2.3.8)
```
□ grep -ri "THIRDPARTY" Sources/ — no third-party brand names in user-visible strings
□ strings <binary> | grep -i "THIRDPARTY" — only functional refs remain (Keychain, User-Agent)
□ nm -gU <binary> | grep -i "THIRDPARTY" — zero branded type names in symbol table
□ App icon contains NO third-party logos or text
□ ASC app name == CFBundleDisplayName == PRODUCT_NAME (no mismatch)
□ ASC keywords contain no third-party brand names
□ ASC description contains no third-party brand names (ALL locales)
```

### Gate 2: App Completeness (Guideline 2.1)
```
□ Menu bar icon responds to click on FIRST launch (test on clean install)
□ NSApp.activate(ignoringOtherApps: true) called in applicationDidFinishLaunching
□ No external dependencies for onboarding (no python3, no brew, no npm)
□ Shell commands use only macOS built-ins: security, grep, sed, awk, head, tail
□ Demo account or demo mode available for reviewer (add to App Review notes)
□ All IAP products submitted for review before submitting the app version
□ IAP visible/accessible in the app UI (reviewer must be able to find it)
□ All app features functional without signing in (or provide test credentials)
```

### Gate 3: Entitlements & Sandbox (Guideline 2.4.5)
```
□ Only minimum entitlements used — remove unused
□ Prefer user-selected.read-write over downloads.read-write
□ Entitlements match actual app capabilities (no extras from dev/debug)
□ usesNonExemptEncryption set on build (prevents processing delay)
```

### Gate 4: Metadata & URLs (Guideline 1.5)
```
□ Support URL is functional and loads without errors
□ Support URL has actual support content (not just a README)
□ Privacy Policy URL is functional (MUST be yourdomain.org — NEVER YOUR_COMPANY.com)
□ Screenshots match current app UI
□ App Review notes explain how to test the app
```

---

## Known Rejection Patterns (from history)

| Guideline | Times Hit | Common Cause | Prevention |
|-----------|-----------|-------------|------------|
| **2.1 App Completeness** | 6 | Menu bar not responding; missing IAP; Python dependency | Test on clean install; submit IAP first; no external deps |
| **4.1 Copycats** | 2 | Third-party brand in name/icon/binary/metadata | Full brand scrub: source + binary + ASC metadata |
| **2.3.8 Name Mismatch** | 1 | ASC name differs from installed name | Verify PRODUCT_NAME == ASC app name |
| **2.4.5(i) Entitlements** | 1 | Excessive sandbox entitlements | Use user-selected.read-write, remove unused |
| **1.5 Support URL** | 1 | GitHub repo was private/404 | Verify URL loads before submission |
| **2.1(b) Info Needed** | 1 | Reviewer can't find IAP | Ensure IAP is discoverable in UI |

## Menu Bar App Specific
macOS menu bar apps have been rejected 3 times for "icon doesn't respond when clicked":
- Ensure `NSPopover.show()` works immediately after `applicationDidFinishLaunching`
- Test: fresh install → click menu bar icon → popover must appear
- Common fix: add `NSApp.activate(ignoringOtherApps: true)` and small delay before setup

## Notes
- Mail.app uses Apple's **Core Data epoch** (2001-01-01) — add `978307200` to convert to Unix epoch
- `.emlx` format: first line = byte count, then standard RFC822, then Apple plist metadata
- Rejection emails use subject: "There's an issue with your [App] ([platform]) submission."
- Status emails use subject: "The status of your ([platform]) app, [App], is now..."
- ASC API cannot read Resolution Center — always use Mail.app forensics

---
Last updated: 2026-03-03
