# Skill: email:compliance-report
Generate professional, defensible email investigation reports.

## Auto-Trigger
**When:** "email compliance", "investigation report", "audit report", "compliance documentation"

## Report Generation Workflow

### Step 1: Gather Evidence
```
□ All relevant emails exported
□ Metadata captured (headers, timestamps, IPs)
□ Attachments catalogued
□ Chain of custody established
□ Search criteria documented
```

### Step 2: Structure the Report

#### Cover Page
```markdown
# Email Investigation Report

**Matter:** [Case name/number]
**Date:** [Report date]
**Investigator:** [Your name]
**Requested By:** [Client/department]
**Classification:** [Confidential/Internal/Public]
```

#### Executive Summary (1 page max)
```markdown
## Executive Summary

### Scope
- Time period: [start] to [end]
- Custodians: [list]
- Search terms: [keywords used]

### Key Findings
1. [Finding 1 - most important]
2. [Finding 2]
3. [Finding 3]

### Recommendations
- [Action item 1]
- [Action item 2]
```

#### Detailed Findings
```markdown
## Findings

### Finding 1: [Title]
**Date:** [When discovered]
**Evidence:** Email ID [xxx], dated [date]
**Analysis:** [What this means]
**Supporting Documents:** Appendix A-[x]

### Finding 2: [Title]
[Same structure]
```

#### Timeline
```markdown
## Timeline of Events

| Date | Time | Event | Evidence Ref |
|------|------|-------|--------------|
| [date] | [time] | [what happened] | Email #[x] |
```

### Step 3: Documentation Standards

#### Chain of Custody
```markdown
## Chain of Custody

| Date | Action | Performed By | Witness |
|------|--------|--------------|---------|
| [date] | Data exported from [source] | [name] | [name] |
| [date] | Transferred to [location] | [name] | [name] |
```

#### Evidence Appendix
```markdown
## Appendix A: Evidence Index

| Ref | Type | Date | From | To | Subject | Significance |
|-----|------|------|------|-----|---------|--------------|
| A-1 | Email | [date] | [sender] | [recipient] | [subject] | [why relevant] |
```

### Step 4: Quality Checklist
```
□ All findings cite specific evidence (email ID, date, quote)
□ Timeline is chronologically accurate
□ Chain of custody is complete
□ No speculation - facts only
□ Professional tone maintained
□ Legal review completed (if required)
□ Report dated and investigator signed
```

## Report Best Practices

### DO
- Use passive voice for objectivity
- Quote relevant portions verbatim
- Include screenshots where helpful
- Acknowledge limitations and gaps
- Number all findings and evidence

### DON'T
- Include hearsay or speculation
- Draw legal conclusions
- Include privileged communications
- Editorialize or use emotional language
- Assume facts not in evidence

## Output
Save to: `reports/email-investigation-[matter]-[date].md`

---
Last updated: 2026-01-27
