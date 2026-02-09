# Skill: commit-msg
Conventional commit message helper.

## Auto-Trigger
**When:** "commit message", "conventional commit", "how to commit", "commit format"

## Conventional Commit Format

```
<type>(<scope>): <subject>

<body>

<footer>
```

## Types

| Type | When to Use | Example |
|------|-------------|---------|
| `feat` | New feature | `feat: add user login` |
| `fix` | Bug fix | `fix: resolve null pointer` |
| `docs` | Documentation | `docs: update README` |
| `style` | Formatting (no code change) | `style: fix indentation` |
| `refactor` | Code restructure (no behavior change) | `refactor: extract helper` |
| `perf` | Performance improvement | `perf: optimize query` |
| `test` | Add/fix tests | `test: add login tests` |
| `chore` | Maintenance | `chore: update deps` |
| `ci` | CI/CD changes | `ci: add GitHub action` |
| `build` | Build system | `build: upgrade webpack` |
| `revert` | Revert commit | `revert: undo feature X` |

## Scope (Optional)

Scope = area of codebase affected:
- `feat(auth): add OAuth support`
- `fix(api): handle timeout errors`
- `docs(readme): add setup instructions`

## Subject Rules

1. **Imperative mood** - "add" not "added" or "adds"
2. **No period** at the end
3. **Lowercase** first letter
4. **Max 50 chars** (soft limit)

### Good Examples
```
feat: add password reset flow
fix: prevent crash on empty input
docs: document API endpoints
refactor: simplify auth logic
```

### Bad Examples
```
feat: Added password reset flow     # Past tense
fix: Fixes the crash bug.           # Capitalized, period
updated readme                      # No type, past tense
WIP                                 # Not descriptive
```

## Body (Optional)

When subject isn't enough:

```
fix: prevent crash on empty input

The app crashed when users submitted empty forms.
Added validation to check for empty strings before
processing.

Closes #123
```

## Footer (Optional)

```
BREAKING CHANGE: API endpoint renamed from /users to /accounts

Closes #123
Refs #456, #789
Co-authored-by: Name <email>
```

## Breaking Changes

Two ways to indicate:

```
# In footer
feat: change API response format

BREAKING CHANGE: Response now returns array instead of object

# Or with ! after type
feat!: change API response format
```

## Quick Reference

```bash
# Feature
git commit -m "feat(scope): add new feature"

# Bug fix
git commit -m "fix(scope): resolve issue with X"

# Breaking change
git commit -m "feat(api)!: change response format"

# With body (use heredoc)
git commit -m "$(cat <<'EOF'
feat: add user authentication

Implements JWT-based auth with refresh tokens.
Includes login, logout, and token refresh endpoints.

Closes #123
EOF
)"
```

## Commitlint (Automated Enforcement)

```bash
# Install
npm install -D @commitlint/{cli,config-conventional}

# Config (.commitlintrc.json)
{
  "extends": ["@commitlint/config-conventional"]
}

# Add husky hook
npx husky add .husky/commit-msg 'npx commitlint --edit $1'
```

## Commit Message Templates

### Feature
```
feat(<scope>): <what you added>

<why this feature is needed>
<how it works (brief)>

Closes #<issue>
```

### Bug Fix
```
fix(<scope>): <what you fixed>

<what was the bug>
<what caused it>
<how you fixed it>

Fixes #<issue>
```

### Refactor
```
refactor(<scope>): <what you changed>

<why the refactor was needed>
<what's different now>

No functional changes.
```

---
Last updated: 2026-01-29
