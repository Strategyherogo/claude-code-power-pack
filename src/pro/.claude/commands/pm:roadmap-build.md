# Skill: pm:roadmap-build
Create strategic product roadmaps with clear milestones.

## Auto-Trigger
**When:** "build roadmap", "product roadmap", "quarterly plan", "release plan", "project timeline"

## Roadmap Building Workflow

### Step 1: Define the Vision (15 min)
```
□ What problem are we solving?
□ Who is the target user?
□ What does success look like in 3 months? 6 months? 12 months?
□ What are the key constraints (time, budget, team)?
```

### Step 2: Gather Inputs (30 min)
```
□ Customer feedback and requests
□ Competitive analysis gaps
□ Technical debt priorities
□ Business objectives (OKRs)
□ Team capacity
□ Dependencies on other teams
```

### Step 3: Build the Roadmap

#### 3-Month Roadmap Template
```markdown
# [Product Name] Roadmap - Q[X] 2026

## Vision
[One sentence describing where we're headed]

## Success Metrics
- [ ] [Metric 1]: [current] → [target]
- [ ] [Metric 2]: [current] → [target]

---

## Month 1: [Theme Name]
**Goal:** [What we're trying to achieve]

| Week | Milestone | Owner | Status |
|------|-----------|-------|--------|
| 1 | [Deliverable] | [name] | 🔴 Not started |
| 2 | [Deliverable] | [name] | 🟡 In progress |
| 3 | [Deliverable] | [name] | 🟢 Complete |
| 4 | [Deliverable] | [name] | ⚪ Blocked |

**Key Risks:**
- [Risk 1]: [Mitigation]

---

## Month 2: [Theme Name]
**Goal:** [What we're trying to achieve]

| Week | Milestone | Owner | Status |
|------|-----------|-------|--------|
| 5-6 | [Deliverable] | [name] | |
| 7-8 | [Deliverable] | [name] | |

**Key Risks:**
- [Risk 1]: [Mitigation]

---

## Month 3: [Theme Name]
**Goal:** [What we're trying to achieve]

| Week | Milestone | Owner | Status |
|------|-----------|-------|--------|
| 9-10 | [Deliverable] | [name] | |
| 11-12 | [Deliverable] | [name] | |

**Key Risks:**
- [Risk 1]: [Mitigation]

---

## Dependencies
- [ ] [Team/System]: [What we need from them]
- [ ] [Team/System]: [What we need from them]

## Out of Scope (Not This Quarter)
- [Feature/work we're explicitly not doing]
- [Feature/work we're explicitly not doing]
```

### Step 4: Validate and Refine
```
□ Review with engineering (is it feasible?)
□ Review with stakeholders (is it aligned?)
□ Check dependencies (are they confirmed?)
□ Buffer time (add 20% for unknowns)
□ Identify risks and mitigations
```

## Roadmap Formats

### Timeline View (Gantt-style)
```
        Jan         Feb         Mar
        ─────────── ─────────── ───────────
Feature A ████████
Feature B     ████████████
Feature C             ████████████████
```

### Now-Next-Later
```
┌─────────────┬─────────────┬─────────────┐
│     NOW     │    NEXT     │    LATER    │
│  (0-4 wks)  │  (1-3 mo)   │   (3-6 mo)  │
├─────────────┼─────────────┼─────────────┤
│ Feature A   │ Feature D   │ Feature G   │
│ Feature B   │ Feature E   │ Feature H   │
│ Feature C   │ Feature F   │             │
└─────────────┴─────────────┴─────────────┘
```

### Milestone-Based
```
🎯 Alpha Release (Week 4)
   └── Feature A complete
   └── Basic functionality working

🎯 Beta Release (Week 8)
   └── Feature B complete
   └── User testing begins

🎯 GA Release (Week 12)
   └── All features complete
   └── Documentation ready
```

## Roadmap Review Cadence
```
Weekly:  Status updates (15 min)
Monthly: Progress review (1 hour)
Quarterly: Roadmap refresh (half day)
```

## Common Pitfalls
```
❌ Too many items (keep it focused)
❌ No ownership assigned
❌ Missing dependencies
❌ No buffer for unknowns
❌ Scope creep mid-quarter
❌ Not communicating changes
```

## Use with Other Skills
- `/pm:feature-prioritize` → Decide what goes on roadmap
- `/write-plan` → Detail individual features
- `/verify` → Validate milestones complete

---
Last updated: 2026-01-27
