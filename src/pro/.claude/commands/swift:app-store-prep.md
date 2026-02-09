# Skill: swift:app-store-prep
Complete checklist and workflow for shipping iOS/macOS apps to App Store.

## Auto-Trigger
**When:** "app store", "submit app", "testflight", "app review", "ios submission", "macos submission"

## Pre-Submission Workflow

### Phase 1: Code Quality (30 min)
```
□ All tests passing (unit + UI)
□ No compiler warnings
□ No console errors or crashes
□ Static analysis clean (Cmd+Shift+B)
□ Performance acceptable (60fps, <3s launch)
□ Memory usage reasonable (<100MB baseline)
□ No memory leaks (run Instruments)
```

### Phase 2: Build Configuration
```
□ Version number bumped (CFBundleShortVersionString)
□ Build number incremented (CFBundleVersion)
□ Correct signing identity (Distribution)
□ App icon all sizes present
□ Launch screen configured
□ Capabilities enabled correctly
□ Minimum OS version correct
```

### Phase 3: Archive & Upload
```bash
# Xcode UI
Product → Archive
Organizer → Distribute App → App Store Connect

# Command Line
xcodebuild archive \
  -scheme "YourScheme" \
  -archivePath "./build/YourApp.xcarchive" \
  -configuration Release

xcodebuild -exportArchive \
  -archivePath "./build/YourApp.xcarchive" \
  -exportPath "./build" \
  -exportOptionsPlist ExportOptions.plist
```

### Phase 4: TestFlight (Before App Store)
```
□ Upload build to App Store Connect
□ Wait for processing (15-30 min)
□ Add internal testers
□ Test on real devices (not simulator)
□ Check crash reports in Organizer
□ Verify all features work
□ Test with different iOS versions
□ Test with slow network
```

## App Store Connect Metadata

### Required Fields
| Field | Max Length | Tips |
|-------|------------|------|
| App Name | 30 chars | Unique, memorable |
| Subtitle | 30 chars | Value proposition |
| Keywords | 100 chars | Comma-separated, no spaces |
| Description | 4000 chars | First 3 lines visible |
| What's New | 4000 chars | Bullet list works well |

### Screenshots

**Required per device type:**
```
- iPhone 6.7" (1290×2796) - iPhone 15 Pro Max
- iPhone 6.5" (1284×2778) - iPhone 14 Plus
- iPhone 5.5" (1242×2208) - iPhone 8 Plus
- iPad Pro 12.9" (2048×2732)
- Mac (2880×1800) - for macOS apps
```

**Automated Screenshot Capture (macOS apps):**
```bash
# 1. Launch the app first, then capture its window
APP_NAME="YourApp"
OUTPUT_DIR="./screenshots"
mkdir -p "$OUTPUT_DIR"

# Capture specific window by app name (non-interactive)
screencapture -l $(osascript -e "tell app \"$APP_NAME\" to id of window 1") "$OUTPUT_DIR/screenshot-raw.png"

# Or capture by window title
osascript -e 'tell application "System Events" to tell process "'"$APP_NAME"'" to set frontmost to true'
sleep 1
screencapture -w "$OUTPUT_DIR/screenshot-raw.png"

# 2. Resize to App Store dimensions (Mac: 2880x1800)
sips -z 1800 2880 "$OUTPUT_DIR/screenshot-raw.png" --out "$OUTPUT_DIR/screenshot-mac.png" 2>/dev/null || \
  python3 -c "
from PIL import Image
img = Image.open('$OUTPUT_DIR/screenshot-raw.png')
img = img.resize((2880, 1800), Image.LANCZOS)
img.save('$OUTPUT_DIR/screenshot-mac.png')
"

# 3. Generate multiple screenshots (different app states)
# Tip: Use AppleScript to navigate app to each screen, then capture
for state in main settings detail; do
  osascript -e 'tell application "'"$APP_NAME"'" to activate'
  # Add navigation commands per state here
  sleep 0.5
  screencapture -l $(osascript -e "tell app \"$APP_NAME\" to id of window 1") "$OUTPUT_DIR/screenshot-$state.png"
done
```

