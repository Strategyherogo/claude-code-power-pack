# Skill: jira-comment-check
Check and analyze Jira comments.

## Auto-Trigger
**When:** "check comments", "jira comments", "issue updates"

## Comment Analysis

### Fetch Comments
```javascript
// Via Atlassian MCP
GET /rest/api/3/issue/{issueKey}/comment

// Response includes:
{
  "comments": [
    {
      "id": "...",
      "author": {...},
      "body": {...},
      "created": "...",
      "updated": "..."
    }
  ]
}
```

### Comment Summary Template
```markdown
## Comment Summary: [ISSUE-KEY]

### Recent Activity (Last 7 Days)
**Total Comments:** [X]
**Participants:** [list]

### Timeline
| Date | Author | Summary |
|------|--------|---------|
| [date] | [name] | [brief] |
| [date] | [name] | [brief] |

### Key Points
- [important point from comments]
- [important point from comments]

### Action Items Mentioned
- [ ] [action from comment]
- [ ] [action from comment]

### Open Questions
- [unanswered question]
- [unanswered question]

### Sentiment
- Overall: Positive / Neutral / Concerning
- Blockers mentioned: Yes / No
- Escalation needed: Yes / No
```

## Automated Comment Checks

### Stale Issue Detection
```jql
# Issues with no comments in 14 days
project = PROJ AND status not in (Done, Closed)
AND updated <= -14d

# Issues waiting for response
status = "Waiting for Customer" AND updated <= -7d
```

### Comment Analysis Script
```python
def analyze_comments(comments):
    analysis = {
        'total': len(comments),
        'authors': set(),
        'questions': [],
        'action_items': [],
        'blockers': []
    }

    for comment in comments:
        text = comment['body']['text']
        author = comment['author']['displayName']
        analysis['authors'].add(author)

        # Detect questions
        if '?' in text:
            analysis['questions'].append({
                'author': author,
                'text': text,
                'date': comment['created']
            })

        # Detect blockers
        if any(word in text.lower() for word in ['blocked', 'blocker', 'stuck']):
            analysis['blockers'].append({
                'author': author,
                'text': text
            })

    return analysis
```

### Comment Patterns to Flag
```
🔴 Red Flags:
- "blocked" / "blocker"
- "urgent" / "ASAP"
- "issue" / "problem" / "bug"
- Questions unanswered > 48h

🟡 Yellow Flags:
- "waiting" / "pending"
- "not sure" / "unclear"
- Multiple back-and-forth

🟢 Green Signals:
- "resolved" / "fixed"
- "approved" / "LGTM"
- "done" / "completed"
```

## Comment Templates

### Status Update
```
## Update [Date]

**Progress:**
- Completed: [what was done]
- In progress: [current work]

**Next Steps:**
- [next action]

**Blockers:**
- None / [blocker description]

**ETA:** [estimate]
```

### Question Response
```
@[person] re: [topic]

[Answer to their question]

Let me know if you need more details.
```

### Escalation Comment
```
⚠️ **Escalation**

**Issue:** [brief description]
**Impact:** [what's affected]
**Blocked since:** [date]
**Needed:** [what's required to unblock]

cc: @[manager] @[stakeholder]
```

### Handoff Comment
```
## Handoff to [Name]

**Context:**
[Brief background]

**Current Status:**
[Where things stand]

**What's Needed:**
- [action 1]
- [action 2]

**Key Files/Links:**
- [link 1]
- [link 2]

Let me know if you have questions!
```

---
Last updated: 2026-01-27
