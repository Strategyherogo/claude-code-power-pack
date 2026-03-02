# Skill: Forensic Audit

Structured forensic investigation workflow for analyzing audit logs, correlating evidence across data sources, and producing formal reports.

## Auto-Trigger
**When:** "forensic", "audit", "investigation", "evidence", "deletion analysis", "dropbox audit", "email forensics", "laptop log"

## Phase 0: Data Validation (MANDATORY)

**CRITICAL:** Run `/data-validate` framework before any analysis to prevent timezone errors, role conflation, and numerical mistakes.

**Required validations:**
1. ✅ All timestamps normalized to UTC
2. ✅ Data source table with coverage stats
3. ✅ 3-5 sample rows shown for user verification
4. ✅ Timezone assumptions explicitly stated
5. ✅ Role definitions clarified (assignee vs responder vs creator)

**User must confirm data quality before proceeding to Phase 1.**

---

## Phase 1: Scope & Ingest

Before any analysis, establish scope:
1. **Ask:** What data sources are available? (Dropbox logs, email exports, laptop logs, cloud activity, Transfers)
2. **Ask:** Who is the subject? What's the investigation question?
3. **Ask:** What date range matters?

For each data source provided:
```
- Read the file (CSV, JSON, log)
- Report coverage stats: total rows, date range, unique actors, missing data %
- **Normalize timestamps to UTC** (use validation script from /data-validate)
- Deduplicate entries
- **Show sample rows** (3-5) for user verification
- Output: "Ingested X rows from [source], covering [date range], [N] unique actors"

🕐 Timezone Validation Report
   Source: [name] ([original TZ]) → UTC
   Rows: [count]
   Range: [min] to [max] UTC
   Issues: [null count], [normalized count]
   ✅ Ready for analysis
```

**STOP and get user confirmation:** "Does the data look correct? Proceed with analysis?"

## Phase 2: Pattern Analysis

Run these analyses on the ingested data:

### Deletion Patterns
- Volume by date (histogram)
- Volume by actor
- Sequential vs batch operations
- File types targeted
- Folders/paths most affected

### Timeline Reconstruction
- Build chronological timeline of all actions
- Flag clusters (>50 actions within 1 hour)
- Identify first/last activity per actor
- Cross-reference with known events (termination, resignation, access revocation)

### Anomaly Detection
- Actions outside business hours (before 7am, after 8pm, weekends)
- Bulk operations (>100 files in single session)
- Access from unusual locations/IPs
- Privilege escalation patterns

**For every finding, record:**
- Exact source file and row/line number
- Timestamp
- Actor
- Action type
- Affected resource

## Phase 3: Cross-Source Correlation

When multiple data sources are available:
1. Match actors across sources (email <-> Dropbox <-> device)
2. Align timelines - did email activity precede deletions?
3. Check for Dropbox Transfers before deletions (exfiltration pattern)
4. Correlate device login/logout with cloud activity
5. Flag gaps - periods with activity in one source but not another

## Phase 4: Self-Validation

Before producing the final report:
1. **Spot-check** 5 random findings against raw source data
2. **Verify counts** - recount independently, compare with Phase 2 numbers
3. **Check actor attribution** - confirm the right person is linked to each action
4. **Flag uncertainty** - if any finding has <90% confidence, mark it explicitly
5. Output validation summary: "X/Y findings verified, Z flagged for manual review"

## Phase 5: Report

Output as **Markdown** (not PDF) unless user requests otherwise.

### Report Structure
```markdown
# Forensic Investigation Report

**Subject:** [name/entity]
**Period:** [date range]
**Data Sources:** [list with coverage stats]
**Prepared:** [date]

## Executive Summary
[3-5 sentences: what happened, key findings, severity]

## Data Coverage
| Source | Records | Date Range | Completeness |
|--------|---------|------------|-------------|

## Key Findings
### Finding 1: [title]
- **What:** [description]
- **When:** [timestamp range]
- **Evidence:** [source file, row numbers]
- **Confidence:** [High/Medium/Low]

## Timeline
[Chronological table of significant events]

## Cross-Source Correlation
[Where multiple sources confirm or contradict]

## Anomalies
[Unusual patterns with evidence references]

## Validation Notes
[What was spot-checked, any discrepancies found]

## Appendix
[Raw data tables for reference]
```

## Rules
- NEVER fabricate evidence - if data doesn't support a conclusion, say so
- Distinguish between correlation and causation
- Always distinguish roles: actor vs subject vs witness
- Use exact timestamps, not approximations
- Reference specific rows/entries, not just summaries
- If asked for breakdowns, provide the FULL breakdown, not a summary

## Related Skills
- `/commands:log-analysis` - General log parsing
- `/commands:gws-email-report` - GWS email investigation
- `/commands:email:forensic-workflow` - Email-specific forensics
- `/commands:report-pdf` - Convert final report to PDF if needed