**Locale Propagation (copy en-US screenshots to all locales):**
```bash
# After capturing en-US screenshots, propagate to all target locales
SOURCE_LOCALE="en-US"
TARGET_LOCALES="en-GB de-DE fr-FR es-ES ja pt-BR zh-Hans"
SCREENSHOTS_DIR="./metadata/screenshots"

# Copy screenshot set to all locales
for locale in $TARGET_LOCALES; do
  mkdir -p "$SCREENSHOTS_DIR/$locale"
  cp "$SCREENSHOTS_DIR/$SOURCE_LOCALE/"*.png "$SCREENSHOTS_DIR/$locale/" 2>/dev/null
  echo "  Copied screenshots to $locale"
done

# Verify all locales have same screenshot count
echo "Screenshot counts per locale:"
for locale in $SOURCE_LOCALE $TARGET_LOCALES; do
  count=$(ls "$SCREENSHOTS_DIR/$locale/"*.png 2>/dev/null | wc -l | tr -d ' ')
  echo "  $locale: $count screenshots"
done
```

**Tips:**
- Show key features in each screenshot
- Add text overlays with ImageMagick: `convert input.png -pointsize 48 -annotate +100+100 "Feature text" output.png`
- No status bar clutter
- Consistent style across all screenshots

### URLs Required
```
□ Privacy Policy URL (mandatory)
□ Support URL (mandatory)
□ Marketing URL (optional)
□ App Clip URL (if applicable)
```

## Common Rejection Reasons & Fixes

### 1. Guideline 2.1 - Crashes/Bugs
```
Cause: App crashes during review
Fix: Test on clean install, test all paths
Prevention: QA checklist, crash monitoring
```

### 2. Guideline 2.3 - Incomplete Info
```
Cause: Demo account needed but not provided
Fix: Provide test credentials in App Review Notes
Prevention: Always provide test accounts
```

### 3. Guideline 4.2 - Minimum Functionality
```
Cause: App too simple or "web wrapper"
Fix: Add native features, unique value
Prevention: Build genuine native features
```

### 4. Guideline 5.1.1 - Data Collection
```
Cause: Collecting data without disclosure
Fix: Update privacy nutrition labels
Prevention: Audit all data collection
```

### 5. Guideline 5.1.2 - User Consent
```
Cause: Not asking permission properly
Fix: ATT prompt before tracking
Prevention: Implement ATT correctly
```

## Review Checklist

### App Store Review Notes
```
Provide to reviewers:
□ Test account credentials
□ Special instructions
□ Feature explanations
□ Hardware requirements
□ Subscription info
```

### Privacy Checklist
```
□ ATT prompt implemented (if tracking)
□ Privacy nutrition labels accurate
□ Data usage disclosed
□ Third-party SDKs documented
□ Privacy policy URL valid
```

### Technical Checklist
```
□ Works on oldest supported iOS
□ Works on newest iOS beta
□ Universal purchase (if applicable)
□ In-App Purchases tested
□ Subscriptions restore properly
□ Dark mode supported
□ Dynamic Type supported
□ VoiceOver accessible
```

## Post-Submission

### While In Review
```
□ Monitor App Store Connect for status
□ Check email for reviewer questions
□ Be ready to respond quickly (within 24h)
□ Don't submit new build (resets queue)
```

### After Approval
```
□ Verify live listing correct
□ Test download and install
□ Monitor crash reports
□ Check reviews
□ Respond to user feedback
□ Plan next update
```

## Bundle ID Verification
**Common blocker:** Bundle ID mismatch between local project and App Store Connect.
```bash
# Check local bundle ID
grep -r "PRODUCT_BUNDLE_IDENTIFIER" *.xcodeproj/project.pbxproj 2>/dev/null | head -3
# Or from Info.plist
/usr/libexec/PlistBuddy -c "Print :CFBundleIdentifier" Info.plist 2>/dev/null

# Verify it matches App Store Connect entry
# If mismatch: update project, do NOT create a new ASC entry
```

## Pre-Submission Credential Check
Before starting, verify you have:
```bash
# App Store Connect API key
ls ~/.appstoreconnect/private_keys/*.p8 2>/dev/null && echo "✅ ASC API key" || echo "❌ Need API key"

# Signing identity
security find-identity -v -p codesigning | head -5

# Provisioning profiles
ls ~/Library/MobileDevice/Provisioning\ Profiles/*.mobileprovision 2>/dev/null | wc -l
```

## Related Skills
- `/swift:debug-memory` - Fix memory issues
- `/swift:async-troubleshoot` - Fix concurrency issues
- `/verify` - Pre-submission verification gate
- `/preflight` - Check credentials + API access before building

---
Last updated: 2026-02-06
