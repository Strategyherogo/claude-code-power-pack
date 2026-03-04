# Skill: wrap
Complete session wrap-up: retro + save + handoff + commit in one command.

## Auto-Trigger
**When:** "wrap up", "wrap session", "end session", "session wrap", "wrap it up"

## Overview
Unified skill that combines retrospective analysis, context save, handoff note generation, and git commit into a single streamlined workflow. Includes intelligent fallback logic for permission-blocked file writes.

## Execution Flow

### 1. Session Retrospective
Generate a concise session retrospective covering:
- **What was accomplished** (2-3 bullet points)
- **Friction points** encountered
- **Lessons learned** (1-2 key takeaways)
- **System improvements** suggested

### 2. Context Save
Create a timestamped context save with:
- Current state of work
- Open items and blockers
- Key decisions made
- Files modified

### 3. Handoff Note
Generate next-session handoff including:
- **Next steps** (prioritized action items)
- **Context needed** (what to remember)
- **Dependencies** (what's blocking progress)
- **Quick wins** (easy tasks to start with)

### 4. Git Commit & Push
- Stage all changes
- Create descriptive commit message based on session work
- Push to current branch
- **Check ALL git repos in workspace** for unpushed commits:
  ```bash
  for dir in "1. Projects"/* "2. Areas"/*; do
    [ -d "$dir/.git" ] && (cd "$dir" && ahead=$(git rev-list --count @{u}..HEAD 2>/dev/null) && [ "$ahead" -gt 0 ] && echo "$dir: $ahead unpushed commits")
  done
  ```
- If any repos have unpushed commits, list them and push each one
- This prevents the "uncommitted files persist 5+ sessions" pattern

### 5. Summary Report
Print final status with:
- Commit hash (if successful)
- Files written (or copy-paste blocks if blocked)
- Manual steps remaining (if any)

## Permission Fallback Logic

**CRITICAL:** If any file write is denied, immediately switch to terminal output mode:

1. **First attempt:** Try Write/Edit tool
2. **If blocked:** Output between markers for manual copy-paste:
   ```
   ===START: filename.md===
   [full content here]
   ===END: filename.md===
   ```
3. **Never retry** blocked writes more than once
4. **Always output** full content so user can save manually

## Template Output

```markdown
# Session Wrap: [Date] [Time]

## Retrospective

### Accomplished
- [accomplishment 1]
- [accomplishment 2]

### Friction
- [friction point 1]
- [friction point 2]

### Lessons
- [lesson 1]
- [lesson 2]

### Improvements Suggested
- [ ] [improvement 1]
- [ ] [improvement 2]

## Handoff for Next Session

### Priority Next Steps
1. [next action 1]
2. [next action 2]

### Context to Remember
- [key context 1]
- [key context 2]

### Blockers
- [blocker 1] (status: [status])

### Quick Wins
- [easy task 1]
- [easy task 2]

## Git Status
**Commit:** [hash]
**Branch:** [branch name]
**Files changed:** [count]

## Manual Steps Remaining
- [ ] [manual step 1] (if any)
```

## Save Locations

**Attempt to save to:**
1. `.claude/context-saves/[YYYY-MM-DD]-session-wrap.md`
2. `.claude/sessions/[session-id]/wrap.md`

**If both blocked:**
- Output full content to terminal with copy markers
- Include exact `cp` commands user can run

### Step 5: Export Session to Iterations Folder

After writing the handoff file, auto-export today's conversation log to the iterations folder:

```bash
# Determine DDMM prefix and next version number
DATE=$(date +%d%m)  # e.g. "2702"
ITER_DIR="$HOME/ClaudeCodeWorkspace/3. Resources/02-iterations"
LAST_V=$(ls "$ITER_DIR/${DATE} v"*.txt 2>/dev/null | grep -oE 'v[0-9]+' | grep -oE '[0-9]+' | sort -n | tail -1)
NEXT_V=$(( ${LAST_V:-0} + 1 ))

# SESSION LABEL: Claude must generate this — NOT from git commits
# Before running the bash export, Claude generates a 3-5 word human-readable label
# that describes what was accomplished this session. Examples:
#   "slack-admin-access-control"
#   "YourApp-localization-fix"
#   "jira-monday-sync-setup"
#   "do-deployment-socket-mode"
# Rules: lowercase, hyphen-separated, no filler words, max 5 words
# Claude sets LABEL="<generated-label>" before the export block runs.
LABEL="<CLAUDE_GENERATES_THIS>"

DEST="$ITER_DIR/${DATE} v${NEXT_V} - ${LABEL}.txt"

# Copy today's conversation log
cp "$HOME/.claude/conversation-logs/$(date +%Y-%m-%d).md" "$DEST"
echo "Session exported: $DEST"
```

**Always run this step** — it produces the full session transcript in the format the user maintains for all terminal sessions.

### Step 6: Key Attention Report

After saving everything, print a focused summary of:

**⚠️ Needs Attention / Failing:**
- [ ] Items that errored, failed, or were blocked during the session
- [ ] Unresolved issues, pending fixes, half-done work

**✅ Created / Succeeded:**
- Specific files created, APIs called successfully, features shipped

**🔜 Must Do Next Session:**
- Numbered priority list — be concrete, include IDs/paths

## Examples

### Success Case
```
Session wrapped successfully!
- Retro: .claude/context-saves/2026-02-25-session-wrap.md
- Commit: a1b2c3d "feat: implement user auth with JWT"
- Next: Start with API endpoint testing
```

### Blocked Write Case
```
File write blocked. Copy-paste the following:

===START: 2026-02-25-session-wrap.md===
[full content]
===END: 2026-02-25-session-wrap.md===

To save manually:
pbpaste > .claude/context-saves/2026-02-25-session-wrap.md
```

## Integration

This skill consolidates:
- `/session-retro` - retrospective analysis
- `/save` - context preservation
- `/handoff` - next-session prep
- Git commit automation

Run this at the end of every session for consistent knowledge capture.

---
**Version:** 1.0
**Created:** 2026-02-25
**Purpose:** Eliminate session-end friction and ensure no work is lost
