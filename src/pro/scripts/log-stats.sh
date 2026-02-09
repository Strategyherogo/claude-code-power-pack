#!/bin/bash
# Quick conversation log statistics
# Usage: log-stats.sh [date]

LOG_DIR="$HOME/.claude/conversation-logs"
DATE=${1:-$(date +%Y-%m-%d)}
LOG_FILE="$LOG_DIR/$DATE.md"

if [ ! -f "$LOG_FILE" ]; then
    echo "No log for $DATE"
    echo "Available logs:"
    ls -la "$LOG_DIR"/*.md 2>/dev/null | tail -5
    exit 1
fi

echo "=== Log Analysis: $DATE ==="
echo ""
echo "📊 Counts:"
echo "  User prompts:     $(grep -c '👤 USER' "$LOG_FILE" 2>/dev/null || echo 0)"
echo "  Claude responses: $(grep -c '🤖 CLAUDE' "$LOG_FILE" 2>/dev/null || echo 0)"
echo "  Tool calls:       $(grep -c '🔧 TOOL' "$LOG_FILE" 2>/dev/null || echo 0)"
echo "  Tool results:     $(grep -c '✅ RESULT' "$LOG_FILE" 2>/dev/null || echo 0)"
echo "  Notifications:    $(grep -c '🔔 NOTIFICATION' "$LOG_FILE" 2>/dev/null || echo 0)"
echo ""
echo "📁 File size: $(du -h "$LOG_FILE" | cut -f1)"
echo ""
echo "🔧 Top Tools:"
grep '🔧 TOOL:' "$LOG_FILE" | sed 's/.*TOOL: //' | sort | uniq -c | sort -rn | head -5
echo ""
echo "🔑 Sessions:"
grep -o 'session: [a-f0-9]*' "$LOG_FILE" | sort -u | wc -l | xargs echo "  Unique sessions:"
