# Skill: fix-skills
Skill registry health check — find and fix mismatches between skill files and Claude Code's skill detection.

## Auto-Trigger
**When:** "fix skills", "broken skill", "skill not found", "unknown skill", weekly via /morning-check

---

## Diagnosis Workflow

### Step 1: Inventory Skill Files
```bash
# Count all .md files in commands/
SKILL_COUNT=$(ls -1 ~/.claude/commands/*.md 2>/dev/null | wc -l | tr -d ' ')
echo "Skill files on disk: $SKILL_COUNT"

# List all skill names (filename without .md)
ls -1 ~/.claude/commands/*.md | sed 's|.*/||; s|\.md$||' | sort > /tmp/skills-on-disk.txt

# Also check subdirectories (e.g., sales/)
find ~/.claude/commands/ -name "*.md" -not -name "README*" | sed 's|.*/commands/||; s|\.md$||' | sort > /tmp/skills-on-disk-full.txt
```

### Step 2: Test Invocability
For each skill file, check if it's invocable. Known failure patterns:
- File exists but skill name has special characters (colons, hyphens)
- File is in a subdirectory (e.g., `sales/forecast.md` vs `sales:forecast.md`)
- File has wrong naming convention

### Step 3: Identify Mismatches
```markdown
## Skill Health Report

### ✅ Working Skills
[List of skills that invoke correctly]

### ❌ Broken Skills (file exists, invocation fails)
| Skill File | Expected Name | Error | Fix |
|-----------|---------------|-------|-----|
| [filename] | /[expected-name] | [error] | [suggested fix] |

### ⚠️ Orphaned Files (no matching trigger)
| File | Last Modified | Likely Category |
|------|---------------|-----------------|
| [filename] | [date] | [category guess] |

### 📊 Summary
- Total skill files: [count]
- Working: [count]
- Broken: [count]
- Orphaned: [count]
```

### Step 4: Offer Fixes
For each broken skill:
```
Fix options:
  1) Rename file to match expected convention
  2) Create symlink/alias
  3) Delete if duplicate
  4) Skip
```

---

## Common Fix Patterns

| Problem | Example | Fix |
|---------|---------|-----|
| Colon in filename not matching | `swift:app-store-prep.md` → `/swift:app-store-prep` fails | Check if Claude Code maps `:` to `/` in subdirectories |
| Subdirectory skill | `sales/forecast.md` | May need `sales:forecast.md` at root level |
| Duplicate skill files | Two files with same intent | Delete the less complete one |
| Missing from MASTER.md | File exists but no trigger mapping | Add trigger to MASTER.md |

---

## Integration
- Run weekly as part of `/morning-check`
- Run on-demand when "Unknown skill" error appears
- Update CLAUDE.md skill count after fixes

## Related Skills
- `/morning-check` — calls this weekly
- `/workspace-audit` — broader workspace health
- `/make-skill` — create new skills correctly

---
Last updated: 2026-02-07
