#!/bin/bash
# Advanced context analyzer v2
# Factors: recency, frequency, time patterns, workflow chains, MCP usage
# Usage: context-analyzer.sh [--debug]

DEBUG=${1:-""}
LOG_DIR=~/.claude/conversation-logs
SKILL_DIR=~/ClaudeCodeWorkspace/.claude/commands
HISTORY_FILE=~/.claude/skill-history.json

# Get valid skills
valid_skills=$(ls "$SKILL_DIR"/*.md 2>/dev/null | xargs -I{} basename {} .md | tr '\n' '|' | sed 's/|$//')

# Current context
current_hour=$(date +%H)
current_day=$(date +%u)  # 1=Mon, 7=Sun
today=$(date +%Y-%m-%d)
yesterday=$(date -v-1d +%Y-%m-%d 2>/dev/null || date -d "yesterday" +%Y-%m-%d 2>/dev/null)

#######################################
# 1. RECENCY-WEIGHTED SKILL SCORING
#######################################

score_skills() {
    local log_file="$1"
    local weight="$2"

    grep -hE "^/[a-z]" "$log_file" 2>/dev/null | \
        sed 's/ .*//' | sed 's|^/||' | \
        grep -E "^($valid_skills)$" | \
        while read skill; do
            echo "$skill:$weight"
        done
}

# Today's logs = weight 10
# Yesterday = weight 5
# Older = weight 2
scores=""
for log in "$LOG_DIR"/$today*.md; do
    [ -f "$log" ] && scores="$scores $(score_skills "$log" 10)"
done
for log in "$LOG_DIR"/$yesterday*.md; do
    [ -f "$log" ] && scores="$scores $(score_skills "$log" 5)"
done
for log in $(ls -t "$LOG_DIR"/*.md 2>/dev/null | head -10 | tail -7); do
    [ -f "$log" ] && scores="$scores $(score_skills "$log" 2)"
done

# Aggregate scores
skill_scores=$(echo "$scores" | tr ' ' '\n' | grep -v '^$' | \
    awk -F: '{score[$1]+=$2} END {for(s in score) print score[s], s}' | \
    sort -rn)

#######################################
# 2. TIME-OF-DAY PATTERNS
#######################################

time_bonus=""
if [ $current_hour -lt 10 ]; then
    # Morning: planning, standup
    time_bonus="standup:5 morning-check:5 focus:3"
elif [ $current_hour -lt 14 ]; then
    # Midday: deep work
    time_bonus="focus:5 systematic-debug:3 tdd:3"
elif [ $current_hour -lt 18 ]; then
    # Afternoon: reviews, content
    time_bonus="agent:code-review:3 c2c:blog:3"
else
    # Evening: wrap up
    time_bonus="session-retro:5 reflect:5 save:3"
fi

# Day of week bonuses
if [ $current_day -eq 1 ]; then
    time_bonus="$time_bonus standup:5 jira-quick:3"
elif [ $current_day -eq 5 ]; then
    time_bonus="$time_bonus weekly-ops-review:5 reflect:3"
fi

#######################################
# 3. MCP TOOL PATTERNS → SKILL MAPPING
#######################################

recent_logs=$(ls -t "$LOG_DIR"/*.md 2>/dev/null | head -3)
mcp_bonus=""

if [ -n "$recent_logs" ]; then
    # grep directly instead of loading multi-MB files into a variable
    atlassian=$(grep -c "mcp__atlassian" $recent_logs 2>/dev/null | awk -F: '{s+=$NF}END{print s+0}')
    slack=$(grep -c "mcp__slack" $recent_logs 2>/dev/null | awk -F: '{s+=$NF}END{print s+0}')
    postgres=$(grep -c "mcp__postgres" $recent_logs 2>/dev/null | awk -F: '{s+=$NF}END{print s+0}')
    github=$(grep -c "mcp__github" $recent_logs 2>/dev/null | awk -F: '{s+=$NF}END{print s+0}')

    [ $atlassian -gt 5 ] && mcp_bonus="$mcp_bonus jira-quick:$((atlassian/2))"
    [ $slack -gt 3 ] && mcp_bonus="$mcp_bonus lookup:$((slack/2))"
    [ $postgres -gt 2 ] && mcp_bonus="$mcp_bonus db-query:$((postgres))"
    [ $github -gt 3 ] && mcp_bonus="$mcp_bonus agent:code-review:$((github/2))"
fi

#######################################
# 4. WORKFLOW CHAIN DETECTION
#######################################

# Find last skill used and suggest likely next
last_skill=$(grep -hE "^/[a-z]" $(ls -t "$LOG_DIR"/*.md 2>/dev/null | head -1) 2>/dev/null | \
    tail -1 | sed 's/ .*//' | sed 's|^/||' | grep -E "^($valid_skills)$")

chain_bonus=""
case "$last_skill" in
    systematic-debug) chain_bonus="verify:8 tdd:5" ;;
    jira-quick) chain_bonus="systematic-debug:5 focus:3" ;;
    focus) chain_bonus="session-retro:5 save:3" ;;
    deploy-verify) chain_bonus="infra-health:8 quick-deploy:5" ;;
    c2c:blog) chain_bonus="c2c:twitter:5 linkedin-post:3" ;;
    tdd) chain_bonus="verify:5 edge-test:5" ;;
