# Skill: dedup-check
Check for and handle duplicate issues/items.

## Auto-Trigger
**When:** "duplicate", "dedup", "similar issues", "already exists"

## Duplicate Detection

### Jira Duplicate Search
```jql
# Find similar issues by summary keywords
project = PROJ AND summary ~ "keyword1" AND summary ~ "keyword2"

# Find issues with similar labels
project = PROJ AND labels in (label1, label2) AND status != Done

# Recent similar issues
project = PROJ AND summary ~ "error" AND created >= -30d

# Same reporter, similar topic
project = PROJ AND reporter = user AND summary ~ "topic"
```

### Duplicate Detection Patterns
```markdown
## Duplicate Indicators

### High Confidence
- Identical summary text
- Same error message in description
- Same steps to reproduce
- Same reporter within 24h

### Medium Confidence
- Similar keywords in summary
- Same component + similar description
- Related issues linked
- Same time period + similar topic

### Low Confidence
- Same component only
- Similar labels only
- Same priority only
```

## Dedup Workflow

### Step 1: Search
```markdown
Search for:
- [ ] Exact summary match
- [ ] Keyword match (main terms)
- [ ] Related component issues
- [ ] Recent issues (last 30 days)
- [ ] Issues from same reporter
```

### Step 2: Compare
```markdown
## Potential Duplicate Comparison

| Field | Current Issue | Potential Dup |
|-------|--------------|---------------|
| Key | NEW-123 | OLD-456 |
| Summary | [text] | [text] |
| Description | [excerpt] | [excerpt] |
| Reporter | [name] | [name] |
| Created | [date] | [date] |
| Status | [status] | [status] |

**Similarity Score:** High / Medium / Low
**Recommendation:** Link / Merge / Separate
```

### Step 3: Handle

#### If Duplicate → Link and Close
```
1. Add link: "duplicates" [original-issue]
2. Add comment: "Closing as duplicate of [KEY]. See linked issue for updates."
3. Change status: Closed/Won't Fix
4. Update original with any new info from duplicate
```

#### If Related → Link Only
```
1. Add link: "relates to" [related-issue]
2. Add comment: "Related to [KEY] - [brief explanation]"
3. Keep both open if distinct
```

#### If Not Duplicate → Document
```
1. Add comment explaining difference
2. Add label: "not-duplicate"
3. Proceed with normal workflow
```

## Dedup Report Template
```markdown
## Duplicate Analysis Report
**Date:** [date]
**Project:** [project]
**Period:** [date range]

### Summary
- Issues analyzed: [X]
- Duplicates found: [X]
- Duplicate rate: [X]%

### Duplicates Identified

| Original | Duplicate(s) | Action Taken |
|----------|--------------|--------------|
| KEY-100 | KEY-150, KEY-175 | Linked and closed |
| KEY-200 | KEY-220 | Merged |

### Common Duplicate Patterns
1. [Pattern 1] - [frequency]
2. [Pattern 2] - [frequency]

### Recommendations
- [Suggestion to reduce duplicates]
- [Process improvement]
```

## Automated Dedup Check
```python
def find_potential_duplicates(issue, all_issues, threshold=0.8):
    """Find issues similar to the given issue."""
    from difflib import SequenceMatcher

    duplicates = []
    issue_summary = issue['summary'].lower()

    for other in all_issues:
        if other['key'] == issue['key']:
            continue

        other_summary = other['summary'].lower()
        similarity = SequenceMatcher(None, issue_summary, other_summary).ratio()

        if similarity >= threshold:
            duplicates.append({
                'key': other['key'],
                'summary': other['summary'],
                'similarity': similarity,
                'status': other['status']
            })

    return sorted(duplicates, key=lambda x: x['similarity'], reverse=True)
```

---
Last updated: 2026-01-27
