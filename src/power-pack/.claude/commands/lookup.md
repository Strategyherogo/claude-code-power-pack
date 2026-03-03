# Skill: lookup
Quick information lookup and search.

## Auto-Trigger
**When:** "lookup", "find", "search for", "what is", "look up"

## Lookup Sources

### Code Search
```bash
# Search in current project
grep -r "search_term" .

# With file pattern
grep -r "function_name" --include="*.ts"

# With context
grep -r "TODO" -B 2 -A 2 --include="*.js"

# Case insensitive
grep -ri "error" --include="*.log"
```

### Git Search
```bash
# Search commits
git log --grep="fix"

# Search code history
git log -p -S "function_name"

# Find when line was added
git log -p -- file.ts | grep -B 10 "specific_line"

# Find who changed line
git blame file.ts
```

### File Search
```bash
# Find file by name
find . -name "*.config.js"

# Find file by content
find . -type f -exec grep -l "search_term" {} \;

# Recent files
find . -type f -mtime -7

# Large files
find . -type f -size +10M
```

### Documentation Search
```bash
# Man pages
man command_name

# npm package docs
npm docs package-name

# Python help
python -c "help(module_name)"
```

## Quick References

### HTTP Status Codes
```
2xx Success
  200 OK
  201 Created
  204 No Content

3xx Redirect
  301 Moved Permanently
  302 Found
  304 Not Modified

4xx Client Error
  400 Bad Request
  401 Unauthorized
  403 Forbidden
  404 Not Found
  429 Too Many Requests

5xx Server Error
  500 Internal Server Error
  502 Bad Gateway
  503 Service Unavailable
```

### Common Regex
```
Email: ^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$
URL: https?:\/\/[^\s]+
Phone: \+?[\d\s-]{10,}
UUID: [0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}
Date (ISO): \d{4}-\d{2}-\d{2}
IP Address: \d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}
```

### Git Commands
```
git status              # Current state
git diff                # Unstaged changes
git diff --staged       # Staged changes
git log --oneline -10   # Recent commits
git branch -a           # All branches
git stash list          # Stashed changes
git remote -v           # Remote URLs
```

### npm/Node Commands
```
npm ls --depth=0        # Installed packages
npm outdated            # Check for updates
npm audit               # Security check
node -v                 # Node version
npm -v                  # npm version
npx <package>           # Run without install
```

## Lookup Templates

### Error Lookup
```
1. Copy exact error message
2. Remove file paths and line numbers
3. Search: "[error message]" + [technology]
4. Check Stack Overflow, GitHub Issues
5. Check official documentation
```

### API Lookup
```
1. Find official documentation
2. Check endpoint reference
3. Look for example requests
4. Verify authentication method
5. Note rate limits
```

### Package Lookup
```
npm info <package>      # npm details
pip show <package>      # pip details
bundlephobia.com        # Bundle size
snyk.io/advisor         # Security/quality
```

---
Last updated: 2026-01-27
