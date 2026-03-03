#!/bin/bash
# Auto Retrospective - Deep analysis of recent sessions
# Runs every 3 sessions to improve quality and performance

LOGS_DIR=~/.claude/conversation-logs
LESSONS_DIR=~/.claude/lessons
REPORTS_DIR=~/.claude/reports
SKILLS_DIR=~/ClaudeCodeWorkspace/.claude/commands

mkdir -p "$LESSONS_DIR" "$REPORTS_DIR"

TODAY=$(date +%Y-%m-%d)
MONTH=$(date +%Y-%m)
REPORT_FILE="$REPORTS_DIR/retro-$TODAY.md"

echo "═══════════════════════════════════════════════════════════"
echo "🔍 AUTO RETROSPECTIVE ANALYSIS"
echo "═══════════════════════════════════════════════════════════"

# Get recent logs (last 3 days)
RECENT_LOGS=$(ls -t "$LOGS_DIR"/*.md 2>/dev/null | head -3)

if [ -z "$RECENT_LOGS" ]; then
    echo "No conversation logs found"
    exit 0
fi

echo ""
echo "Analyzing logs:"
for log in $RECENT_LOGS; do
    echo "  → $(basename $log)"
done
echo ""

#######################################
# 1. TOOL USAGE ANALYSIS
#######################################
echo "── TOOL USAGE ──"

tool_stats=$(cat $RECENT_LOGS | grep -E "TOOL:" | sed 's/.*TOOL: //' | sort | uniq -c | sort -rn | head -10)
echo "$tool_stats"

total_tools=$(cat $RECENT_LOGS | grep -c "TOOL:" || echo 0)
total_prompts=$(cat $RECENT_LOGS | grep -c "👤 USER" || echo 0)

echo ""
echo "Total: $total_tools tool calls / $total_prompts prompts"
if [ $total_prompts -gt 0 ]; then
    ratio=$(echo "scale=1; $total_tools / $total_prompts" | bc)
    echo "Efficiency: $ratio tools/prompt"
fi

#######################################
# 2. ERROR ANALYSIS
#######################################
echo ""
echo "── ERRORS & FAILURES ──"

errors=$(cat $RECENT_LOGS | grep -iE "(error|failed|exception|timeout)" | wc -l | tr -d ' ')
echo "Error mentions: $errors"

# Find repeated errors
repeated_errors=$(cat $RECENT_LOGS | grep -oiE "(error|failed|exception).*" | sort | uniq -c | sort -rn | head -5)
if [ -n "$repeated_errors" ]; then
    echo "Repeated issues:"
    echo "$repeated_errors" | head -3
fi

#######################################
# 3. SKILL USAGE
#######################################
echo ""
echo "── SKILL USAGE ──"

# Get valid skills list
valid_skills=$(ls "$SKILLS_DIR"/*.md 2>/dev/null | xargs -I{} basename {} .md | tr '\n' '|' | sed 's/|$//')

skills_used=$(cat $RECENT_LOGS | grep -hE "^/[a-z]" | sed 's/ .*//' | sed 's|^/||' | \
    grep -E "^($valid_skills)$" 2>/dev/null | sort | uniq -c | sort -rn)

if [ -n "$skills_used" ]; then
    echo "$skills_used"
else
    echo "No skills invoked (opportunity to use more!)"
fi

#######################################
# 4. MCP TOOL ANALYSIS
#######################################
echo ""
echo "── MCP TOOLS ──"

mcp_usage=$(cat $RECENT_LOGS | grep -oE "mcp__[a-z_]+" | sort | uniq -c | sort -rn | head -8)
if [ -n "$mcp_usage" ]; then
    echo "$mcp_usage"
else
    echo "No MCP tools used"
fi

#######################################
# 5. PATTERN DETECTION
#######################################
echo ""
echo "── PATTERNS DETECTED ──"

# Repeated commands (automation candidates)
repeated_bash=$(cat $RECENT_LOGS | grep -A1 "TOOL: Bash" | grep "command" | \
    sed 's/.*"command": "//' | sed 's/".*//' | sort | uniq -c | sort -rn | head -5)

echo "Repeated commands (alias candidates):"
echo "$repeated_bash" | while read count cmd; do
    if [ "$count" -gt 2 ] 2>/dev/null; then
        echo "  $count× $cmd"
    fi
done

# Files frequently edited
frequent_files=$(cat $RECENT_LOGS | grep -oE '"/[^"]+\.(ts|js|py|sh|md)"' | sort | uniq -c | sort -rn | head -5)
echo ""
echo "Frequently touched files:"
echo "$frequent_files"

#######################################
# 6. QUALITY METRICS
#######################################
echo ""
echo "── QUALITY METRICS ──"

# Iterations (edits to same file)
edit_iterations=$(cat $RECENT_LOGS | grep "TOOL: Edit" | wc -l | tr -d ' ')
write_count=$(cat $RECENT_LOGS | grep "TOOL: Write" | wc -l | tr -d ' ')
read_count=$(cat $RECENT_LOGS | grep "TOOL: Read" | wc -l | tr -d ' ')

echo "Edits: $edit_iterations | Writes: $write_count | Reads: $read_count"

if [ $edit_iterations -gt 0 ] && [ $write_count -gt 0 ]; then
    edit_ratio=$(echo "scale=1; $edit_iterations / $write_count" | bc)
    echo "Edit/Write ratio: $edit_ratio (lower = cleaner first drafts)"
fi

# Check for back-and-forth patterns (indicates unclear requirements)
back_forth=$(cat $RECENT_LOGS | grep -c "let me fix\|let me correct\|actually\|sorry" || echo 0)
echo "Correction phrases: $back_forth"

#######################################
# 7. RECOMMENDATIONS
#######################################
echo ""
echo "── RECOMMENDATIONS ──"

recommendations=""

# High error rate
if [ $errors -gt 10 ]; then
    recommendations="$recommendations\n⚠️  High error count ($errors). Review error patterns."
fi

# Low skill usage
skill_count=$(echo "$skills_used" | wc -l | tr -d ' ')
if [ $skill_count -lt 3 ]; then
    recommendations="$recommendations\n💡 Low skill usage. Try: /systematic-debug, /jira-quick, /focus"
fi

# Low MCP usage
mcp_count=$(echo "$mcp_usage" | wc -l | tr -d ' ')
if [ $mcp_count -lt 2 ]; then
    recommendations="$recommendations\n💡 Low MCP usage. Available: Jira, Slack, Postgres, GitHub"
fi

# High edit ratio (lots of corrections)
if [ "$edit_ratio" != "" ] && [ $(echo "$edit_ratio > 3" | bc) -eq 1 ]; then
    recommendations="$recommendations\n⚠️  High edit ratio ($edit_ratio). Consider planning before coding."
fi

if [ -n "$recommendations" ]; then
    echo -e "$recommendations"
else
    echo "✅ No major issues detected"
fi

#######################################
# 8. GENERATE REPORT
#######################################
cat > "$REPORT_FILE" << EOF
# Auto Retrospective - $TODAY

## Session Metrics
| Metric | Value |
|--------|-------|
| Prompts | $total_prompts |
| Tool calls | $total_tools |
| Tools/prompt | ${ratio:-N/A} |
| Errors | $errors |
| Corrections | $back_forth |

## Tool Usage (Top 10)
\`\`\`
$tool_stats
\`\`\`

## Skills Used
\`\`\`
${skills_used:-None}
\`\`\`

## MCP Tools
\`\`\`
${mcp_usage:-None}
\`\`\`

## Patterns Detected
### Repeated Commands (Alias Candidates)
\`\`\`
$repeated_bash
\`\`\`

### Frequently Edited Files
\`\`\`
$frequent_files
\`\`\`

## Recommendations
$(echo -e "$recommendations")

## Action Items
- [ ] Review repeated commands for alias opportunities
- [ ] Check error patterns for systemic issues
- [ ] Consider using more skills for common tasks
- [ ] Update lessons file with new learnings

---
*Generated: $(date)*
EOF

echo ""
echo "═══════════════════════════════════════════════════════════"
echo "📄 Report saved: $REPORT_FILE"
echo "═══════════════════════════════════════════════════════════"
