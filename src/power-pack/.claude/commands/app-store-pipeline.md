# Skill: app-store-pipeline
Test-driven App Store submission assembly line with gated stages.

## Status: 🚧 ON THE HORIZON (Foundation)
This is a next-generation capability that eliminates premature success celebrations and submission failures.

## Vision
A fully automated, gated pipeline where each Mac app goes through 7 validation stages — source check, build, test, screenshots, metadata, archive, upload — with automated checks enforcing each gate. Never again celebrate a "successful" submission that actually failed.

## The Problem

From insights analysis:
> "Claude kept throwing a premature victory party for a Jira app that never actually worked... It even started showing a completely different app name ('AI Bulk Editor' instead of 'AI Issue Classifier'), and the session ended with the app still broken — a masterclass in unearned confidence."

**Root causes:**
1. No automated verification after each step
2. Xcode corruption from CLI edits
3. Missing metadata fields discovered at upload
4. Premature "success" declarations
5. No smoke tests before submission

## How It Works

### 7-Stage Gated Pipeline

```
┌────────────┐
│ SOURCE_CHECK│─┬─ Pass → BUILD
└────────────┘ └─ Fail → STOP (report issues)

┌────────────┐
│   BUILD    │─┬─ Pass → TEST
└────────────┘ └─ Fail → STOP (show build errors)

┌────────────┐
│    TEST    │─┬─ Pass → SCREENSHOTS
└────────────┘ └─ Fail → STOP (show test failures)

┌────────────┐
│ SCREENSHOTS│─┬─ Pass → METADATA
└────────────┘ └─ Fail → STOP (missing images)

┌────────────┐
│  METADATA  │─┬─ Pass → ARCHIVE
└────────────┘ └─ Fail → STOP (missing fields)

┌────────────┐
│  ARCHIVE   │─┬─ Pass → UPLOAD
└────────────┘ └─ Fail → STOP (archive errors)

┌────────────┐
│   UPLOAD   │─┬─ Pass → DONE ✅
└────────────┘ └─ Fail → STOP (upload errors)
```

**CRITICAL:** Each stage MUST pass validation before proceeding. No skipping gates.

## Stage Definitions

### Stage 1: SOURCE_CHECK
```python
def validate_source(project_path):
    """
    Verify project structure and sources before building.

    Returns: (passed: bool, errors: list)
    """
    errors = []

    # Check .xcodeproj exists
    xcodeproj = find_xcodeproj(project_path)
    if not xcodeproj:
        errors.append("No .xcodeproj file found")

    # Check for project corruption
    if xcodeproj:
        try:
            # Read project.pbxproj (XML format)
            pbxproj = f"{xcodeproj}/project.pbxproj"
            with open(pbxproj, 'r') as f:
                content = f.read()

            # Check for malformed XML
            import xml.etree.ElementTree as ET
            ET.fromstring(content)  # Will raise if corrupt

        except Exception as e:
            errors.append(f"Project file corrupted: {e}")

    # Check for missing source files
    missing_files = check_missing_references(xcodeproj)
    if missing_files:
        errors.append(f"Missing {len(missing_files)} source files: {missing_files[:3]}")

    # Check Info.plist exists (if not using GENERATE_INFOPLIST_FILE)
    # ... (additional checks)

    return len(errors) == 0, errors
```

**Gate:** All checks must pass before BUILD.

### Stage 2: BUILD
```bash
# Use xcodebuild, capture and parse output
xcodebuild clean build \
    -project MyApp.xcodeproj \
    -scheme MyApp \
    -configuration Release \
    -quiet \
    2>&1 | tee build.log

# Parse for errors
BUILD_ERRORS=$(grep -c "error:" build.log)
BUILD_WARNINGS=$(grep -c "warning:" build.log)

if [ $BUILD_ERRORS -gt 0 ]; then
    echo "❌ BUILD FAILED: $BUILD_ERRORS errors"
    grep "error:" build.log
    exit 1
fi

echo "✅ BUILD PASSED: 0 errors, $BUILD_WARNINGS warnings"
```