esac

#######################################
# 5. COMBINE ALL SCORES
#######################################

all_scores="$skill_scores"

# Add time bonuses
for bonus in $time_bonus; do
    skill=$(echo $bonus | cut -d: -f1)
    score=$(echo $bonus | cut -d: -f2)
    all_scores="$all_scores
$score $skill"
done

# Add MCP bonuses
for bonus in $mcp_bonus; do
    skill=$(echo $bonus | cut -d: -f1)
    score=$(echo $bonus | cut -d: -f2)
    all_scores="$all_scores
$score $skill"
done

# Add chain bonuses (highest priority)
for bonus in $chain_bonus; do
    skill=$(echo $bonus | cut -d: -f1)
    score=$(echo $bonus | cut -d: -f2)
    all_scores="$all_scores
$score $skill"
done

#######################################
# 6. FINAL RANKING
#######################################

ranked=$(echo "$all_scores" | grep -v '^$' | \
    awk '{score[$2]+=$1} END {for(s in score) print score[s], s}' | \
    sort -rn)

final=$(echo "$ranked" | head -3 | awk '{print "/commands:"$2}' | tr '\n' ' ')

# Debug output
if [ "$DEBUG" = "--debug" ]; then
    echo "════════════════════════════════════════"
    echo "CONTEXT ANALYZER DEBUG"
    echo "════════════════════════════════════════"
    echo ""
    echo "📅 Time: $(date +%H:%M) (hour $current_hour, day $current_day)"
    echo "📁 Last skill: ${last_skill:-none}"
    echo ""
    echo "📊 SCORING FACTORS:"
    echo "─────────────────────────────────────────"
    echo "Recency-weighted skills:"
    echo "$skill_scores" | head -5 | awk '{printf "  %s: %d pts\n", $2, $1}'
    echo ""
    echo "Time-of-day bonus:"
    for b in $time_bonus; do echo "  $b"; done
    echo ""
    echo "MCP tool bonus:"
    [ -n "$mcp_bonus" ] && for b in $mcp_bonus; do echo "  $b"; done || echo "  (none)"
    echo ""
    echo "Workflow chain bonus:"
    [ -n "$chain_bonus" ] && for b in $chain_bonus; do echo "  $b"; done || echo "  (none)"
    echo ""
    echo "🏆 FINAL RANKING:"
    echo "─────────────────────────────────────────"
    echo "$ranked" | head -5 | awk '{printf "  /%s: %d pts\n", $2, $1}'
    echo ""
    echo "════════════════════════════════════════"
    echo "→ Recommended: $final"
    echo "════════════════════════════════════════"
else
    if [ -z "$final" ]; then
        echo "/commands:focus /commands:jira-quick /commands:systematic-debug"
    else
        echo "$final"
    fi
fi
