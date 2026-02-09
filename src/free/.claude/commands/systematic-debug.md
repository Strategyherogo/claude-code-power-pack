# Skill: Systematic Debug
Multi-step debugging workflow for complex issues.

## Auto-Trigger
**When:** "debug", "not working", "broken", "error", "bug"

## Workflow

### Step 1: Reproduce
```
□ Get exact steps to reproduce
□ Note environment (OS, Node version, etc.)
□ Capture error message verbatim
□ Identify when it last worked
```

### Step 2: Isolate
```
□ Minimal reproduction case
□ Which component fails?
□ Does it fail in isolation?
□ Binary search through recent changes
```

### Step 3: Hypothesize
```
□ List 3 most likely causes
□ Rank by probability
□ Design test for each hypothesis
```

### Step 4: Test
```
□ Add strategic logging
□ Test each hypothesis
□ Document findings
□ Eliminate possibilities
```

### Step 5: Fix
```
□ Implement smallest fix
□ Verify fix in isolation
□ Test for regressions
□ Document root cause
```

### Step 6: Prevent
```
□ Add test to prevent recurrence
□ Update documentation if needed
□ Consider similar issues elsewhere
```

## Debug Commands
```bash
# Node.js
node --inspect-brk app.js
DEBUG=* npm start

# Python
python -m pdb script.py
PYTHONVERBOSE=1 python script.py

# Swift
lldb ./MyApp
swift build -v
```

---
Last updated: 2026-01-27