**Gate:** Zero build errors required before TEST.

### Stage 3: TEST
```bash
# Run unit tests (if test target exists)
xcodebuild test \
    -project MyApp.xcodeproj \
    -scheme MyApp \
    -destination 'platform=macOS' \
    2>&1 | tee test.log

# Parse results
TEST_FAILURES=$(grep -c "Test Case.*failed" test.log)

if [ $TEST_FAILURES -gt 0 ]; then
    echo "❌ TEST FAILED: $TEST_FAILURES failures"
    grep "failed" test.log
    exit 1
fi

# If no test target, create basic smoke test
if [ ! -f "MyAppTests/MyAppTests.swift" ]; then
    echo "⚠️  No tests found. Creating smoke test..."
    create_basic_smoke_test
    # Re-run above
fi

echo "✅ TEST PASSED: 100% pass rate"
```

**Gate:** 100% test pass required before SCREENSHOTS.

### Stage 4: SCREENSHOTS
```bash
# Generate all required screenshot sizes
# Mac App Store requires: 1280×800, 1440×900, 2560×1600, 2880×1800

for size in "1280x800" "1440x900" "2560x1600" "2880x1800"; do
    xcrun simctl io booted screenshot --type=png \
        --display=external \
        screenshots/screenshot_${size}.png \
        || {
            echo "❌ Failed to generate screenshot: $size"
            exit 1
        }
done

# Verify all files exist
required_screenshots=(
    "screenshots/screenshot_1280x800.png"
    "screenshots/screenshot_1440x900.png"
    "screenshots/screenshot_2560x1600.png"
    "screenshots/screenshot_2880x1800.png"
)

for screenshot in "${required_screenshots[@]}"; do
    if [ ! -f "$screenshot" ]; then
        echo "❌ Missing screenshot: $screenshot"
        exit 1
    fi
done

echo "✅ SCREENSHOTS PASSED: All 4 sizes generated"
```

**Gate:** All required screenshot sizes present before METADATA.

### Stage 5: METADATA
```python
def validate_metadata(app_id):
    """
    Verify all required App Store Connect fields are populated.

    Required fields (28 locales):
    - Name
    - Subtitle
    - Description
    - Keywords
    - Primary category
    - Secondary category
    - Screenshots (4 sizes)
    - Privacy policy URL
    - Support URL
    """
    from appstoreconnect import Api

    api = Api(key_id, key_file, issuer_id)
    app = api.get_app(app_id)

    errors = []

    # Check each required field
    required_fields = [
        'name', 'subtitle', 'description', 'keywords',
        'primary_category', 'privacy_policy_url', 'support_url'
    ]

    for field in required_fields:
        if not getattr(app, field, None):
            errors.append(f"Missing required field: {field}")

    # Check all locales
    supported_locales = ['en-US', 'es-ES', 'fr-FR', ...]  # 28 total

    for locale in supported_locales:
        locale_data = app.get_locale(locale)
        if not locale_data or not locale_data.get('description'):
            errors.append(f"Missing localization: {locale}")

    # Check screenshots for each locale
    for locale in supported_locales:
        screenshots = app.get_screenshots(locale)
        if len(screenshots) < 4:
            errors.append(f"Missing screenshots for {locale}: {len(screenshots)}/4")

    return len(errors) == 0, errors
```

**Auto-fix:**
```python
# If metadata missing, generate and populate
if not app.description:
    description = generate_app_description(app)
    api.update_app_description(app_id, description)

# If locales missing, auto-translate base locale
if missing_locales:
    for locale in missing_locales:
        translated = translate_metadata(base_locale, locale)
        api.create_locale(app_id, locale, translated)
```

**Gate:** All 28 locales populated before ARCHIVE.

