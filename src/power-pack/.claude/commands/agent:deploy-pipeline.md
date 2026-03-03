# Agent: Deployment Pipeline
Automated end-to-end deployment workflow.

## Auto-Trigger
**When:** "deploy", "ship", "release", "publish" + project name

## Agent Workflow

### Phase 1: Pre-Flight Checks
```
AGENT TASK: Verify deployment readiness
□ Git status clean (no uncommitted changes)
□ On correct branch (main/master)
□ All tests passing
□ No lint errors
□ Build succeeds
□ Environment variables set
```

### Phase 2: Version Bump
```
AGENT TASK: Update version
- Determine version type (patch/minor/major)
- Update package.json / setup.py / Info.plist
- Update CHANGELOG.md
- Create git tag
```

### Phase 3: Build
```
AGENT TASK: Create production build
- Run build command
- Verify build artifacts exist
- Check bundle size
- Run production tests
```

### Phase 4: Deploy
```
AGENT TASK: Deploy to target
- Cloudflare Workers → npx wrangler deploy
- Vercel → vercel --prod
- App Store → xcodebuild archive + altool
- npm → npm publish
- PyPI → twine upload
```

### Phase 5: Verify
```
AGENT TASK: Confirm deployment
- Health check endpoint
- Smoke tests
- Monitor for errors (5 minutes)
- Notify on success/failure
```

### Phase 6: Post-Deploy
```
AGENT TASK: Cleanup and notify
- Create GitHub release
- Update documentation
- Notify Slack channel
- Log deployment to journal
```

## Platform-Specific Commands

### Cloudflare Workers
```bash
# Pre-flight
npm run lint && npm test
# Deploy
npx wrangler deploy
# Verify
curl https://your-worker.workers.dev/health
```

### Vercel
```bash
# Pre-flight
npm run build
# Deploy
vercel --prod
# Verify
curl https://your-app.vercel.app/api/health
```

### App Store (iOS/macOS)
```bash
# Build archive
xcodebuild -scheme MyApp -archivePath build/MyApp.xcarchive archive
# Upload
xcrun altool --upload-app -f build/MyApp.ipa -t ios
```

### npm Package
```bash
# Pre-flight
npm run build && npm test
# Publish
npm publish --access public
# Verify
npm info your-package
```

## Rollback Procedures

### Cloudflare
```bash
npx wrangler rollback
```

### Vercel
```bash
vercel rollback
```

### npm
```bash
npm unpublish your-package@1.2.3
npm publish your-package@1.2.2
```

## Output Format
```markdown
## Deployment Report

**Project:** YOUR_PROJECT
**Version:** 1.2.3 → 1.2.4
**Target:** Cloudflare Workers
**Status:** ✅ SUCCESS

### Timeline
| Phase | Duration | Status |
|-------|----------|--------|
| Pre-flight | 12s | ✅ |
| Version bump | 3s | ✅ |
| Build | 45s | ✅ |
| Deploy | 8s | ✅ |
| Verify | 5s | ✅ |

### Artifacts
- Worker URL: https://ir-email.workers.dev
- GitHub Release: v1.2.4
- Changelog: Updated

### Next Steps
- Monitor for 24 hours
- Check error rates in dashboard
```

---
Last updated: 2026-01-27
