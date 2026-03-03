# Skill: asc-build-upload
Full CLI pipeline: xcodegen → archive → export → upload to App Store Connect. No Xcode GUI needed.

## Auto-Trigger
**When:** "upload build", "submit build", "archive and upload", "build pipeline", "asc upload"

## Prerequisites
- XcodeGen installed (`brew install xcodegen`)
- Valid `project.yml` in the project directory
- `ExportOptions.plist` in the project directory (or will create one)
- Apple Developer signing identity in Keychain
- ASC API key configured (`$ASC_KEY_ID`, `$ASC_ISSUER_ID`, key file at `~/.appstoreconnect/private_keys/`)

## Workflow

### 1. Regenerate Xcode Project
```bash
cd [PROJECT_DIR]
xcodegen generate
```

### 2. Archive
```bash
xcodebuild archive \
  -project [PROJECT_NAME].xcodeproj \
  -scheme [SCHEME_NAME] \
  -archivePath ./build/[APP_NAME].xcarchive \
  -destination "generic/platform=macOS" \
  CODE_SIGN_IDENTITY="Apple Distribution" \
  2>&1 | tail -5
```

For iOS:
```bash
xcodebuild archive \
  -project [PROJECT_NAME].xcodeproj \
  -scheme [SCHEME_NAME] \
  -archivePath ./build/[APP_NAME].xcarchive \
  -destination "generic/platform=iOS" \
  CODE_SIGN_IDENTITY="Apple Distribution" \
  2>&1 | tail -5
```

### 3. Create ExportOptions.plist (if missing)
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>method</key>
    <string>app-store-connect</string>
    <key>teamID</key>
    <string>W5VGBZU449</string>
    <key>destination</key>
    <string>upload</string>
    <key>signingStyle</key>
    <string>automatic</string>
</dict>
</plist>
```

### 4. Export Archive
```bash
xcodebuild -exportArchive \
  -archivePath ./build/[APP_NAME].xcarchive \
  -exportPath ./build/export \
  -exportOptionsPlist ExportOptions.plist \
  2>&1 | tail -5
```

### 5. Upload to ASC
```bash
xcrun altool --upload-app \
  -f ./build/export/[APP_NAME].pkg \
  -t [PLATFORM] \
  --apiKey $ASC_KEY_ID \
  --apiIssuer $ASC_ISSUER_ID \
  2>&1
```
Platform: `macos` or `ios`

### 6. Post-Upload (via asc-mcp)
After upload succeeds:
1. Wait ~2 min for build to process in ASC
2. Attach build to version: `app_versions_attach_build`
3. Set encryption: `PATCH /v1/builds/{id}` with `usesNonExemptEncryption: false`
4. **Submit for review** — must be done in ASC web UI (API returns 403)

## Quick Reference
```bash
# Full pipeline (copy-paste, fill in brackets)
cd [PROJECT_DIR] && \
xcodegen generate && \
xcodebuild archive -project [NAME].xcodeproj -scheme [SCHEME] \
  -archivePath ./build/App.xcarchive -destination "generic/platform=[PLATFORM]" \
  CODE_SIGN_IDENTITY="Apple Distribution" && \
xcodebuild -exportArchive -archivePath ./build/App.xcarchive \
  -exportPath ./build/export -exportOptionsPlist ExportOptions.plist && \
xcrun altool --upload-app -f ./build/export/*.pkg -t [PLATFORM] \
  --apiKey $ASC_KEY_ID --apiIssuer $ASC_ISSUER_ID
```

## Troubleshooting
| Error | Fix |
|-------|-----|
| 90546 "Missing asset catalog" | Add `Assets.xcassets` to `project.yml` sources |
| "No signing identity" | Open Keychain, check Apple Distribution cert is valid |
| "Upload failed" | Check `xcrun altool --validate-app` first |
| Build not appearing in ASC | Wait 5-10 min, check email for processing errors |

## Known Limitations
- `xcrun altool` is deprecated in favor of `xcrun notarytool` for notarization, but still works for ASC uploads
- Final "Submit for Review" click must be in ASC web UI (API key lacks permission)

---
Last updated: 2026-03-02
