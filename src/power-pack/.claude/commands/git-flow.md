# Skill: git-flow
Git branch management with feature/release/hotfix workflow.

## Auto-Trigger
**When:** "git flow", "feature branch", "release branch", "hotfix", "branch strategy"

## Branch Structure

```
main (production)
  │
  ├── develop (integration)
  │     │
  │     ├── feature/[name]
  │     ├── feature/[name]
  │     │
  │     └── release/[version]
  │
  └── hotfix/[name]
```

## Quick Commands

### Start Feature
```bash
# From develop
git checkout develop
git pull origin develop
git checkout -b feature/[feature-name]

# Work on feature...
git add .
git commit -m "feat: [description]"

# Finish feature
git checkout develop
git merge --no-ff feature/[feature-name]
git branch -d feature/[feature-name]
git push origin develop
```

### Start Release
```bash
# From develop
git checkout develop
git checkout -b release/[version]

# Bump version, final fixes...
git commit -m "chore: bump version to [version]"

# Finish release
git checkout main
git merge --no-ff release/[version]
git tag -a v[version] -m "Release [version]"
git checkout develop
git merge --no-ff release/[version]
git branch -d release/[version]
git push origin main develop --tags
```

### Start Hotfix
```bash
# From main (urgent production fix)
git checkout main
git checkout -b hotfix/[name]

# Fix the issue...
git commit -m "fix: [description]"

# Finish hotfix
git checkout main
git merge --no-ff hotfix/[name]
git tag -a v[version] -m "Hotfix [version]"
git checkout develop
git merge --no-ff hotfix/[name]
git branch -d hotfix/[name]
git push origin main develop --tags
```

## Branch Naming

| Type | Pattern | Example |
|------|---------|---------|
| Feature | `feature/[ticket]-[desc]` | `feature/TC-123-user-auth` |
| Release | `release/[version]` | `release/1.2.0` |
| Hotfix | `hotfix/[ticket]-[desc]` | `hotfix/TC-456-login-crash` |
| Bugfix | `bugfix/[ticket]-[desc]` | `bugfix/TC-789-typo` |

## Simplified Flow (Solo/Small Team)

```bash
# Feature workflow
git checkout -b feature/my-feature
# ... work ...
git checkout main
git merge feature/my-feature
git push origin main
git branch -d feature/my-feature
```

## Git Flow Commands (if installed)

```bash
# Install
brew install git-flow

# Initialize
git flow init

# Features
git flow feature start [name]
git flow feature finish [name]

# Releases
git flow release start [version]
git flow release finish [version]

# Hotfixes
git flow hotfix start [name]
git flow hotfix finish [name]
```

## When to Use What

| Situation | Branch Type |
|-----------|-------------|
| New functionality | feature/ |
| Bug fix (non-urgent) | bugfix/ or feature/ |
| Production emergency | hotfix/ |
| Preparing release | release/ |
| Experiments | feature/experiment-* |

## PR Workflow Integration

```bash
# Push feature branch
git push -u origin feature/[name]

# Create PR
gh pr create --base develop --title "feat: [description]"

# After approval, merge via PR (not locally)
```

---
Last updated: 2026-01-29
