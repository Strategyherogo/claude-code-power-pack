#!/bin/bash
# Claude Session Starter v4 — parallel + lean
# Usage: cs [-r|-m|-s|-p|-h]

WS="$HOME/ClaudeCodeWorkspace"

# ── Parse mode ──
MODE="auto"
while getopts "rmsph" opt; do
    case $opt in
        r) MODE="review" ;;
        m) MODE="morning" ;;
        s) MODE="skill" ;;
        p) MODE="plain" ;;
        h) cat <<'EOF'
  cs       auto-start (evening=retro, morning=morning-check, else=briefing)
  cs -r    full review
  cs -m    morning checks
  cs -s    skill picker
  cs -p    plain start
EOF
           exit 0 ;;
    esac
done
shift $((OPTIND-1))

# ── Status line (parallel, no timing overhead) ──
{
    git -C "$WS" branch --show-current 2>/dev/null || echo "no branch"
} > /tmp/cs-branch.$$ &

{
    git -C "$WS" status --porcelain 2>/dev/null | wc -l
} > /tmp/cs-dirty.$$ &

{
    ls -t "$WS"/.claude/context-saves/*.md 2>/dev/null | head -1
} > /tmp/cs-save.$$ &

wait

# Read results
branch=$(<"/tmp/cs-branch.$$")
dirty=$(<"/tmp/cs-dirty.$$")
dirty=${dirty// /}
last_save=$(<"/tmp/cs-save.$$")
rm -f /tmp/cs-{branch,dirty,save}.$$

# Calculate save age
if [[ -n "$last_save" ]]; then
    mins=$(( ($(date +%s) - $(stat -f%m "$last_save")) / 60 ))
    if (( mins < 60 )); then
        save="saved ${mins}m ago"
    else
        save="saved $(( mins / 60 ))h ago"
    fi
else
    save="no saves"
fi

printf '\n  %s  \033[2m|\033[0m  %s files  \033[2m|\033[0m  %s\n\n' "$branch" "$dirty" "$save"

# ── Launch helper ──
launch() { cd "$WS" && exec claude "$@"; }

# ── Route ──
case "$MODE" in
    review)  launch "/commands:full-review" ;;
    morning) launch "/commands:morning-check" ;;
    skill)
        skill=$(ls "$WS"/.claude/commands/*.md 2>/dev/null \
            | sed 's|.*/||; s|\.md$||' \
            | sort \
            | fzf --height 20 --reverse --prompt="skill: ")
        launch ${skill:+"/commands:$skill"}
        ;;
    plain)   launch ;;
    auto)
        hour=$(date +%-H)
        if   (( hour >= 20 )); then launch "/commands:session-retro"
        elif (( hour < 10 ));  then launch "/commands:morning-check"
        else                        launch "/commands:cs"
        fi
        ;;
esac
