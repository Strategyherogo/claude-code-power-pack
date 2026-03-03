# Skill: report-review
Automated quality checks for markdown reports before sharing.

## Auto-Trigger
**When:** "review report", "check report", "report QA", "validate report"

## Arguments
- `$ARGUMENTS` — path to the .md report file (optional, will prompt if missing)

## Checks (run all)

### 1. Table Integrity
```
For every markdown table in the file:
  □ Header row has same column count as separator row
  □ All data rows have same column count as header
  □ Separator row uses valid syntax (|---|)
  □ No orphaned footer rows with mismatched column count
  □ Pipe alignment is consistent (warn if raw pipes misalign by >5 chars)
```

**How to check:**
```bash
# Find all tables — look for lines starting with |
grep -n '^|' "$FILE"
# Count pipes per line within each table block
# Flag any line where pipe count differs from its table's header
```

### 2. Section Numbering
```
For all ### Finding/Section/Step headers:
  □ Numbers are sequential (no gaps: 1,2,4 is bad)
  □ Numbers start at 1
  □ No duplicates
For ## top-level numbered sections:
  □ Same sequential check
```

### 3. Cross-Reference Consistency
```
For any number that appears in multiple places:
  □ Total in summary matches sum of parts in body
  □ Percentages are mathematically correct (e.g., 36/115 = 31.3%, not 34.6%)
  □ "X of Y" claims match the actual count in tables/lists
Key checks:
  - Total cases in Executive Summary = sum of monthly totals
  - Total breaches = sum of breaches by responder in appendix
  - No-response count = number of rows in no-response table
  - Compliance % = compliant / denominator (flag which denominator is used)
```

### 4. Compliance % Basis Detection
```
When the report contains compliance percentages:
  □ Detect denominator: total cases OR responded cases
  □ Flag if different sections use different bases
  □ Recalculate and show both:
    - "58% (total basis: 22/38)" vs "63% (responded basis: 22/35)"
  □ Warn if email draft uses a different basis than the report
```

### 5. Formatting Quality
```
  □ No # - patterns (broken headers from commented-out lists)
  □ No TODO/FIXME/TBD left in text
  □ No orphaned bold markers (**text without closing **)
  □ No backtick code markers in content meant for email
  □ Consistent heading hierarchy (no jumping from ## to ####)
  □ Blank line before and after every table
  □ No trailing whitespace on lines
```

### 6. Data Completeness
```
  □ Every table referenced in findings has corresponding data
  □ No empty table cells where data is expected (vs intentional "—")
  □ Appendix case counts match body claims
```

## Output Format

```markdown
## Report Review: [filename]

### PASS (X checks)
- [x] Table integrity — N tables, all valid
- [x] Section numbering — sequential 1-5

### FAIL (X issues)
- [ ] **Cross-reference:** Summary says 36 breaches, appendix sums to 35
- [ ] **Table L42:** Header has 5 columns, row 47 has 4
- [ ] **Compliance %:** Section 2 uses total basis (58%), Section 9 uses responded basis (63%)

### WARN (X advisories)
- [ ] Line 223: Internal note "Not sure if..." — remove or formalize?
- [ ] Table at L68: Pipes misaligned (cosmetic)

### Auto-Fix Available
The following can be fixed automatically (confirm Y/N):
1. Renumber findings 1,2,4,5 → 1,2,3,4
2. Add blank lines before tables at L68, L101
3. Remove trailing whitespace (14 lines)
```

## Workflow

1. **Read the file** (use offset+limit for files >300 lines — never read whole file at once)
2. **Run all 6 checks** in parallel where possible
3. **Present results** in the output format above
4. **Offer auto-fix** for anything that can be corrected programmatically
5. **If an email draft exists** in the same directory, cross-check numbers between report and email

## Notes
- This skill is read-only by default — only edits if user confirms auto-fix
- For large reports, use subagent to process data validation
- Pair with `/report-pdf` for final export after review passes

---
Last updated: 2026-02-10
