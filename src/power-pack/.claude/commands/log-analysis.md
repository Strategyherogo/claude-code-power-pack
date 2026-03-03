# Skill: log-analysis
Analyze Claude Code conversation logs to extract patterns, insights, and usage statistics.

## Auto-Trigger
**When:** "analyze logs", "session analysis", "conversation patterns", "usage stats", "what did I work on"

## Overview
Analyzes conversation logs stored at `~/.claude/conversation-logs/` to provide:
- Usage patterns and statistics
- Common tasks and workflows
- Tool usage frequency
- Time-based analysis
- Productivity insights

## Quick Commands

### View Today's Log
```bash
cat ~/.claude/conversation-logs/$(date +%Y-%m-%d).md
```

### Search Logs
```bash
# By keyword
grep -r "keyword" ~/.claude/conversation-logs/

# By date range
ls ~/.claude/conversation-logs/2026-01-*.md

# User prompts only
grep "👤 USER" ~/.claude/conversation-logs/*.md
```

### Log Statistics
```bash
# Line count per day
wc -l ~/.claude/conversation-logs/*.md

# Total size
du -sh ~/.claude/conversation-logs/

# Number of sessions
grep -c "👤 USER" ~/.claude/conversation-logs/$(date +%Y-%m-%d).md
```

## Analysis Types

### 1. Daily Summary
```markdown
## Daily Analysis: [DATE]

### Session Count
[number of distinct sessions]

### Top Activities
1. [most common task type]
2. [second most common]
3. [third]

### Tools Used
| Tool | Count |
|------|-------|
| Bash | [n] |
| Read | [n] |
| Write | [n] |
| Edit | [n] |

### Time Distribution
- Morning (6-12): [n] interactions
- Afternoon (12-18): [n] interactions
- Evening (18-24): [n] interactions
```

### 2. Weekly Patterns
```markdown
## Weekly Analysis: [WEEK]

### Most Active Days
1. [day]: [n] sessions
2. [day]: [n] sessions

### Common Workflows
- [workflow 1]: [frequency]
- [workflow 2]: [frequency]

### Skills Invoked
| Skill | Times Used |
|-------|------------|
| /[skill] | [n] |

### Recurring Tasks
- [task pattern 1]
- [task pattern 2]
```

### 3. Tool Usage Analysis
```markdown
## Tool Usage Report

### Most Used Tools
1. [tool]: [count] ([percentage]%)
2. [tool]: [count] ([percentage]%)

### Tool Combinations
- [tool1] + [tool2]: [frequency]

### Failed Tool Calls
- [tool]: [error pattern]
```

### 4. Productivity Insights
```markdown
## Productivity Analysis

### Task Completion Rate
- Started: [n]
- Completed: [n]
- Blocked: [n]

### Average Session Length
[n] interactions per session

### Most Efficient Workflows
1. [workflow]: [avg interactions to complete]

### Friction Points
- [repeated struggle 1]
- [repeated struggle 2]
```

## Analysis Scripts

### Quick Stats Script
```bash
#!/bin/bash
# ~/.claude/scripts/log-stats.sh

LOG_DIR="$HOME/.claude/conversation-logs"
DATE=${1:-$(date +%Y-%m-%d)}
LOG_FILE="$LOG_DIR/$DATE.md"

if [ ! -f "$LOG_FILE" ]; then
    echo "No log for $DATE"
    exit 1
fi

echo "=== Log Analysis: $DATE ==="
echo ""
echo "User prompts: $(grep -c '👤 USER' "$LOG_FILE")"
echo "Claude responses: $(grep -c '🤖 CLAUDE' "$LOG_FILE")"
echo "Tool calls: $(grep -c '🔧 TOOL' "$LOG_FILE")"
echo "Notifications: $(grep -c '🔔 NOTIFICATION' "$LOG_FILE")"
echo ""
echo "=== Top Tools ==="
grep '🔧 TOOL:' "$LOG_FILE" | sed 's/.*TOOL: //' | sort | uniq -c | sort -rn | head -10
echo ""
echo "=== Session IDs ==="
grep -o 'session: [a-f0-9]*' "$LOG_FILE" | sort -u
```

### Weekly Report Script
```bash
#!/bin/bash
# ~/.claude/scripts/weekly-log-report.sh

LOG_DIR="$HOME/.claude/conversation-logs"
echo "=== Weekly Log Report ==="
echo ""

for i in {6..0}; do
    DATE=$(date -v-${i}d +%Y-%m-%d)
    FILE="$LOG_DIR/$DATE.md"
    if [ -f "$FILE" ]; then
        PROMPTS=$(grep -c '👤 USER' "$FILE" 2>/dev/null || echo 0)
        TOOLS=$(grep -c '🔧 TOOL' "$FILE" 2>/dev/null || echo 0)
        echo "$DATE: $PROMPTS prompts, $TOOLS tool calls"
    fi
done
```

### Search Patterns Script
```bash
#!/bin/bash
# ~/.claude/scripts/log-search.sh

LOG_DIR="$HOME/.claude/conversation-logs"
PATTERN="$1"
DAYS=${2:-7}

echo "=== Searching '$PATTERN' in last $DAYS days ==="
for i in $(seq $((DAYS-1)) -1 0); do
    DATE=$(date -v-${i}d +%Y-%m-%d)
    FILE="$LOG_DIR/$DATE.md"
    if [ -f "$FILE" ]; then
        COUNT=$(grep -c "$PATTERN" "$FILE" 2>/dev/null || echo 0)
        if [ "$COUNT" -gt 0 ]; then
            echo "$DATE: $COUNT matches"
        fi
    fi
done
```

## Analysis Checklist

### Daily Review
```
□ Check session count
□ Review tool usage distribution
□ Note any failed operations
□ Identify repeated patterns
□ Flag potential automation candidates
```

### Weekly Review
```
□ Compare daily activity levels
□ Identify most common workflows
□ Review skill usage
□ Note efficiency improvements
□ Update lessons learned
```

### Monthly Review
```
□ Analyze trends over time
□ Identify workflow evolution
□ Review skill effectiveness
□ Plan system improvements
□ Archive old logs if needed
```

## Log File Format Reference

```markdown
## [TIMESTAMP] 👤 USER (session: XXXXXXXX)
[user prompt text]

---

### [TIMESTAMP] 🔧 TOOL: ToolName
```json
{tool input}
```

#### [TIMESTAMP] ✅ RESULT: ToolName
```
{tool output}
```

## [TIMESTAMP] 🤖 CLAUDE
[Claude's response text]

---

### [TIMESTAMP] 🔔 NOTIFICATION: type
[notification message]
```

## Integration

### Related Skills
- `/session-retro` - End of session analysis
- `/reflect` - Deeper analysis of patterns
- `/workspace-audit` - System-wide review

### Output Locations
- Daily logs: `~/.claude/conversation-logs/YYYY-MM-DD.md`
- Raw data: `~/.claude/conversation-logs/YYYY-MM-DD-raw.jsonl`
- Analysis reports: `~/.claude/reports/` (if generated)

---
Last updated: 2026-01-29
