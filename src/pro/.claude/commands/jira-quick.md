# Skill: jira-quick
Quick Jira operations and issue management.

## Auto-Trigger
**When:** "jira", "ticket", "issue", "create ticket"

## Quick Issue Creation

### Bug Template
```
Summary: [Component] - [Brief description of issue]

Description:
## Steps to Reproduce
1. [step]
2. [step]
3. [step]

## Expected Behavior
[what should happen]

## Actual Behavior
[what happens instead]

## Environment
- Browser: [if applicable]
- OS: [os]
- Version: [app version]

## Screenshots/Logs
[attach or paste]

Labels: bug, [component], [priority]
Priority: [Highest/High/Medium/Low/Lowest]
```

### Feature Template
```
Summary: [Feature] - [Brief description]

Description:
## User Story
As a [user type], I want [feature] so that [benefit].

## Acceptance Criteria
- [ ] [criterion 1]
- [ ] [criterion 2]
- [ ] [criterion 3]

## Technical Notes
[implementation hints]

## Out of Scope
[what this doesn't include]

Labels: feature, [component]
Story Points: [estimate]
```

### Task Template
```
Summary: [Task] - [Brief description]

Description:
## Objective
[what needs to be done]

## Steps
- [ ] [subtask 1]
- [ ] [subtask 2]
- [ ] [subtask 3]

## Definition of Done
- [ ] [criterion]
- [ ] [criterion]

Labels: task, [component]
```

## JQL Quick Reference

### Common Queries
```jql
# My open issues
assignee = currentUser() AND status != Done

# Sprint issues
project = PROJ AND sprint in openSprints()

# Recently updated
project = PROJ AND updated >= -7d

# Blockers
priority = Highest AND status != Done

# Unassigned in backlog
assignee is EMPTY AND status = "To Do"

# Bugs created this week
issuetype = Bug AND created >= startOfWeek()

# Ready for review
status = "In Review" AND assignee = currentUser()
```

### Combined Queries
```jql
# High priority bugs in current sprint
issuetype = Bug AND priority in (Highest, High)
AND sprint in openSprints()

# My issues updated today
assignee = currentUser() AND updated >= startOfDay()

# Overdue issues
duedate < now() AND status != Done

# Issues with no estimate
"Story Points" is EMPTY AND issuetype = Story
```

## API Quick Reference (via Atlassian MCP)

### Create Issue
```javascript
// Via Atlassian MCP
POST /rest/api/3/issue
{
  "fields": {
    "project": {"key": "PROJ"},
    "summary": "Issue summary",
    "issuetype": {"name": "Bug"},
    "priority": {"name": "High"},
    "description": {
      "type": "doc",
      "version": 1,
      "content": [...]
    }
  }
}
```

### Update Issue
```javascript
PUT /rest/api/3/issue/{issueKey}
{
  "fields": {
    "status": {"name": "In Progress"},
    "assignee": {"accountId": "..."}
  }
}
```

### Add Comment
```javascript
POST /rest/api/3/issue/{issueKey}/comment
{
  "body": {
    "type": "doc",
    "version": 1,
    "content": [{"type": "paragraph", "content": [{"type": "text", "text": "Comment"}]}]
  }
}
```

## Status Transitions
```
To Do → In Progress → In Review → Done
       ↓
    Blocked
```

## Labels Convention
```
Component: frontend, backend, infra, mobile
Priority: urgent, p1, p2, p3
Type: bug, feature, tech-debt, documentation
Sprint: ready-for-sprint, needs-refinement
```

---
Last updated: 2026-01-27
