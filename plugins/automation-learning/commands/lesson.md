# Skill: lesson
Instant lesson capture — append a learning to the central lessons file in 3 seconds.

## Auto-Trigger
**When:** "lesson:", "TIL:", "gotcha:", "learned that", "note to self"

## Usage

### Quick Capture (one-liner)
```
/lesson Chrome print-to-pdf ignores custom page sizes — use screenshot + Pillow instead
```

### With Category
```
/lesson [SECURITY] Always chmod 600 on credential files
/lesson [API] Monday.com status labels are immutable after column creation
/lesson [PROCESS] Use /write-plan for tasks with >3 steps
```

## Workflow

### Step 1: Parse Input
Extract the lesson text from user's message. If a `[CATEGORY]` tag is present, use it. Otherwise, auto-detect from keywords:
- API, endpoint, auth → `API`
- deploy, build, ship → `DEPLOYMENT`
- security, credential, key → `SECURITY`
- process, workflow, plan → `PROCESS`
- tool, mcp, cli → `TOOLING`
- Default: `GENERAL`

### Step 2: Check for Duplicates
```bash
# Search existing lessons for similar content
grep -i "[first 3 keywords]" ~/.claude/lessons/$(date +%Y-%m).md 2>/dev/null
```
If a match is found, show it and ask: "Similar lesson exists. Add anyway?"

### Step 3: Append to Central File
Target file: `~/.claude/lessons/YYYY-MM.md` (current month)

Append in this format:
```markdown

## YYYY-MM-DD: [Lesson title — first sentence or user-provided title]
**Category:** [CATEGORY]
**Lesson:** [Full lesson text]
**Applied:** [ ] Pending
```

### Step 4: Confirm
Output: `Lesson saved to ~/.claude/lessons/YYYY-MM.md`

## Examples

Input: `/lesson Jira old search API removed — use POST /rest/api/3/search/jql`
Output:
```markdown
## 2026-02-07: Jira search API migration
**Category:** API
**Lesson:** Jira old search API removed — use POST /rest/api/3/search/jql with JSON body {jql, fields, maxResults}
**Applied:** [ ] Pending
```

Input: `/lesson [SECURITY] Never commit .env files — use .gitignore + Keychain`
Output:
```markdown
## 2026-02-07: Never commit .env files
**Category:** SECURITY
**Lesson:** Never commit .env files — use .gitignore + Keychain
**Applied:** [ ] Pending
```

## Rules
- **No questions asked** — capture immediately, ask nothing
- **No duplicates** — warn if similar exists, but don't block
- **Central location only** — always `~/.claude/lessons/YYYY-MM.md`
- **Append, never overwrite** — add to end of file

## Related Skills
- `/reflect` — deeper session reflection (5-15 min)
- `/session-retro` — full session retrospective
- `/save` — end-of-session context save

---
Last updated: 2026-02-07
