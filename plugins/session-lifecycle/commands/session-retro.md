# Skill: session-retro
Analyze completed session, extract lessons, and suggest system improvements.

## Auto-Trigger
**When:** "session retro", "session review", "what did we learn", "lessons learned"

## Overview
This skill performs a retrospective analysis of the current session to:
- Extract patterns and lessons
- Identify inefficiencies or repeated struggles
- Suggest improvements to skills, aliases, or system config
- Record learnings for future sessions

## Session Analysis Framework

### 1. Session Summary
```markdown
## Session: [Date]
**Duration:** [approximate]
**Primary Task:** [main goal]
**Outcome:** [completed/partial/blocked]

### What Was Accomplished
- [accomplishment 1]
- [accomplishment 2]

### Obstacles Encountered
- [obstacle 1]: [how resolved]
- [obstacle 2]: [how resolved]
```

### 2. Pattern Analysis

#### Efficiency Patterns
```
□ Were there repeated manual steps that could be automated?
□ Did we search for the same information multiple times?
□ Were there config issues that blocked progress?
□ Did we have to look up the same commands repeatedly?
```

#### Skills Used vs Needed
```
Skills that helped:
- /[skill]: [how it helped]

Skills that were missing:
- [need]: [what would have helped]

Skills that could be improved:
- /[skill]: [suggested improvement]
```

#### Tool/MCP Analysis
```
MCP tools used:
- [tool]: [success/failure]

MCP tools that would have helped:
- [tool]: [why]

Config issues encountered:
- [issue]: [fix applied]
```

### 3. Lessons Learned

#### Technical Lessons
```markdown
## Lesson: [Title]
**Context:** [when this applies]
**Learning:** [what we learned]
**Action:** [what to do next time]
```

#### Process Lessons
```markdown
## Lesson: [Title]
**Pattern:** [what we noticed]
**Improvement:** [better approach]
```

### 4. System Improvement Suggestions

#### New Skill Candidates
```markdown
| Need | Trigger | Purpose |
|------|---------|---------|
| [gap identified] | "[keyword]" | [what it would do] |
```

#### Alias Improvements
```bash
# Current approach was inefficient:
[old command or manual process]

# Suggested alias:
alias [name]='[improved command]'
```

#### Config Improvements
```markdown
| File | Change | Reason |
|------|--------|--------|
| [config file] | [what to change] | [why] |
```

#### Skill Enhancements
```markdown
| Skill | Enhancement | Priority |
|-------|-------------|----------|
| /[skill] | [improvement] | [high/medium/low] |
```

## Recording Lessons

### Lessons File Location
```
~/.claude/lessons/[YYYY-MM].md
```

### Lesson Entry Format
```markdown
## [Date] - [Topic]
**Session:** [brief context]
**Lesson:** [what was learned]
**Applied:** □ Yes / □ Pending
**Improvement:** [specific action taken or planned]
```

### Quick Lesson Template
```markdown
### [Date]: [One-line lesson title]
- **Context:** [situation]
- **Problem:** [what went wrong or was inefficient]
- **Solution:** [what worked]
- **Future:** [how to prevent/improve]
```

## Automated Analysis Checklist

### Session Review
```
□ What was the main goal?
□ Was it achieved?
□ What took longer than expected?
□ What was surprisingly easy?
□ Any "aha" moments?
```

### Efficiency Review
```
□ Commands repeated 3+ times → alias candidate
□ Same search pattern used → skill candidate
□ Config fixed mid-session → document the fix
□ External tool issue → add to troubleshooting guide
□ Missing MCP tool → research and add
```

### Knowledge Capture
```
□ New technique learned → add to relevant skill
□ Gotcha discovered → add warning to skill
□ Better approach found → update existing skill
□ Workaround needed → create troubleshooting entry
```

## Output: Session Retro Report

```markdown
# Session Retrospective: [Date]

## Summary
[1-2 sentences on what happened]

## Wins
- [what went well]

## Friction Points
- [what was harder than it should be]

## Lessons Recorded
1. [lesson 1]
2. [lesson 2]

## System Improvements
### Immediate (do now)
- [ ] [improvement 1]

### Planned (add to backlog)
- [ ] [improvement 2]

### Ideas (consider later)
- [ ] [improvement 3]

## Files Updated
- [file]: [what was added/changed]
```

## Integration with Other Skills

### Related Skills to Invoke
```
/reflect - For deeper analysis of decisions
/organize - If session revealed organizational issues
/workspace-audit - If system-wide improvements needed
/cs - To save context before closing
```

### Cross-Reference
After retro, consider updating:
- CLAUDE.md - If new triggers identified
- MASTER.md - If new skill mappings needed
- Relevant skill files - With lessons learned

---
Last updated: 2026-01-29
