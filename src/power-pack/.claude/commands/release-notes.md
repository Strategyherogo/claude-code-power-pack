# Skill: release-notes
Auto-generate release notes from git commits.

## Auto-Trigger
**When:** "release notes", "what changed", "changelog entry", "release summary"

## Generate Release Notes

### From Git Log
```bash
# Get commits since last tag
git log $(git describe --tags --abbrev=0)..HEAD --oneline

# Get commits since date
git log --since="2026-01-01" --oneline

# Get commits with conventional format
git log --oneline | grep -E "^[a-f0-9]+ (feat|fix|docs|chore|refactor|test|style):"
```

### Parse Conventional Commits
```
feat: → ✨ New Features
fix: → 🐛 Bug Fixes
docs: → 📚 Documentation
chore: → 🔧 Maintenance
refactor: → ♻️ Refactoring
test: → ✅ Tests
perf: → ⚡ Performance
breaking: → 💥 Breaking Changes
```

## Release Notes Template

```markdown
# Release Notes: v[X.Y.Z]

**Release Date:** [YYYY-MM-DD]
**Previous Version:** v[X.Y.Z-1]

---

## Highlights
[1-2 sentence summary of the most important changes]

---

## ✨ New Features
- **[Feature name]** - [Brief description] ([#PR](link))
- **[Feature name]** - [Brief description]

## 🐛 Bug Fixes
- Fixed [issue description] ([#123](link))
- Resolved [issue description]

## ⚡ Performance
- Improved [what] by [how much]

## 💥 Breaking Changes
- [Change description] - [Migration guide]

## 🔧 Maintenance
- Updated dependencies
- Code cleanup

---

## Upgrade Guide

### From v[previous]
```bash
# Update command
npm update [package]
```

### Breaking Change Migration
[Step-by-step if needed]

---

## Contributors
- @username - [contribution]

---

**Full Changelog:** [compare link]
```

## Automated Generation

### Step 1: Get Version Info
```bash
# Current version
cat package.json | jq -r '.version'

# Last tag
git describe --tags --abbrev=0
```

### Step 2: Categorize Commits
```bash
# Features
git log $LAST_TAG..HEAD --oneline --grep="^feat"

# Fixes
git log $LAST_TAG..HEAD --oneline --grep="^fix"

# Breaking
git log $LAST_TAG..HEAD --oneline --grep="BREAKING"
```

### Step 3: Generate
Claude generates release notes from categorized commits.

## Output Locations

| Format | Location |
|--------|----------|
| Markdown | `CHANGELOG.md` (prepend) |
| GitHub | Release page |
| Notion | Product updates page |
| Slack | #releases channel |

## Version Bump Guide
```
Major (1.0.0 → 2.0.0): Breaking changes
Minor (1.0.0 → 1.1.0): New features
Patch (1.0.0 → 1.0.1): Bug fixes
```

## Quick Commands
```
/release-notes                    # Since last tag
/release-notes v1.2.0..v1.3.0    # Between versions
/release-notes --since=2026-01-01 # Since date
```

---
Last updated: 2026-01-29