### Stage 6: ARCHIVE
```bash
# Create archive
xcodebuild archive \
    -project MyApp.xcodeproj \
    -scheme MyApp \
    -configuration Release \
    -archivePath build/MyApp.xcarchive \
    2>&1 | tee archive.log

# Verify archive exists
if [ ! -d "build/MyApp.xcarchive" ]; then
    echo "❌ Archive creation failed"
    cat archive.log
    exit 1
fi

# Export archive to .app/.pkg
xcodebuild -exportArchive \
    -archivePath build/MyApp.xcarchive \
    -exportPath build/export \
    -exportOptionsPlist ExportOptions.plist \
    2>&1 | tee export.log

# Verify export artifact
if [ ! -f "build/export/MyApp.app" ] && [ ! -f "build/export/MyApp.pkg" ]; then
    echo "❌ Export failed: no .app or .pkg found"
    cat export.log
    exit 1
fi

echo "✅ ARCHIVE PASSED: build/export/MyApp.app created"
```

**Gate:** Valid .app/.pkg artifact before UPLOAD.

### Stage 7: UPLOAD
```bash
# Upload to App Store Connect
xcrun altool --upload-app \
    --type macos \
    --file build/export/MyApp.pkg \
    --apiKey $ASC_KEY_ID \
    --apiIssuer $ASC_ISSUER_ID \
    2>&1 | tee upload.log

# Check for success
if grep -q "No errors uploading" upload.log; then
    echo "✅ UPLOAD PASSED: Submitted to App Store Connect"

    # Verify processing status
    xcrun altool --list-apps \
        --apiKey $ASC_KEY_ID \
        --apiIssuer $ASC_ISSUER_ID \
        | grep "MyApp" \
        || {
            echo "⚠️  Upload succeeded but app not found in processing queue"
            exit 1
        }

    echo "✅ VERIFIED: App in processing queue"
else
    echo "❌ UPLOAD FAILED"
    cat upload.log
    exit 1
fi
```

**Final Verification:**
```python
# Wait 5 minutes, then check processing status
time.sleep(300)

status = api.get_app_processing_status(app_id)
if status == "PROCESSING":
    print("✅ CONFIRMED: App is processing normally")
elif status == "FAILED":
    print("❌ PROCESSING FAILED: Check App Store Connect")
    errors = api.get_processing_errors(app_id)
    print(errors)
    sys.exit(1)
```

**Gate:** Only declare success after VERIFIED in processing queue.

## Parallel Orchestration

Run stages 1-3 for multiple apps simultaneously:
```python
from claude_code import Task

def process_app(app_path):
    """Run pipeline for one app."""
    results = []

    # Stage 1: SOURCE_CHECK
    passed, errors = validate_source(app_path)
    if not passed:
        return {"stage": "SOURCE_CHECK", "status": "FAILED", "errors": errors}

    # Stage 2: BUILD
    passed, errors = run_build(app_path)
    if not passed:
        return {"stage": "BUILD", "status": "FAILED", "errors": errors}

    # Stage 3: TEST
    passed, errors = run_tests(app_path)
    if not passed:
        return {"stage": "TEST", "status": "FAILED", "errors": errors}

    # ... (continue through stages 4-7)

    return {"stage": "UPLOAD", "status": "PASSED", "app_id": app_id}

# Run for multiple apps in parallel
apps = [
    "~/Projects/01-mbox-splitter-pro",
    "~/Projects/02-para-mail-organizer",
    "~/Projects/03-ai-usage-battery"
]

tasks = []
for app in apps:
    task = Task(
        agent_type="app-store-pipeline",
        prompt=f"Run pipeline for {app}",
        data={"app_path": app}
    )
    tasks.append(task)

# Wait for all to complete
results = [task.wait() for task in tasks]

# Dashboard
for result in results:
    print(f"{result['app']}: {result['stage']} - {result['status']}")
```

## Dashboard Output

