# Skill: time-track
Log and track billable hours.

## Auto-Trigger
**When:** "log time", "track time", "time entry", "billable hours", "timesheet"

## Quick Time Entry

### Format
```
[client] [hours] [description]
```

### Examples
```
TechConcepts 2.5 API integration meeting
ClientX 4 Feature development - auth module
ACME 1.5 Code review and feedback
```

## Time Log Template

### Daily Log
```markdown
## Time Log: [YYYY-MM-DD]

| Client | Project | Hours | Description | Billable |
|--------|---------|-------|-------------|----------|
| [name] | [proj]  | X.X   | [desc]      | Yes/No   |

**Total:** X.X hours
**Billable:** X.X hours
```

### Weekly Summary
```markdown
## Week of [date]

### By Client
| Client | Hours | Amount |
|--------|-------|--------|
| ClientA | XX | €X,XXX |
| ClientB | XX | €X,XXX |
| **Total** | **XX** | **€X,XXX** |

### By Day
| Day | Hours | Notes |
|-----|-------|-------|
| Mon | X.X | |
| Tue | X.X | |
| Wed | X.X | |
| Thu | X.X | |
| Fri | X.X | |
```

## Commands

### Log Time
```
/time-track log [client] [hours] [description]
```

### View Today
```
/time-track today
```

### View Week
```
/time-track week
```

### Generate Invoice Data
```
/time-track invoice [client] [date-range]
```

## Storage

### File Structure
```
3. Resources/00-financial/timesheets/
├── 2026/
│   ├── 01-january.md
│   ├── 02-february.md
│   └── ...
└── clients/
    ├── client-a.md
    └── client-b.md
```

### Monthly File Format
```markdown
# Timesheet: January 2026

## Week 1 (Jan 1-5)
| Date | Client | Hours | Description |
|------|--------|-------|-------------|
| 01-02 | ClientA | 4.0 | Sprint planning |
| 01-03 | ClientB | 6.0 | Feature dev |

## Week 2 (Jan 6-12)
...

## Summary
- Total hours: XX
- Billable hours: XX
- By client:
  - ClientA: XX hours
  - ClientB: XX hours
```

## Rates Reference
| Client | Rate | Currency | Notes |
|--------|------|----------|-------|
| Default | €175 | EUR | Standard consulting |
| [Client] | €XXX | EUR | Custom rate |

## Integration Points
- **Invoice skill:** Pull hours for billing
- **Weekly review:** Summarize time spent
- **Project tracking:** Update project progress

## Tips
- Log time same day (more accurate)
- Round to nearest 0.25 hours
- Include enough detail for invoicing
- Mark non-billable time (internal, admin)

---
Last updated: 2026-01-29
