# Skill: changelog
Maintain and update CHANGELOG files.

## Auto-Trigger
**When:** "update changelog", "changelog", "add to changelog", "log changes"

## Changelog Format (Keep a Changelog)

```markdown
# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/),
and this project adheres to [Semantic Versioning](https://semver.org/).

## [Unreleased]

### Added
- New feature X

### Changed
- Updated behavior of Y

### Deprecated
- Feature Z will be removed in v2.0

### Removed
- Deleted legacy endpoint

### Fixed
- Bug in authentication flow

### Security
- Patched XSS vulnerability

---

## [1.2.0] - 2026-01-29

### Added
- User profile editing
- Export to CSV

### Fixed
- Login timeout issue

---

## [1.1.0] - 2026-01-15
...
```

## Categories

| Category | When to Use |
|----------|-------------|
| **Added** | New features |
| **Changed** | Changes in existing functionality |
| **Deprecated** | Soon-to-be removed features |
| **Removed** | Removed features |
| **Fixed** | Bug fixes |
| **Security** | Vulnerability fixes |

## Workflow

### Add Entry
```
/changelog add [category] [description]
```
Example:
```
/changelog add fixed Authentication timeout on slow networks
```

### Release Version
```
/changelog release [version]
```
Moves [Unreleased] to new version section with date.

### View Current
```
/changelog show
```

## Auto-Update on Commit

When commits use conventional format:
- `feat:` → Added
- `fix:` → Fixed
- `docs:` → Changed (documentation)
- `BREAKING CHANGE:` → Changed (with note)
- `security:` → Security

## Templates

### Project CHANGELOG.md
```markdown
# Changelog

## [Unreleased]

## [0.1.0] - [date]

### Added
- Initial release
- Core feature X
- Core feature Y
```

### .claude/ CHANGELOG.md
```markdown
# Claude Config Changelog

## [Unreleased]

## [5.1.0] - 2026-01-29

### Added
- Health check skill
- System audit integration

### Changed
- /cs now multi-purpose (Check & Save)
```

## Best Practices

1. **Write for users** - Focus on impact, not implementation
2. **Be concise** - One line per change
3. **Link issues** - Reference #123 when applicable
4. **Group related** - Combine related small changes
5. **Date releases** - ISO format (YYYY-MM-DD)

## Quick Entry Format
```
[Category]: [Description] (#issue)
```

Examples:
```
Added: Dark mode support (#45)
Fixed: Memory leak in image processing (#78)
Security: Updated dependencies to patch CVE-2026-1234
```

---
Last updated: 2026-01-29
