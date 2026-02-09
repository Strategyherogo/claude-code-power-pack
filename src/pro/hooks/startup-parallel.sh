#!/bin/bash
# Claude Code Startup Hook
# Runs once per session using session_id from hook JSON input

INPUT=$(cat)
WORKSPACE="$HOME/ClaudeCodeWorkspace"
LOCK_DIR="/tmp/claude-sessions"
mkdir -p "$LOCK_DIR"

# Extract session_id from hook input — stable per session
SESSION_ID=$(echo "$INPUT" | jq -r '.session_id // empty' 2>/dev/null)
if [ -z "$SESSION_ID" ]; then
    exit 0
fi

# Skip if this session already ran startup (atomic locking)
LOCK_FILE="$LOCK_DIR/$SESSION_ID"
mkdir "$LOCK_FILE" 2>/dev/null || exit 0

# Clean up lock files older than 24h
find "$LOCK_DIR" -type f -mtime +1 -delete 2>/dev/null &

# --- Only runs once per session below this line ---

# Session tracking
if [ -f ~/.claude/skills/workspace-automation/scripts/session_tracker.py ]; then
    python3 ~/.claude/skills/workspace-automation/scripts/session_tracker.py start 2>/dev/null &
fi

ISSUES=""

# Check GitHub auth
if ! gh auth status 2>/dev/null >/dev/null; then
    ISSUES="$ISSUES\n  - GitHub: not authenticated"
fi

# Check for uncommitted work (the only thing that changes often)
UNCOMMITTED=$(git -C "$WORKSPACE" status --porcelain 2>/dev/null | wc -l | tr -d ' ')
if [ "$UNCOMMITTED" -gt 5 ]; then
    ISSUES="$ISSUES\n  - $UNCOMMITTED uncommitted files in workspace"
fi

# Only show output if there are real issues
if [ -n "$ISSUES" ]; then
    echo -e "{\"message\": \"Startup:$ISSUES\"}"
fi

exit 0
