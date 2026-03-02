# Skill: data-validate
Validation framework for forensic and data analysis work — catch errors before presenting findings.

## Auto-Trigger
**When:** "analyze data", "forensic", "investigate", "SLA report", "breach analysis", "audit logs"

## Overview
High-stakes data analysis (forensic investigations, SLA reports, compliance audits) requires bulletproof accuracy. This skill provides a validation framework that catches timezone errors, role conflation, and numerical mistakes before findings reach leadership.

---

## Pre-Analysis Validation Checklist

### 1. Data Source Inventory
Before any analysis, document:
```markdown
## Data Sources
| Source | Format | Rows/Entries | Date Range | Timezone | Coverage |
|--------|--------|--------------|------------|----------|----------|
| Dropbox audit | CSV | 1,247 | 2024-01-15 to 2024-02-20 | UTC | 100% |
| Email logs | MBOX | 3,891 | 2024-01-10 to 2024-02-25 | Local (PST) | 95% |
| Laptop logs | TXT | 89,342 | 2024-01-01 to 2024-02-25 | UTC | 87% |
```

**Output this table BEFORE starting analysis** — user can catch coverage gaps early.

### 2. Timezone Normalization
**CRITICAL:** All timestamps must be normalized to UTC before correlation.

```python
# Validation script template
import pandas as pd
from datetime import datetime
import pytz

def validate_timestamps(df, timestamp_col, source_tz='UTC'):
    """
    Validate and normalize timestamps to UTC.
    Returns: (normalized_df, validation_report)
    """
    report = {
        'source': source_tz,
        'total_rows': len(df),
        'null_timestamps': df[timestamp_col].isnull().sum(),
        'min_timestamp': None,
        'max_timestamp': None,
        'timezone_naive_count': 0
    }

    # Check for timezone-naive timestamps
    if df[timestamp_col].dtype == 'object':
        sample = pd.to_datetime(df[timestamp_col].iloc[0])
        if sample.tzinfo is None:
            report['timezone_naive_count'] = len(df)
            # Localize to source timezone, then convert to UTC
            df[timestamp_col] = pd.to_datetime(df[timestamp_col]).dt.tz_localize(source_tz).dt.tz_convert('UTC')

    report['min_timestamp'] = df[timestamp_col].min()
    report['max_timestamp'] = df[timestamp_col].max()

    return df, report

# ALWAYS call this and show validation_report before analysis
```

**Present to user:**
```
🕐 Timezone Validation Report
   Source: Email logs (PST) → UTC
   Rows: 3,891
   Range: 2024-01-10 08:00:00 UTC to 2024-02-25 23:45:00 UTC
   Issues: 0 null timestamps, 3,891 normalized from PST
   ✅ Safe to proceed
```

### 3. Sample Row Verification
Show 3-5 sample rows from each data source:

```
📊 Sample Rows (Email Logs)
   Row 453: 2024-02-15 14:23:00 UTC | from: employee@company.com | to: external@competitor.com | subject: "Q4 Revenue Data"
   Row 891: 2024-02-18 09:15:00 UTC | from: employee@company.com | to: personal@gmail.com | subject: "Fwd: Customer List"
   Row 1205: 2024-02-20 16:47:00 UTC | from: manager@company.com | to: employee@company.com | subject: "Re: Access Request"

Does this look correct? Proceed with analysis?
```

**User can spot data issues immediately** (wrong columns, garbled data, misaligned sources).

---

## During Analysis Validation

### 4. Cross-Reference Numerical Claims
Before presenting ANY numerical finding:

```markdown
## Claim Validation Checklist
□ Stated average matches actual calculation
□ Count assertions match `len(df)` or `df.groupby().size()`
□ Specific examples (e.g., "ticket #211") verified against source data
□ Percentages add up to 100%
□ Date ranges match actual data min/max
```

**Example validation:**
```
Claim: "Average response time was 4.2 hours"
Validation:
  df['response_time'].mean() = 4.187 hours ✅
  Sample check: ticket #105 = 3.5h, #211 = 6.1h, #445 = 2.8h ✅
  Safe to present
```

### 5. Role Disambiguation
**Common error:** Conflating assignee vs responder, creator vs commenter.

Before analysis, clarify:
```
Role Definitions for This Analysis:
- Assignee: Person ticket is assigned TO (responsible for resolution)
- Responder: Person who REPLIED to the ticket (may not be assignee)
- Creator: Person who OPENED the ticket
- Commenter: Anyone who added comments (includes assignee, responder, observers)

Analysis will use: [specify which role]
```

### 6. Timeline Contradiction Detection
When correlating events across sources:

