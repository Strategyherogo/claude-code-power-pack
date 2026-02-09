# Skill: checkpoint
Lightweight mid-session state snapshot — survives context compaction.

## Auto-Trigger
**When:** "checkpoint", "snapshot", or automatically when context window is >70% full

## Why This Exists
Context compaction loses details. Users asked: "can you make it possible not to stop context?" This is the answer — write critical state to a file BEFORE compaction happens, so nothing is lost.

---

## Checkpoint Workflow (< 30 seconds, zero questions)

### Step 1: Capture Current State

Write to `/tmp/claude-checkpoint.md` (ephemeral, overwritten each time):

```markdown
## Checkpoint: [HH:MM]

### Working On
[Current task from TaskList or last user message]

### Done So Far
[Bullet list of completed steps this session]

### In Progress
[What's actively being worked on right now]

### Key Variables
[Any IDs, paths, URLs, or values that would be lost]
- Board ID: [if applicable]
- Project: [current project path]
- Branch: [current branch]
- API endpoint: [if working with APIs]

### Next Steps
1. [Immediate next action]
2. [After that]

### Files Being Edited
[List of files modified but not yet committed]
```

### Step 2: Also Persist to Disk (survives session end)

If the checkpoint contains non-trivial state, also write to:
`context-saves/.checkpoint-latest.md`

This file is always overwritten (single file, not accumulating).

### Step 3: Confirm
```
📌 Checkpoint saved (HH:MM)
   State: [1-line summary]
   Files: [count] modified
```

---

## Auto-Checkpoint

When context window pressure is detected (compaction warning), automatically run checkpoint before compaction occurs. No user interaction needed.

---

## Restore from Checkpoint

When starting fresh after compaction:
```bash
cat /tmp/claude-checkpoint.md 2>/dev/null || cat ~/ClaudeCodeWorkspace/context-saves/.checkpoint-latest.md
```

The `/restore` skill should check for checkpoints automatically.

---

## Difference from /save and /handoff

| | /checkpoint | /save | /handoff |
|---|---|---|---|
| **When** | Mid-session | End of session | End of session |
| **Speed** | < 30 sec | 1-2 min | 2-3 min |
| **Questions** | Zero | 1-2 | 1-2 |
| **Output** | Temp file | context-saves/ | context-saves/ |
| **Purpose** | Survive compaction | Persist between sessions | Full handoff to next session |
| **Overwrites** | Yes (single file) | No (dated files) | No (dated files) |

## Related Skills
- `/save` — end-of-session save
- `/handoff` — full session end package
- `/restore` — resume from any saved state

---
Last updated: 2026-02-07
