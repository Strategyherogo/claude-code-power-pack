# Skill: standup
Generate daily standup summary.

## Auto-Trigger
**When:** "standup", "daily standup", "what did I do", "daily summary", "scrum"

## Standup Format

### Quick Standup
```markdown
## Standup: [YYYY-MM-DD]

**Yesterday:**
- [completed task 1]
- [completed task 2]

**Today:**
- [planned task 1]
- [planned task 2]

**Blockers:**
- [blocker or "None"]
```

### Detailed Standup
```markdown
## Standup: [YYYY-MM-DD]

### Completed (Yesterday)
- [x] [Task 1] - [brief outcome]
- [x] [Task 2] - [brief outcome]

### In Progress
- [ ] [Task 1] - [status/progress %]
- [ ] [Task 2] - [status/progress %]

### Planned (Today)
1. [Priority task 1]
2. [Priority task 2]
3. [Priority task 3]

### Blockers
- [ ] [Blocker 1] - waiting on [person/thing]

### Notes
[Any context, decisions, or FYIs]
```

## Auto-Generate Standup

### From Git (What I coded)
```bash
# Commits from yesterday
git log --oneline --since="yesterday" --author="$(git config user.name)"

# Files changed
git diff --stat HEAD~5
```

### From Context Saves
Check recent `/cs` saves for context.

### From Calendar
Check calendar for meetings attended.

## Standup by Project

### Client Work
```markdown
## [Client Name] Standup

**Progress:**
- Feature X: 80% complete
- Bug Y: Fixed and deployed

**Next:**
- Complete feature X testing
- Start feature Z

**Client comms:**
- Sent update email
- Meeting scheduled Thursday
```

### Internal/D&S
```markdown
## D&S Standup

**Shipped:**
- [App/Feature] v1.2.3

**Working on:**
- [Current focus]

**Ideas:**
- [Backlog item to consider]
```

## Weekly Standup Roll-up
```markdown
## Week of [date] Summary

### Shipped
- [Major accomplishment 1]
- [Major accomplishment 2]

### Progress
- [Project A]: X% → Y%
- [Project B]: Started

### Learnings
- [Key learning or decision]

### Next Week Focus
1. [Top priority]
2. [Second priority]
```

## Slash Command Usage
```
/standup              # Generate today's standup
/standup yesterday    # What I did yesterday
/standup week         # Weekly summary
/standup [client]     # Client-specific standup
```

## Tips
- Do standup first thing (5 min max)
- Focus on outcomes, not activities
- Be honest about blockers
- Keep it brief for async teams

---
Last updated: 2026-01-29
