#!/bin/bash
# Quick status log - runs every 5 minutes
LOG=~/.claude/logs/status.log
mkdir -p ~/.claude/logs

echo "[$(date '+%Y-%m-%d %H:%M')] load:$(sysctl -n vm.loadavg 2>/dev/null | awk '{print $2}') mem:$(top -l 1 -s 0 2>/dev/null | grep PhysMem | awk '{print $2}') disk:$(df -h / | tail -1 | awk '{print $5}')" >> "$LOG"

# Keep only last 1000 lines
tail -1000 "$LOG" > "$LOG.tmp" && mv "$LOG.tmp" "$LOG"
