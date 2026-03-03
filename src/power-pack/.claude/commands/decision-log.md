# Skill: decision-log
Architecture Decision Records (ADR) management.

## Auto-Trigger
**When:** "decision log", "adr", "architecture decision", "why did we", "document decision", "decision record"

## ADR Template

```markdown
# ADR-[NUMBER]: [Title]

**Date:** [YYYY-MM-DD]
**Status:** [Proposed | Accepted | Deprecated | Superseded]
**Deciders:** [Names]

## Context

[What is the issue that we're seeing that is motivating this decision or change?]

## Decision

[What is the change that we're proposing and/or doing?]

## Consequences

### Positive
- [Good outcome 1]
- [Good outcome 2]

### Negative
- [Tradeoff 1]
- [Tradeoff 2]

### Neutral
- [Side effect that's neither good nor bad]

## Alternatives Considered

### Option A: [Name]
- **Pros:** [advantages]
- **Cons:** [disadvantages]
- **Why rejected:** [reason]

### Option B: [Name]
- **Pros:** [advantages]
- **Cons:** [disadvantages]
- **Why rejected:** [reason]

## Related

- Supersedes: ADR-[X]
- Related to: ADR-[Y], ADR-[Z]
- References: [links to relevant docs]
```

## ADR Directory Structure

```
docs/
└── adr/
    ├── 0001-record-architecture-decisions.md
    ├── 0002-use-postgresql-for-database.md
    ├── 0003-adopt-microservices-architecture.md
    ├── 0004-use-jwt-for-authentication.md
    └── README.md
```

## Example ADRs

### Database Choice
```markdown
# ADR-0002: Use PostgreSQL for Primary Database

**Date:** 2026-01-15
**Status:** Accepted
**Deciders:** Tech Lead, CTO

## Context
We need to choose a primary database for our new application.
We expect moderate scale (10k-100k users) with complex queries
and need strong ACID compliance.

## Decision
Use PostgreSQL as our primary database.

## Consequences

### Positive
- Strong ACID compliance for financial transactions
- Excellent JSON support for flexible schemas
- Rich ecosystem of tools and extensions
- Team has existing PostgreSQL expertise

### Negative
- Horizontal scaling more complex than NoSQL options
- Requires more upfront schema design

## Alternatives Considered

### MySQL
- Pros: Wide adoption, good performance
- Cons: Less feature-rich, JSON support not as mature
- Why rejected: PostgreSQL's features better fit our needs

### MongoDB
- Pros: Easy horizontal scaling, flexible schema
- Cons: Weaker consistency guarantees, less suited for transactions
- Why rejected: Need ACID for financial features
```

### Authentication Strategy
```markdown
# ADR-0004: Use JWT for API Authentication

**Date:** 2026-01-20
**Status:** Accepted
**Deciders:** Security Lead, Backend Lead

## Context
Need to implement authentication for our REST API that will
be consumed by web and mobile clients.

## Decision
Use JWT (JSON Web Tokens) with short-lived access tokens
(15 min) and longer-lived refresh tokens (7 days).

## Consequences

### Positive
- Stateless: no server-side session storage
- Works well across microservices
- Easy to include user claims in token

### Negative
- Token revocation requires additional infrastructure
- Token size larger than session IDs

## Alternatives Considered

### Session-based Auth
- Why rejected: Doesn't scale well for microservices

### OAuth2 only
- Why rejected: Overkill for first-party clients
```

## Quick Reference

### Status Values
| Status | Meaning |
|--------|---------|
| **Proposed** | Under discussion |
| **Accepted** | Approved and in effect |
| **Deprecated** | No longer recommended |
| **Superseded** | Replaced by another ADR |

### When to Write an ADR
- Choosing a technology or framework
- Defining system architecture
- Establishing coding standards
- Making security decisions
- Changing significant existing decisions

### When NOT to Write an ADR
- Trivial implementation details
- Temporary workarounds
- Decisions that are easily reversible

## ADR Management Commands

### Create New ADR
```bash
# Get next number
NEXT=$(ls docs/adr/*.md 2>/dev/null | wc -l | xargs -I {} expr {} + 1)
NUM=$(printf "%04d" $NEXT)

# Create file
touch "docs/adr/${NUM}-decision-title.md"
```

### List ADRs
```bash
# Show all with status
grep -l "Status:" docs/adr/*.md | while read f; do
  title=$(head -1 "$f" | sed 's/# //')
  status=$(grep "Status:" "$f" | head -1)
  echo "$title - $status"
done
```

## Quick Commands
```
/decision-log new [title]    # Create new ADR
/decision-log list           # List all ADRs
/decision-log search [term]  # Search ADRs
/decision-log template       # Show template
```

## Integration

### In Code Comments
```javascript
// See ADR-0004 for authentication decision
const token = jwt.sign(payload, secret);
```

### In PR Descriptions
```markdown
## Related ADRs
- Implements ADR-0004 (JWT Authentication)
```

---
Last updated: 2026-01-29
