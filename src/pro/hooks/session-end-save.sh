#!/bin/bash
# Session End Auto-Save — generates context save file automatically
# Runs on Stop event

INPUT=$(cat)
HOOK_EVENT=$(echo "$INPUT" | jq -r '.hook_event_name // "unknown"')
[ "$HOOK_EVENT" != "Stop" ] && exit 0

WORKSPACE="$HOME/ClaudeCodeWorkspace"
SAVES="$WORKSPACE/context-saves"
TODAY=$(date +%Y-%m-%d)
NOW=$(date '+%Y-%m-%d %H:%M')

# Skip if a context-save was already created this session (within last 30 min)
RECENT_SAVE=$(find "$SAVES" -name "${TODAY}*.md" -mmin -30 2>/dev/null | head -1)
[ -n "$RECENT_SAVE" ] && exit 0

# Gather state
CHANGES=$(git -C "$WORKSPACE" status --porcelain 2>/dev/null | wc -l | tr -d ' ')
BRANCH=$(git -C "$WORKSPACE" branch --show-current 2>/dev/null)
LAST_COMMIT=$(git -C "$WORKSPACE" log --oneline -1 2>/dev/null)
RECENT_COMMITS=$(git -C "$WORKSPACE" log --oneline --since="4 hours ago" 2>/dev/null | head -5)
MODIFIED=$(git -C "$WORKSPACE" status --porcelain 2>/dev/null | head -5 | awk '{print $2}')

# Generate auto-save file
SAVE_FILE="$SAVES/${TODAY}-auto-save.md"

cat > "$SAVE_FILE" << SAVE
# Auto-Save: $NOW

## Workspace
- Branch: \`$BRANCH\`
- Uncommitted: $CHANGES files
- Last commit: \`$LAST_COMMIT\`

## Recent Commits
$RECENT_COMMITS

## Modified Files
$MODIFIED

## Restoration
\`\`\`bash
cd $WORKSPACE
git log --oneline -5
\`\`\`
SAVE

# Notify
if [ "$CHANGES" -gt 3 ]; then
    echo "{\"message\": \"Auto-saved session state. $CHANGES uncommitted files on '$BRANCH'.\"}"
fi

exit 0