```python
def detect_contradictions(timeline_df):
    """
    Find events that can't both be true.
    Example: User deleted files while laptop was asleep.
    """
    contradictions = []

    for idx, row in timeline_df.iterrows():
        # Check if laptop state contradicts action
        if row['event'] == 'file_deleted' and row['laptop_state'] == 'asleep':
            contradictions.append({
                'timestamp': row['timestamp'],
                'issue': 'File deletion while laptop asleep',
                'sources': ['dropbox_audit', 'laptop_logs'],
                'likely_cause': 'Mobile device deletion or timezone error'
            })

    return contradictions

# ALWAYS run and show contradictions before final report
```

**Output to user:**
```
⚠️  Timeline Contradictions Detected (2)
   1. 2024-02-18 14:23 UTC: File deletion while laptop asleep
      → Likely: mobile device or timezone error
   2. 2024-02-20 09:15 UTC: Email sent from office IP while laptop at home IP
      → Likely: VPN or IP database stale

Should I investigate these before finalizing the report?
```

---

## Post-Analysis Validation

### 7. Executive Summary Sanity Check
Before presenting findings to leadership:

```markdown
## Executive Summary Checklist
□ No timezone-naive timestamps in report
□ All numerical claims cross-referenced against source
□ No conflated roles (assignee vs responder)
□ All specific examples (ticket IDs, timestamps, names) verified
□ Contradictions flagged or explained
□ Confidence levels stated for inferences
□ Source attributions clear (which log provided which data point)
```

### 8. Confidence Scoring
For each finding, assign confidence:

| Level | Criteria | Example |
|-------|----------|---------|
| **High** | Direct evidence, single source, verified | "Employee deleted 247 files on 2024-02-18 14:23 UTC (Dropbox audit log)" |
| **Medium** | Corroborated across 2+ sources | "Email sent from competitor domain 30 min after file access (email logs + Dropbox audit)" |
| **Low** | Inference, requires assumption | "Likely exfiltration intent based on file type pattern" |
| **Speculative** | No direct evidence, educated guess | "Employee may have been recruited by competitor (no evidence)" |

**Present findings with confidence markers:**
```
High Confidence:
- 247 files deleted 2024-02-18 14:23-15:41 UTC (Dropbox audit)
- 15 files transferred via Dropbox Transfer to external email (Dropbox audit)

Medium Confidence:
- Deletion followed by immediate Dropbox Transfer within 30 min (timeline correlation)

Low Confidence:
- Employee accessed files from unusual IP (could be VPN or travel)
```

---

## Validation Template

### For Forensic Investigations
```markdown
# Validation Report: [Investigation Name]

## 1. Data Quality
- **Sources:** [count] sources loaded
- **Timezone:** All normalized to UTC ✅
- **Coverage:** [date range], [X]% complete
- **Sample check:** [show 3 rows]

## 2. Cross-Reference
- **Contradictions:** [count] detected, [count] explained
- **Gaps:** [time gaps >4 hours]
- **Overlaps:** [count] events corroborated across 2+ sources

## 3. Numerical Claims
- **Averages:** Verified against source ✅
- **Counts:** Match `len(df)` ✅
- **Specific examples:** All ticket IDs verified ✅

## 4. Confidence Assessment
- High confidence findings: [count]
- Medium confidence findings: [count]
- Low confidence findings: [count]
- Speculative claims: [count] (flagged)

## 5. Ready for Leadership Review
□ All validations passed
□ Contradictions explained
□ Confidence levels stated
□ Timeline is timezone-consistent
□ No data accuracy errors

**Validated by:** [Your name]
**Timestamp:** [ISO timestamp]
```

---

## Integration with Other Skills

### Auto-Invoke During
- `/forensic-audit` - Forensic investigations
- `/email:compliance-report` - Compliance reporting
- `/log-analysis` - Log analysis workflows
- Any skill with "analyze", "investigate", "audit", "breach" in trigger

### Related Skills
- `/systematic-debug` - Root cause analysis
- `/root-trace` - Timeline reconstruction
- `/report-review` - Final report quality check

---

## Error Prevention Patterns

### Common Mistakes This Prevents

| Mistake | Prevention | Example |
|---------|------------|---------|
| **Timezone confusion** | Force UTC normalization upfront | "Laptop asleep" error in Dropbox investigation |
| **Role conflation** | Explicit role definitions before analysis | Assignee vs responder in SLA report |
| **Wrong averages** | Show calculation validation | Response time avg claimed vs actual |
| **Unverified claims** | Require source citation for each finding | "Employee deleted files" needs audit log reference |
| **Missing data** | Coverage check before conclusions | "No activity" vs "no data available" |

---

**Usage Pattern:**

When starting any data analysis task:
1. Run this validation framework FIRST
2. Get user confirmation on data quality
3. Then proceed with analysis
4. Run validation again before presenting findings

**Time investment:** 3-5 minutes upfront saves hours of correction rounds.

---
Last updated: 2026-02-25
