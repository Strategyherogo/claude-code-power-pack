# Skill: Parallel Agents
Coordinate multiple Claude agents for complex tasks.

## Auto-Trigger
**When:** "parallel", "multiple agents", "concurrent", "split work"

## Agent Coordination Pattern

### Task Decomposition
```
□ Identify independent subtasks
□ Identify dependencies between tasks
□ Estimate complexity of each
□ Assign to appropriate agent type
```

### Agent Types
```
RESEARCHER: Gather information, analyze docs
CODER: Write and refactor code
REVIEWER: Check quality, find issues
TESTER: Write tests, verify behavior
DOCUMENTER: Write docs, update READMEs
```

### Parallel Execution Template
```markdown
## Parallel Task: [Name]

### Agent 1: Researcher
**Task:** Research best practices for [topic]
**Output:** Summary document
**Duration:** ~5 min

### Agent 2: Coder
**Task:** Implement [feature]
**Depends on:** Agent 1 output
**Output:** Working code
**Duration:** ~10 min

### Agent 3: Tester
**Task:** Write tests for [feature]
**Depends on:** Agent 2 output
**Output:** Test suite
**Duration:** ~5 min

### Sync Point
- Merge Agent 2 and 3 outputs
- Review combined result
- Proceed to next phase
```

## Coordination Commands
```bash
# Run multiple Claude instances
# Terminal 1
claude "Research authentication patterns" > research.md

# Terminal 2 (after research)
claude "Implement auth based on research.md" > auth.ts

# Terminal 3 (parallel with Terminal 2)
claude "Write test plan for auth" > test-plan.md
```

## Anti-Patterns
```
❌ Agents modifying same files
❌ Circular dependencies
❌ No clear ownership
❌ Missing sync points
❌ Conflicting outputs
```

## Best Practices
```
✅ Clear task boundaries
✅ Explicit dependencies
✅ Single file ownership
✅ Regular sync points
✅ Conflict resolution plan
```

---
Last updated: 2026-01-27
