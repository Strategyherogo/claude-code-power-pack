# Skill: weekly-ops-review
30-minute ritual every Sunday to keep systems healthy and skills sharp.

## Auto-Trigger
**When:** "weekly review", "ops review", "sunday ritual", "weekly ops", "system review"

## Schedule
**Run Every:** Sunday at 20:00 local time
**Duration:** 30 minutes

## The Review Protocol

### Step 1: System Health (5 min)

#### Check Automated Systems
```bash
# Verify backups exist
ls -lh ~/Backups/workspace/ | tail -5

# Check health check logs
tail -20 ~/ClaudeCodeWorkspace/logs/daily-health-*.log 2>/dev/null || echo "No logs found"

# Check session tracker
python3 ~/.claude/skills/workspace-automation/scripts/session_tracker.py status
```

#### Quick Health Dashboard
```
□ Backups running? (check dates)
□ Health checks green?
□ Any error alerts this week?
□ Services responding? (API endpoints)
□ Storage usage acceptable?
```

### Step 2: Trigger Effectiveness (5 min)

#### Review This Week's Triggers
```
□ Which triggers fired?
□ Were they helpful or annoying?
□ Any triggers that should have fired but didn't?
□ Any keywords missing from trigger list?
```

#### Trigger Tune-Up Checklist
```
□ /verify - Did it catch any bugs this week?
□ /deploy-verify - Did it prevent any issues?
□ /systematic-debug - Used for debugging?
□ Any false positives (triggered incorrectly)?
```

### Step 3: Skill Inventory (10 min)

#### Usage Review
```
□ Which skills were used this week?
□ Which skills weren't used at all?
□ Any skills that need updating?
□ Any skills that should be merged/deleted?
```

#### Skill Health Check
```bash
# Count skills
ls -1 ~/.claude/commands/*.md | wc -l

# Find unused skills (not modified in 30 days)
find ~/.claude/commands/ -name "*.md" -mtime +30
```

#### Maintenance Actions
```
□ Update outdated skills
□ Archive unused skills
□ Merge overlapping skills
□ Add missing Auto-Trigger sections
□ Update Last Updated timestamps
```

### Step 4: Lessons Learned (10 min)

#### This Week's Work
```
□ What worked well?
□ What was painful?
□ What patterns emerged?
□ What would a skill have helped with?
```

#### Capture New Skills
```
If you did something 3+ times this week, make it a skill:
1. Identify the pattern
2. Document the workflow
3. Create skill file with /make-skill
4. Add to trigger list
```

#### Update Work Journal
```bash
# Create weekly entry
mkdir -p ~/ClaudeCodeWorkspace/journals/$(date +%Y)
```

## Output Template

Save to: `~/ClaudeCodeWorkspace/journals/YYYY/weekly-ops-YYYY-MM-DD.md`

```markdown
# Weekly Ops Review - [DATE]

## System Status
- Backups: ✅ Running / ❌ Issue
- Health Checks: ✅ Green / ❌ Errors
- Services: ✅ Up / ❌ Down
- Storage: [X]% used

## Trigger Activity
- Times /verify fired: [N]
- Times /deploy-verify fired: [N]
- Helpful triggers: [list]
- Annoying triggers: [list]

## Skill Usage
- Most used: [skill names]
- Unused: [skill names]
- Updated this week: [skill names]
- New skills created: [skill names]

## Lessons Learned
1. [Lesson 1]
2. [Lesson 2]
3. [Lesson 3]

## Action Items for Next Week
- [ ] [Action 1]
- [ ] [Action 2]
- [ ] [Action 3]

## Notes
[Free-form notes]
```

## Metrics to Track

### Weekly KPIs
| Metric | Target | This Week |
|--------|--------|-----------|
| Blocked deploys | 0 | |
| Bugs caught by /verify | Count | |
| New skills created | 1-2 | |
| Skills updated | 5+ | |
| Health check passes | 100% | |

### Monthly Trends
```
Track over time:
- Total skills count
- Trigger hit rate
- Average session length
- Issues prevented vs. caught
```

## Quick Actions

| If This | Then Do This |
|---------|--------------|
| Backup missing | Run manual backup |
| Health check red | Investigate logs |
| Skill outdated | Update or archive |
| Pattern repeated | Create new skill |
| Trigger annoying | Adjust or remove |

## Related Skills
- `/workspace-audit` - Deep workspace cleanup
- `/reflect` - Personal lessons learned
- `/cs` - Save context at session end

---
Last updated: 2026-01-27
