# Skill: retro
Sprint/project retrospective facilitation.

## Auto-Trigger
**When:** "sprint retro", "project retro", "retrospective", "post-mortem", "what went well"

## Retrospective Formats

### Classic: Start/Stop/Continue
```markdown
## Retrospective: [Sprint/Project Name]
**Date:** [date]
**Participants:** [names]

### Start Doing
- [New practice to adopt]
- [New practice to adopt]

### Stop Doing
- [Practice to eliminate]
- [Practice to eliminate]

### Continue Doing
- [Practice that's working]
- [Practice that's working]

### Action Items
- [ ] [Action] - Owner: [name] - Due: [date]
- [ ] [Action] - Owner: [name] - Due: [date]
```

### 4Ls: Liked/Learned/Lacked/Longed For
```markdown
## 4Ls Retrospective: [Sprint/Project]
**Date:** [date]

### Liked (What went well)
- [Positive experience]
- [Positive experience]

### Learned (New insights)
- [Learning]
- [Learning]

### Lacked (What was missing)
- [Gap or resource needed]
- [Gap or resource needed]

### Longed For (Wishes for future)
- [Improvement wish]
- [Improvement wish]

### Actions
- [ ] [Action based on insights]
```

### Mad/Sad/Glad
```markdown
## Mad/Sad/Glad: [Sprint/Project]
**Date:** [date]

### Mad (Frustrations)
- [Frustration]
- [Frustration]

### Sad (Disappointments)
- [Disappointment]
- [Disappointment]

### Glad (Positives)
- [Win]
- [Win]

### Root Causes & Actions
| Issue | Root Cause | Action |
|-------|------------|--------|
| [Mad item] | [Why] | [Fix] |
```

### Sailboat
```markdown
## Sailboat Retro: [Sprint/Project]
**Date:** [date]

### ⛵ Wind (What pushed us forward)
- [Accelerator]
- [Accelerator]

### ⚓ Anchor (What held us back)
- [Blocker]
- [Blocker]

### 🪨 Rocks (Risks we avoided/hit)
- [Risk]
- [Risk]

### 🏝️ Island (Our goal - did we reach it?)
- Goal: [What we aimed for]
- Result: [What we achieved]

### Actions
- [ ] [Action]
```

## Incident Post-Mortem

```markdown
## Post-Mortem: [Incident Name]
**Date:** [incident date]
**Severity:** [P1/P2/P3/P4]
**Duration:** [X hours/minutes]
**Author:** [name]

### Summary
[1-2 sentence description of what happened]

### Timeline
| Time (UTC) | Event |
|------------|-------|
| HH:MM | [First sign of issue] |
| HH:MM | [Alert triggered] |
| HH:MM | [Investigation started] |
| HH:MM | [Root cause identified] |
| HH:MM | [Fix deployed] |
| HH:MM | [All clear confirmed] |

### Impact
- **Users affected:** [number/percentage]
- **Revenue impact:** [if applicable]
- **Data loss:** [none/details]

### Root Cause
[Detailed explanation of what caused the incident]

### What Went Well
- [Good response practice]
- [Good response practice]

### What Went Wrong
- [Issue in response]
- [Issue in response]

### Action Items
| Priority | Action | Owner | Due |
|----------|--------|-------|-----|
| P1 | [Prevent recurrence] | [name] | [date] |
| P2 | [Improve detection] | [name] | [date] |
| P3 | [Process improvement] | [name] | [date] |

### Lessons Learned
1. [Key takeaway]
2. [Key takeaway]
```

## Facilitation Tips

### Before
- [ ] Schedule 60-90 min
- [ ] Gather data (metrics, incidents, feedback)
- [ ] Choose format based on team mood
- [ ] Prepare virtual board (Miro/FigJam) or physical space

### During
- [ ] Set ground rules (no blame, be constructive)
- [ ] Timebox each section
- [ ] Ensure everyone speaks
- [ ] Vote on top issues to address
- [ ] Assign owners to actions

### After
- [ ] Share notes with team
- [ ] Add actions to backlog
- [ ] Follow up on actions next retro
- [ ] Track improvement over time

## Quick Commands
```
/retro start-stop-continue   # Classic format
/retro 4ls                   # 4Ls format
/retro sailboat              # Visual format
/retro post-mortem           # Incident review
/retro questions             # Discussion prompts
```

---
Last updated: 2026-01-29
