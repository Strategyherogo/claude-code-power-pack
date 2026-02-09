#!/bin/bash
# Claude Session Starter v2 — fast by default, flags for extras
# Usage: cs          → instant start with suggested skill
#        cs -r       → full review (cleanup + retro + priorities)
#        cs -m       → morning checks first
#        cs -s       → skill picker (fzf)
#        cs -p       → plain (no skill)
#        cs -h       → help

CYAN='\033[0;36m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
DIM='\033[2m'
NC='\033[0m'

WORKSPACE="$HOME/ClaudeCodeWorkspace"

# Parse flags
MODE="auto"
while getopts "rmsph" opt; do
    case $opt in
        r) MODE="review" ;;
        m) MODE="morning" ;;
        s) MODE="skill" ;;
        p) MODE="plain" ;;
        h) echo "cs          Start with suggested skill (default)"
           echo "cs -r       Full review (cleanup + retro + priorities)"
           echo "cs -m       Morning checks + start"
           echo "cs -s       Pick a skill (fzf)"
           echo "cs -p       Plain start (no skill)"
           exit 0 ;;
    esac
done

# ── Compact status (always shown, <1 sec) ──
uncommitted=$(git -C "$WORKSPACE" status --porcelain 2>/dev/null | wc -l | tr -d ' ')
branch=$(git -C "$WORKSPACE" branch --show-current 2>/dev/null)
last_save=$(ls -t "$WORKSPACE"/context-saves/*.md 2>/dev/null | head -1)
if [ -n "$last_save" ]; then
    save_name=$(basename "$last_save" .md | sed 's/^[0-9-]*-//')
    save_age=$(( ($(date +%s) - $(stat -f%m "$last_save")) / 3600 ))
    save_info="${save_name} (${save_age}h ago)"
else
    save_info="none"
fi

echo ""
echo -e "${DIM}──────────────────────────────────────────${NC}"
echo -e "  ${GREEN}$branch${NC}  ${uncommitted} uncommitted  ${DIM}│${NC}  ${save_info}"
echo -e "${DIM}──────────────────────────────────────────${NC}"

# ── Auto-detect morning on weekdays before 10am ──
hour=$(date +%H)
day=$(date +%u)  # 1=Mon, 7=Sun
if [ "$MODE" = "auto" ] && [ "$hour" -lt 10 ] && [ "$day" -le 5 ]; then
    MODE="morning"
fi

case "$MODE" in
    review)
        echo ""
        echo -e "${CYAN}── CLEANUP ──${NC}"
        ~/.claude/scripts/cleanup.sh 2>/dev/null
        echo ""
        cd "$WORKSPACE" && exec claude "/commands:full-review"
        ;;

    morning)
        echo ""
        echo -e "${CYAN}── PACKAGES ──${NC}"
        ~/.claude/scripts/daily-package-check.sh 2>/dev/null || echo "  (skipped)"
        echo -e "${CYAN}── MONDAY ──${NC}"
        ~/.claude/scripts/daily-monday-check.sh 2>/dev/null || echo "  (skipped)"
        echo -e "${CYAN}── LOGS ──${NC}"
        ~/.claude/scripts/log-stats.sh 2>/dev/null || echo "  (skipped)"
        echo ""
        cd "$WORKSPACE" && exec claude "/commands:morning-check"
        ;;

    skill)
        skill=$(printf '%s\n' \
            "/commands:full-review        │ Full review (cleanup+retro+priorities)" \
            "/commands:focus              │ Deep work session" \
            "/commands:jira-quick         │ Quick Jira operations" \
            "/commands:systematic-debug   │ Debug workflow" \
            "/commands:c2c:blog           │ Write blog post" \
            "/commands:c2c:quick-blog     │ Quick blog post" \
            "/commands:deploy-verify      │ Pre-deploy checklist" \
            "/commands:quick-deploy       │ Fast deployment" \
            "/commands:system-health      │ Service health check" \
            "/commands:standup            │ Daily standup" \
            "/commands:brainstorm         │ Ideation session" \
            "/commands:reflect            │ Session reflection" \
            "/commands:agent:code-review  │ Automated code review" \
            "/commands:tdd                │ Test-driven development" \
            "/commands:db-query           │ Database queries" \
            "/commands:gws-search         │ Google Workspace search" \
            "/commands:morning-check      │ Morning routine" \
            "/commands:weekly-ops-review  │ Weekly review" \
            "/commands:save               │ Save session state" \
            "/commands:restore            │ Restore previous session" \
            | fzf --height 22 --reverse --prompt="Skill: " --header="Select skill to start with")

        if [ -n "$skill" ]; then
            selected=$(echo "$skill" | awk -F'│' '{print $1}' | xargs)
            cd "$WORKSPACE" && exec claude "$selected"
        else
            cd "$WORKSPACE" && exec claude
        fi
        ;;

    plain)
        cd "$WORKSPACE" && exec claude
        ;;

    auto|*)
        # Get context-based suggestion
        suggested=$(~/.claude/scripts/context-analyzer.sh 2>/dev/null)
        first_skill=$(echo "${suggested:-/commands:cs}" | awk '{print $1}')
        echo -e "  ${DIM}→${NC} ${GREEN}${first_skill}${NC}"
        echo ""
        cd "$WORKSPACE" && exec claude "$first_skill"
        ;;
esac
