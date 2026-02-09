# Skill: pm:feature-prioritize
Decide which features to build next using RICE scoring.

## Auto-Trigger
**When:** "prioritize features", "RICE score", "what to build next", "feature priority", "backlog prioritization"

## RICE Scoring Framework

### The Formula
```
RICE Score = (Reach × Impact × Confidence) / Effort
```

### Step 1: Score Each Factor

#### Reach (R) - How many people affected?
| Score | Definition | Example |
|-------|------------|---------|
| 1 | Just you | Personal tool |
| 10 | 5-10 users | Team feature |
| 50 | 50-100 users | Department |
| 100 | 100-500 users | Company-wide |
| 500 | 500+ users | Public product |

#### Impact (I) - How much value per person?
| Score | Definition | Example |
|-------|------------|---------|
| 0.25 | Minimal | Cosmetic change |
| 0.5 | Low | Minor convenience |
| 1 | Medium | Noticeable improvement |
| 2 | High | Significant time saving |
| 3 | Massive | Game changer |

#### Confidence (C) - How sure are you?
| Score | Definition | When to use |
|-------|------------|-------------|
| 100% | High | Data-backed, tested hypothesis |
| 80% | Medium | Strong intuition, some data |
| 50% | Low | Gut feeling, no data |

#### Effort (E) - Person-weeks to complete
| Score | Definition |
|-------|------------|
| 0.5 | Few hours to 1 day |
| 1 | 1 week |
| 2 | 2 weeks |
| 4 | 1 month |
| 8 | 2 months |

### Step 2: Calculate and Rank

```markdown
## Feature Prioritization - [Project Name]

| Feature | Reach | Impact | Conf | Effort | RICE Score |
|---------|-------|--------|------|--------|------------|
| [Feature A] | [R] | [I] | [C%] | [E] | [score] |
| [Feature B] | [R] | [I] | [C%] | [E] | [score] |
| [Feature C] | [R] | [I] | [C%] | [E] | [score] |

### Priority Order
1. [Highest RICE]
2. [Second]
3. [Third]
```

### Step 3: Apply Adjustments

#### Strategic Multipliers
```
□ Aligns with company OKRs? → +20%
□ Competitive necessity? → +30%
□ Technical debt reduction? → +10%
□ Customer explicitly requested? → +25%
□ Blocking other features? → +50%
```

#### Risk Discounts
```
□ Requires new technology? → -20%
□ Dependencies on other teams? → -15%
□ Regulatory implications? → -25%
□ Uncertain requirements? → -30%
```

## Alternative Frameworks

### ICE Score (simpler)
```
ICE = Impact × Confidence × Ease
Scale: 1-10 for each
```

### MoSCoW Method
```
Must Have    - Critical for release
Should Have  - Important but not critical
Could Have   - Nice to have
Won't Have   - Out of scope
```

### Value vs Effort Matrix
```
         High Value
              │
    Quick     │    Big Bets
    Wins      │    (plan carefully)
              │
─────────────┼──────────────
              │    Low Value
    Fill-ins  │    Time Sinks
              │    (avoid)
              │
         High Effort
```

## Prioritization Checklist
```
□ List all candidate features
□ Score each using RICE
□ Apply strategic adjustments
□ Validate with stakeholders
□ Consider dependencies
□ Document rationale
□ Review quarterly
```

## Output Template

```markdown
# Feature Prioritization - Q1 2026

## Top 5 Priorities

### 1. [Feature Name] - RICE: [score]
**Why:** [1-2 sentence rationale]
**Effort:** [X] weeks
**Owner:** [name]
**Dependencies:** [list]

### 2. [Feature Name] - RICE: [score]
...

## Not Prioritized This Quarter
- [Feature X] - Low reach
- [Feature Y] - Too much effort
- [Feature Z] - Waiting on dependency
```

---
Last updated: 2026-01-27
