# Skill: gws-search
Google Workspace search operations.

## Auto-Trigger
**When:** "google search", "drive search", "gmail search", "find in drive"

## Gmail Search Operators

### Basic Search
```
from:sender@email.com
to:recipient@email.com
subject:keyword
has:attachment
filename:pdf
larger:10M
older_than:1y
newer_than:1m
is:unread
is:starred
in:sent
in:trash
label:important
```

### Combined Searches
```
# Emails from person with attachments
from:boss@company.com has:attachment

# Large attachments from last month
has:attachment larger:5M newer_than:1m

# Unread from specific sender
from:client@company.com is:unread

# Invoices from this year
subject:invoice newer_than:1y filename:pdf

# Exclude promotional
-category:promotions from:@company.com
```

### Advanced Gmail
```
# Exact phrase
"exact phrase here"

# OR search
from:person1@email.com OR from:person2@email.com

# Exclude
-subject:newsletter

# Date range
after:2025/01/01 before:2025/12/31

# In any folder
in:anywhere subject:report

# Delivered to specific address (for aliases)
deliveredto:alias@domain.com
```

## Google Drive Search

### Basic Search
```
type:document
type:spreadsheet
type:presentation
type:pdf
type:image
type:video
type:folder
```

### Owner/Sharing
```
owner:me
owner:person@email.com
to:person@email.com (shared with)
from:person@email.com (shared by)
sharedwith:me
```

### Date Filters
```
before:2025-01-01
after:2024-01-01
```

### Combined Drive Search
```
# My spreadsheets modified recently
type:spreadsheet owner:me after:2025-01-01

# PDFs shared with me
type:pdf sharedwith:me

# Documents with keyword in title
title:report type:document

# Starred items
is:starred type:spreadsheet
```

## Google Calendar Search
```
# In search box:
[keyword]        # In title/description
from:[email]     # Events with attendee
```

## API Search (via MCP)

### Gmail API Search
```javascript
// Using Gmail MCP
const messages = await gmail.users.messages.list({
  userId: 'me',
  q: 'from:sender@email.com has:attachment newer_than:7d',
  maxResults: 50
});
```

### Drive API Search
```javascript
// Using GDrive MCP
const files = await drive.files.list({
  q: "mimeType='application/vnd.google-apps.spreadsheet' and modifiedTime > '2025-01-01'",
  pageSize: 100,
  fields: 'files(id, name, modifiedTime)'
});
```

## Common Search Tasks

### Find Recent Attachments
```
Gmail: has:attachment newer_than:7d
→ List all attachments received this week

Drive: after:2025-01-20 type:pdf owner:me
→ PDFs I created/uploaded recently
```

### Find Client Communications
```
Gmail: from:@clientdomain.com OR to:@clientdomain.com newer_than:30d
→ All recent client emails

Drive: sharedwith:client@email.com type:document
→ Documents shared with client
```

### Find Invoice/Receipt
```
Gmail: subject:(invoice OR receipt) has:attachment filename:pdf
→ Invoice emails with PDF attachments

Drive: title:invoice type:pdf after:2025-01-01
→ Invoice PDFs from this year
```

---
Last updated: 2026-01-27
