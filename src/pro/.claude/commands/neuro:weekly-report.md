# Skill: neuro:weekly-report
Generate weekly neuroperformance report from HRV/stress/energy data.

## Auto-Trigger
**When:** "weekly neuro report", "hrv summary", "stress report", "energy trends", "performance report"

## Data Sources
- **Database:** `unified_personal_data_2025.db` (621+ days)
- **Metrics:** HRV, stress, energy, sleep, recovery
- **Devices:** Apple Watch, Oura, other wearables

## Weekly Report Template

```markdown
# Neuroperformance Weekly Report
**Week:** [YYYY-WXX] ([date range])
**Generated:** [timestamp]

---

## Executive Summary
[One paragraph: Overall status, notable patterns, key recommendations]

---

## Key Metrics

### HRV (Heart Rate Variability)
| Metric | This Week | Last Week | 4-Week Avg | Trend |
|--------|-----------|-----------|------------|-------|
| Average | XX ms | XX ms | XX ms | ↑/↓/→ |
| Morning Avg | XX ms | XX ms | XX ms | ↑/↓/→ |
| Best Day | XX ms (Day) | | | |
| Lowest Day | XX ms (Day) | | | |

**Interpretation:** [What this means for recovery/readiness]

### Stress Index
| Metric | This Week | Last Week | Trend |
|--------|-----------|-----------|-------|
| Avg Daily Stress | X.X/10 | X.X/10 | ↑/↓ |
| High Stress Days | X | X | |
| Recovery Days | X | X | |

**Patterns:** [When stress peaked, what correlated]

### Energy Levels
| Day | Morning | Afternoon | Evening | Notes |
|-----|---------|-----------|---------|-------|
| Mon | X/10 | X/10 | X/10 | |
| Tue | X/10 | X/10 | X/10 | |
| Wed | X/10 | X/10 | X/10 | |
| Thu | X/10 | X/10 | X/10 | |
| Fri | X/10 | X/10 | X/10 | |
| Sat | X/10 | X/10 | X/10 | |
| Sun | X/10 | X/10 | X/10 | |

**Best energy window:** [time range]
**Energy dips:** [patterns noticed]

### Sleep Quality
| Metric | This Week | Target | Status |
|--------|-----------|--------|--------|
| Avg Duration | X.Xh | 7-8h | ✅/⚠️ |
| Avg Efficiency | XX% | >85% | ✅/⚠️ |
| Deep Sleep | XX% | >15% | ✅/⚠️ |
| REM Sleep | XX% | >20% | ✅/⚠️ |

---

## Correlations Observed

### Positive
- [What improved metrics this week]
- [Behaviors that correlated with good days]

### Negative
- [What hurt metrics]
- [Patterns to avoid]

---

## Week in Review

### Best Day: [Day]
- HRV: XX ms
- Energy: X/10
- What worked: [factors]

### Hardest Day: [Day]
- HRV: XX ms
- Stress: X/10
- Contributing factors: [factors]

---

## Recommendations

### This Week
1. **[Priority action]** - [why]
2. **[Secondary action]** - [why]

### Experiment to Try
- [Specific intervention to test next week]
- Measure: [what to track]

### Maintain
- [What's working, keep doing]

---

## Tracking Notes
[Any data quality issues, missed days, device changes]

---

## Historical Context
- **30-day trend:** [improving/stable/declining]
- **vs. Same week last month:** [comparison]
- **Notable milestone:** [if any]
```

## Data Queries

### Weekly Averages
```sql
SELECT
  AVG(hrv) as avg_hrv,
  AVG(stress) as avg_stress,
  AVG(energy) as avg_energy
FROM daily_metrics
WHERE date BETWEEN date('now', '-7 days') AND date('now');
```

### Day Comparison
```sql
SELECT
  date,
  hrv,
  stress,
  energy,
  sleep_duration
FROM daily_metrics
WHERE date BETWEEN date('now', '-7 days') AND date('now')
ORDER BY date;
```

## Quick Commands
```
/neuro:weekly-report              # This week
/neuro:weekly-report last         # Last week
/neuro:weekly-report compare      # Compare to previous
/neuro:weekly-report trends       # 4-week trends
```

## Integration
- **Database:** Query via postgres/sqlite MCP
- **Visualization:** Generate charts if needed
- **Storage:** Save to `2. Areas/03-neuroperformance/reports/`

---
Last updated: 2026-01-29