```markdown
# App Store Pipeline Status

| App | Stage | Status | Time | Details |
|-----|-------|--------|------|---------|
| Mbox Splitter Pro | UPLOAD | ✅ PASSED | 8m 32s | Processing normally |
| PARA Mail Organizer | METADATA | ❌ FAILED | 4m 11s | Missing 12 locales |
| AI Usage Battery | TEST | ❌ FAILED | 2m 45s | 3 test failures |

## Next Actions

**PARA Mail Organizer:**
- Auto-generate missing locales from en-US
- Re-run from METADATA stage

**AI Usage Battery:**
- Fix test failures in BatteryViewModelTests
- Re-run from TEST stage

**Mbox Splitter Pro:**
- Monitor App Store Connect for review status
- Estimated review: 24-48 hours
```

## Critical Rules

### NEVER Edit .xcodeproj with Text Tools
```python
# ❌ WRONG: Direct text manipulation
with open("project.pbxproj", "r") as f:
    content = f.read()
content = content.replace("old_value", "new_value")
# This WILL corrupt the project

# ✅ CORRECT: Use xcodebuild or PlistBuddy
os.system("xcodebuild -project MyApp.xcodeproj -list")
os.system("PlistBuddy -c 'Set :CFBundleVersion 1.2.3' Info.plist")
```

### Auto-Fix Up To 2 Times
```python
def run_stage_with_auto_fix(stage_func, max_attempts=2):
    """
    Run a stage, attempt auto-fix if it fails.
    """
    for attempt in range(max_attempts):
        passed, errors = stage_func()

        if passed:
            return True, []

        # Attempt auto-fix
        if attempt < max_attempts - 1:
            print(f"⚠️  Stage failed, attempting auto-fix ({attempt + 1}/{max_attempts - 1})")
            auto_fix_applied = attempt_auto_fix(errors)

            if not auto_fix_applied:
                # Can't auto-fix, stop
                return False, errors
        else:
            # Max attempts reached
            return False, errors

    return False, errors
```

## Usage

### Setup
```bash
# Install dependencies
pip install appstoreconnect requests

# Create pipeline script
.claude/scripts/app-store-pipeline.sh

# Configure apps
cat > ~/.claude/app-store-config.json << EOF
{
  "apps": [
    {
      "name": "Mbox Splitter Pro",
      "path": "~/Projects/01-mbox-splitter-pro",
      "app_id": "6757957380",
      "scheme": "MboxSplitterPro"
    }
  ],
  "asc_key_id": "$ASC_KEY_ID",
  "asc_issuer_id": "$ASC_ISSUER_ID",
  "asc_key_file": "~/.appstoreconnect/private_keys/AuthKey_367Y4J63B8.p8"
}
EOF
```

### Run Pipeline
```bash
# Single app
.claude/scripts/app-store-pipeline.sh --app "Mbox Splitter Pro"

# All apps in parallel
.claude/scripts/app-store-pipeline.sh --all --parallel

# Specific stage (for re-runs after fix)
.claude/scripts/app-store-pipeline.sh --app "AI Usage Battery" --from-stage TEST
```

## Benefits

| Current Workflow | With Pipeline |
|-----------------|---------------|
| Premature success declarations | Gated validation |
| Manual metadata checks | Auto-populated 28 locales |
| Xcode corruption from CLI edits | Only xcodebuild/PlistBuddy |
| Discover failures at upload | Catch at each gate |
| Celebration for broken apps | Only celebrate verified success |
| 5+ sessions per app | One-shot pipeline run |

## Next Steps

1. **Create base script:** `.claude/scripts/app-store-pipeline.sh`
2. **Implement SOURCE_CHECK validator**
3. **Add BUILD gate with error parsing**
4. **Create basic smoke test template**
5. **Test on one app** (start with simplest)
6. **Add parallel orchestration**
7. **Build dashboard UI**

---
**Status:** Foundation phase
**Priority:** High (5+ apps submitted, consistent friction)
**Estimated setup:** 6-8 hours
**Payoff:** One-shot submissions, zero premature victories
