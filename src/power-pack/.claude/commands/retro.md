# Skill: retro
Sprint/project retrospective facilitation with historical analysis.

## Auto-Trigger
**When:** "sprint retro", "project retro", "retrospective", "post-mortem", "what went well"

## Usage Modes

### 1. Template Mode (Default)
Provide retro templates and facilitation guide for team meetings.

### 2. Analyze Mode (Data-Driven)
Analyze historical data from journals, sessions, and iterations.

**Triggers:**
- "analyze last week/month"
- "retro with data"
- "analyze sessions since [date]"
- "what patterns from journals"

**Data Sources:**
- `.claude/lessons/` — Monthly lessons learned
- `.claude/context-saves/` — Session saves and handoffs
- `3. Resources/02-iterations/lessons/` — Iteration-specific lessons
- `3. Resources/05-work-journals/` — Daily work journals
- `1. Projects/*/journals/` — Project-specific journals

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

## Analyze Mode: Data-Driven Retrospective

When user requests analysis of historical data, follow this workflow:

### Step 1: Define Scope
Ask the user (if not specified):
- **Time range**: Last week? Month? Since specific date?
- **Focus area**: All work? Specific project? Specific topic?
- **Data sources**: All sources? Specific journals/sessions?

### Step 2: Data Collection (Parallel Reads)

```bash
# Get all relevant files based on scope
# Example for last month:

# Lessons
cat .claude/lessons/2026-02.md

# Recent sessions (last 20)
ls -t .claude/context-saves/*.md | head -20 | xargs cat

# Work journals for date range
find "3. Resources/05-work-journals" -name "*.md" -newermt "2026-02-01" -type f -exec cat {} \;

# Iteration lessons
cat "3. Resources/02-iterations/lessons"/*.md

# Project journals (if specific project)
cat "1. Projects/[PROJECT]/journals"/*.md
```

### Step 3: Pattern Extraction

Analyze collected data for:

#### Recurring Themes
```
□ What topics appear in multiple entries?
□ What problems were solved multiple times?
□ What skills/tools were frequently mentioned?
□ What pain points repeated across sessions?
```

#### Temporal Patterns
```
□ Did efficiency improve over time?
□ What patterns changed week-to-week?
□ When did major shifts happen?
□ What correlates with productive periods?
```

#### Lesson Application
```
□ Which recorded lessons were applied?
□ Which lessons remain pending?
□ Did applied lessons actually help?
□ What new lessons emerged?
```

#### Tool/Skill Effectiveness
```
□ Which skills were most useful?
□ Which skills went unused?
□ What tools had learning curves?
□ What new capabilities were discovered?
```

### Step 4: Synthesize Findings

Generate retro using chosen format (4Ls, Sailboat, etc.) but populate with:
- **Actual data points** from journals/sessions
- **Quantitative metrics** (session counts, frequency, timelines)
- **Direct quotes** from lesson entries
- **Pattern evidence** (X happened Y times over Z period)

### Step 5: Actionable Insights

From analysis, identify:
```markdown
## High-Impact Actions
| Action | Evidence | Expected Impact |
|--------|----------|-----------------|
| [action] | [data showing need] | [how it helps] |

## System Improvements
| Type | Change | Source |
|------|--------|--------|
| Skill | [enhancement] | [lessons #1, #3, #5] |
| Alias | [new alias] | [repeated pattern in 8 sessions] |
| Config | [setting] | [friction in sessions #12-15] |

## Pending Lessons
| Lesson | Status | Next Step |
|--------|--------|-----------|
| [lesson] | Recorded, not applied | [specific action] |
```

## Example Output: Data-Driven Retro

```markdown
## Retrospective: February 2026 (Data Analysis)
**Period:** Feb 1-27, 2026
**Sessions Analyzed:** 23
**Lessons Recorded:** 12
**Journals Reviewed:** 18

### Liked (Data-Backed)
- **Anti-friction system**: Mentioned positively in 8/23 sessions
- **Hook automation**: Reduced manual steps (4 lessons cite this)
- **MCP integrations**: 5 new servers added, all actively used

### Learned (From Lessons)
1. Hook blind spot (session #14): Hooks don't fire on denied tools
   - Action taken: Moved reminders to CLAUDE.md
2. Bidirectional fallbacks (session #15): Any tool → any working tool
   - Applied in 3 subsequent sessions
3. Documentation structure (session #15): README + cross-refs = discoverable
   - Template created for future doc clusters

### Lacked (Recurring Friction)
- Glob/Grep spawn errors: 4 occurrences across 3 sessions
- Tool permission confusion: Retry loops happened 6 times before anti-friction
- cs script vs /cs skill: Clarification requested 3 times

### Longed For (Emerging Needs)
- Automated retro every 5 sessions (this analysis took 2 sessions to create)
- Hook validation in health checks (format errors blocked 2 sessions)
- Visual pattern tracking (hard to spot trends across 23 sessions manually)

### Actions (Evidence-Based)
- [ ] Fix Glob/Grep spawn issue (P1 - blocks 17% of sessions)
- [ ] Add cs vs /cs clarification to skill (P2 - requested 3x)
- [ ] Create /check-hooks validation skill (P2 - prevented 2 errors)
- [ ] Build session analytics dashboard (P3 - enable trend spotting)
```

## Quick Commands
```
/retro                       # Template mode (facilitation guide)
/retro analyze               # Analyze mode (historical data)
/retro analyze --range 7d    # Last 7 days
/retro analyze --range 1m    # Last month
/retro analyze --project X   # Specific project
/retro 4ls                   # Use 4Ls format
/retro sailboat              # Use Sailboat format
/retro post-mortem           # Incident review
```

## Integration with /session-retro

- **`/session-retro`**: Analyzes CURRENT session only (real-time)
- **`/retro analyze`**: Analyzes MULTIPLE sessions (historical)

Use both together:
1. `/session-retro` at end of each session (capture now)
2. `/retro analyze` every 5-10 sessions (spot patterns)

---
Last updated: 2026-02-27
