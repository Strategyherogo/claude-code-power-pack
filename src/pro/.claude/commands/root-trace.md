# Skill: Root Trace
Trace errors to their root cause.

## Auto-Trigger
**When:** "trace", "root cause", "where does this come from", "stack trace"

## Workflow

### Step 1: Capture Full Context
```
□ Full stack trace
□ Error message
□ Request/response data
□ Relevant logs (5 min before error)
```

### Step 2: Trace Backwards
```
□ Start at error location
□ Find calling function
□ Trace data flow backwards
□ Identify transformation points
```

### Step 3: Find Origin
```
□ Where was bad data introduced?
□ What assumption was violated?
□ What changed recently?
□ Is this a new or old bug?
```

### Step 4: Document Path
```markdown
## Root Cause Analysis

**Error:** [description]
**Location:** [file:line]

**Trace Path:**
1. [origin] → introduced bad state
2. [transform] → state propagated
3. [failure] → error manifested

**Root Cause:** [explanation]
**Fix Location:** [where to fix]
```

## Tracing Tools
```bash
# Git blame
git blame -L 50,60 file.ts

# Git bisect
git bisect start
git bisect bad HEAD
git bisect good v1.0.0

# Search history
git log -p --all -S 'searchterm'
```

---
Last updated: 2026-01-27
