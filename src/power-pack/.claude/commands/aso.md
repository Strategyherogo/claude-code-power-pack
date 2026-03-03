# Skill: aso
App Store Optimization — keyword research, competitor analysis, and metadata update via aso-mcp + asc-mcp.

## Trigger
`/aso`, "aso research", "keyword research [app]", "optimize [app]", "aso [app name]"

## Apps (from ASC)
| Name | ID | Bundle |
|------|----|--------|
| Wattora | 6759666880 | com.wattora.app |
| Mbox to EML Converter | 6757957380 | com.evgenygo.emailconverter |
| AI API Usage Battery | 6758680488 | com.dev.phytimer.ap |
| Phygital Timer | 6478761128 | com.dev.phytimer.app |
| IOS Home Screen Layout Master | 6756375182 | com.evgenygoncharov.iphonelayoutoptimizer |
| eXpense - Money Tracker | 6476440873 | com.dev.expenceapp |

## Workflow

### Step 1 — Identify Target App
If app not specified, ask which app. Otherwise proceed.

### Step 2 — Keyword Research (run in parallel)
Use `mcp__aso-mcp__search_keywords` for 3-5 seed keywords relevant to the app.
Use `mcp__aso-mcp__suggest_keywords` for additional keyword ideas.

Scoring:
- **Traffic** (1-10): higher = more searches
- **Difficulty** (1-10): higher = harder to rank
- **Sweet spot**: Traffic ≥ 6, Difficulty ≤ 7

### Step 3 — Competitor Analysis
Use `mcp__aso-mcp__analyze_competitors` with the app's bundle ID.
Use `mcp__aso-mcp__keyword_gap` to find keywords competitors rank for but we don't.

### Step 4 — Get Current Metadata
Use `mcp__aso-mcp__connect_get_metadata` (or `mcp__asc-mcp__apps_get_metadata`) to read current title, subtitle, keywords, description.

### Step 5 — Generate Recommendations
Produce a keyword shortlist ranked by opportunity score (Traffic / Difficulty).
Draft updated metadata fields:
- **Title** (30 chars max): primary keyword in title
- **Subtitle** (30 chars max): secondary keyword
- **Keywords** (100 chars max, comma-separated): high-traffic, low-difficulty terms
- **Description**: weave top keywords naturally, focus on benefits

### Step 6 — Apply Updates (only if user confirms)
Use `mcp__aso-mcp__connect_update_metadata` or `mcp__aso-mcp__connect_batch_update_metadata` to push changes.
Confirm each field before writing: "Update title to X? (current: Y)"

## Output Format

```
## ASO Report — [App Name] — [Date]

### Keyword Opportunities
| Keyword | Traffic | Difficulty | Opportunity | Currently Ranking? |
|---------|---------|-----------|-------------|-------------------|

### Competitor Gaps
Top 3 keywords competitors rank for that we're missing:

### Recommended Metadata Changes
**Title:** [current] → [proposed]
**Subtitle:** [current] → [proposed]
**Keywords:** [current] → [proposed]

### Description Changes
[diff showing what to add/remove]

→ Apply changes? (y/n)
```

## Country Codes
Default: `us`. For localized research add country arg: `mcp__aso-mcp__search_keywords country=tr` (Turkey), `de` (Germany), `gb` (UK).

## Notes
- aso-mcp is scraper-based — no API key needed, rate limits apply
- asc-mcp required for metadata writes (uses ASC API key from .mcp.json)
- Apple 2025: screenshot visible text counts for keyword ranking — sync with vmk:screenshot skill
- Run after any major app update or every 30 days for freshness

---
Last updated: 2026-02-27
