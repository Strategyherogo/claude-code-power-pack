# Skill: Build Test
Verify build process and artifacts.

## Auto-Trigger
**When:** "build", "compile", "bundle", "build fails"

## Workflow

### Step 1: Clean Build
```bash
# Remove old artifacts
rm -rf dist/ build/ .cache/
rm -rf node_modules/.cache

# Fresh install
npm ci  # or yarn install --frozen-lockfile
```

### Step 2: Run Build
```bash
# Development build
npm run build:dev

# Production build
npm run build
npm run build:prod
```

### Step 3: Verify Artifacts
```
□ Output files exist
□ Bundle size acceptable
□ No unexpected files
□ Source maps generated (if needed)
□ Assets copied correctly
```

### Step 4: Test Build
```bash
# Run production build locally
npm run preview
npm run serve

# Run tests against build
npm run test:build
```

## Build Checks

### Bundle Analysis
```bash
# Webpack
npx webpack-bundle-analyzer dist/stats.json

# Vite
npx vite-bundle-visualizer

# Rollup
npx rollup-plugin-visualizer
```

### Size Limits
```bash
# Check bundle size
npx bundlesize

# Compare to previous
du -sh dist/
```

## Common Build Issues
```
□ Missing environment variables
□ Wrong Node version
□ Outdated lockfile
□ Circular dependencies
□ Missing peer dependencies
□ TypeScript errors
□ ESLint blocking build
```

## Output Format
```markdown
## Build Report

**Status:** ✅ SUCCESS / ❌ FAILED
**Duration:** 45s
**Output:** dist/

### Artifacts
| File | Size | Gzipped |
|------|------|---------|
| main.js | 245KB | 78KB |
| styles.css | 34KB | 8KB |

### Issues
- [list any warnings]
```

---
Last updated: 2026-01-27
