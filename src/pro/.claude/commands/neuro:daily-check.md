# Neuroperformance Daily Check
Quick ANS assessment using your biometric database.

## Auto-Trigger
**When:** Morning session start, or "how am I doing today"

## Quick Assessment Query
```sql
-- Run against unified_personal_data_2025.db
SELECT
    date,
    hrv_rmssd,
    stress_day,
    energy_day,
    CASE
        WHEN stress_day > 70 AND energy_day < 40 THEN '🔴 HIGH RISK - Light work only'
        WHEN stress_day > 50 AND energy_day < 50 THEN '🟡 MODERATE - Avoid complex tasks'
        WHEN stress_day < 40 AND energy_day > 60 THEN '🟢 OPTIMAL - Peak performance window'
        ELSE '🟡 FUNCTIONAL - Normal capacity'
    END as state
FROM daily_metrics
WHERE date >= date('now', '-7 days')
ORDER BY date DESC
LIMIT 7;
```

## State-Based Recommendations

### 🟢 OPTIMAL (stress < 40, energy > 60)
- Deep work: Architecture, complex coding
- High-stakes: Client calls, presentations
- Creative: New feature design
- **Protect this window!**

### 🟡 MODERATE (stress 40-60 OR energy 40-60)
- Routine tasks: Code reviews, documentation
- Collaborative: Team meetings, pair programming
- Administrative: Email, planning
- **Avoid:** Complex debugging, new architecture

### 🔴 HIGH RISK (stress > 70 AND energy < 40)
- Recovery: Walk, meditation, nap
- Light admin: Organize files, simple emails
- **Avoid:** Any coding, important decisions
- **Consider:** Ending work early

## Weekly Pattern Reference
| Day | Typical State | Best For |
|-----|---------------|----------|
| Monday | Moderate | Planning, admin |
| Tuesday | Optimal | Deep work, coding |
| Wednesday | Moderate | Collaboration |
| Thursday | Variable | Check morning state |
| Friday | Declining | Wrap-up, review |

## Database Location
`~/ClaudeCodeWorkspace/2. Areas/neuroperformance/data/personal_health_data.db`

## Quick Command
```bash
sqlite3 ~/ClaudeCodeWorkspace/2.\ Areas/neuroperformance/data/personal_health_data.db \
  "SELECT date, hrv_rmssd, stress_day, energy_day FROM daily_metrics ORDER BY date DESC LIMIT 1;"
```

---
Last updated: 2026-01-27
