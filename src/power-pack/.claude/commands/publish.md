# Skill: publish
Publish apps/extensions to marketplaces (Chrome Web Store, npm, Atlassian, App Store).

## Auto-Trigger
**When:** "publish", "release to store", "submit to marketplace", "upload extension"

## Pre-Publish Checklist

### 1. Credential Discovery
```bash
# Check for stored credentials in order:
# 1. Project .env
[ -f .env ] && grep -E "(API_KEY|TOKEN|SECRET|CLIENT)" .env

# 2. Global config
ls ~/.config/ | grep -iE "(chrome|google|atlassian|npm|apple)"

# 3. Environment variables
printenv | grep -iE "(CHROME|GOOGLE|ATLASSIAN|NPM|APPLE|API)"

# 4. macOS Keychain
security find-generic-password -s "Chrome Web Store" 2>/dev/null
security find-generic-password -s "Atlassian" 2>/dev/null
```

### 2. Detect Project Type
```
□ Chrome Extension → manifest.json with "manifest_version"
□ npm Package → package.json with "name" and "version"
□ Atlassian App → atlassian-connect.json or descriptor
□ iOS/macOS App → .xcodeproj or Package.swift
□ Python Package → setup.py or pyproject.toml
```

---

## Platform-Specific Workflows

### Chrome Web Store

**CLI Tool:** `chrome-webstore-upload-cli`

```bash
# Install
npm install -g chrome-webstore-upload-cli

# Required credentials (store in .env):
# EXTENSION_ID=your-extension-id
# CLIENT_ID=your-client-id
# CLIENT_SECRET=your-client-secret
# REFRESH_TOKEN=your-refresh-token

# Package extension
zip -r extension.zip . -x "*.git*" -x "node_modules/*" -x "*.md"

# Upload (draft)
chrome-webstore-upload upload --source extension.zip --extension-id $EXTENSION_ID

# Publish
chrome-webstore-upload publish --extension-id $EXTENSION_ID
```

**Get credentials:**
1. Google Cloud Console → APIs → Chrome Web Store API
2. Create OAuth 2.0 credentials
3. Get refresh token via OAuth flow

---

### npm Registry

```bash
# Check login status
npm whoami

# If not logged in
npm login

# Bump version
npm version patch|minor|major

# Publish
npm publish

# Publish scoped package
npm publish --access public
```

**For automation (.env):**
```
NPM_TOKEN=npm_xxxxx
```

---

### Atlassian Marketplace

**CLI Tool:** `atlas` or direct API

```bash
# Install Atlassian CLI
brew install atlassian/tap/atlas

# Login
atlas auth login

# List your apps
atlas marketplace apps list

# Create new version
atlas marketplace apps versions create --app-key <key> --version <version>

# Upload build
atlas marketplace apps versions upload --app-key <key> --version <version> --file <artifact>
```

**API Alternative:**
```bash
# Get vendor ID first
curl -u <YOUR_EMAIL>:<YOUR_API_TOKEN> https://marketplace.atlassian.com/rest/2/vendors

# Upload new version
curl -X POST \
  -u <YOUR_EMAIL>:<YOUR_API_TOKEN> \
  -H "Content-Type: application/json" \
  https://marketplace.atlassian.com/rest/2/addons/<addon-key>/versions
```

---

### Apple App Store (iOS/macOS)

**Prerequisites:**
- Xcode installed
- App Store Connect API key (.p8 file)
- Valid certificates and provisioning profiles

```bash
# Build archive
xcodebuild archive \
  -scheme "AppName" \
  -archivePath build/App.xcarchive

# Export IPA
xcodebuild -exportArchive \
  -archivePath build/App.xcarchive \
  -exportPath build/ \
  -exportOptionsPlist ExportOptions.plist

# Upload via altool
xcrun altool --upload-app \
  -f build/App.ipa \
  -t ios \
  --apiKey <key-id> \
  --apiIssuer <issuer-id>

# Or use Transporter
xcrun notarytool submit build/App.dmg \
  --key <key-path> \
  --key-id <key-id> \
  --issuer <issuer-id>
```

---

### Python Package (PyPI)

```bash
# Build
python -m build

# Check
twine check dist/*

# Upload to TestPyPI first
twine upload --repository testpypi dist/*

# Upload to PyPI
twine upload dist/*
```

**Credentials (~/.pypirc):**
```ini
[pypi]
username = __token__
password = pypi-xxxxx
```

---

## Post-Publish Verification

```bash
# Chrome: Check version in store
curl -s "https://chrome.google.com/webstore/detail/<id>" | grep -o 'version.*'

# npm: Verify published
npm view <package-name> version

# Atlassian: Check marketplace listing
curl -s "https://marketplace.atlassian.com/apps/<app-id>" | grep version
```

---

## Output Format

```markdown
## Publish Report

**Package:** [name]
**Platform:** [Chrome|npm|Atlassian|App Store]
**Version:** [old] → [new]
**Status:** ✅ Published

### Pre-Publish Checks
- [x] Credentials found
- [x] Version bumped
- [x] Build successful
- [x] Package valid

### Publish
- Upload: ✅
- Processing: ✅
- Live: [URL]

### Next Steps
- [ ] Verify in store
- [ ] Announce release
- [ ] Update changelog
```

---

## Troubleshooting

| Error | Solution |
|-------|----------|
| "Not authenticated" | Run credential discovery, re-login |
| "Version exists" | Bump version number |
| "Invalid manifest" | Check manifest.json syntax |
| "Missing permissions" | Review API scopes |
| "Upload failed" | Check file size limits, retry |

---
Last updated: 2026-02-05
