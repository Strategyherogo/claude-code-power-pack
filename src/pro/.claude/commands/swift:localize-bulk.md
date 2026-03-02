# Skill: swift:localize-bulk
Batch add localized strings to Xcode String Catalog (.xcstrings) — avoid manual JSON editing.

## Auto-Trigger
**When:** "add localized strings", "bulk localization", "localize batch", "add to xcstrings"

## Overview
Modern Xcode 15+ uses String Catalogs (`.xcstrings`) instead of legacy `.strings` files. This skill helps you add multiple localized keys at once without manual JSON editing.

---

## Input Format

Provide strings in this simple format:

```
key_name = English text
  it = Italian text
  el = Greek text
  cs = Czech text
  ro = Romanian text
  sl = Slovenian text
  sk = Slovak text

another_key = Another English string
  it = Un altro testo
  fr = Un autre texte
```

**Rules:**
- Key line starts at column 0 (no indent)
- Translation lines start with 2 spaces + language code + ` = `
- Blank lines separate entries
- English (or base language) goes first on key line

---

## Workflow

### Step 1: Parse Input
```
□ Extract key names
□ Extract base language text
□ Extract all translations
□ Validate language codes
□ Check for duplicates
```

### Step 2: Load Existing .xcstrings
```bash
# Find the Localizable.xcstrings file
find . -name "Localizable.xcstrings" -type f
```

Typical locations:
- `ios/Sources/Resources/Localizable.xcstrings`
- `App/Resources/Localizable.xcstrings`
- `Shared/Localizable.xcstrings`

### Step 3: Merge Strings

Read existing JSON, add new entries:

```json
{
  "sourceLanguage": "en",
  "strings": {
    "existing_key": { ... },
    "new_key_1": {
      "localizations": {
        "en": { "stringUnit": { "state": "translated", "value": "English text" } },
        "it": { "stringUnit": { "state": "translated", "value": "Italian text" } },
        "el": { "stringUnit": { "state": "translated", "value": "Greek text" } }
      }
    }
  },
  "version": "1.0"
}
```

### Step 4: Write Back
```
□ Pretty-print JSON with 2-space indent
□ Preserve existing keys (don't overwrite)
□ Sort keys alphabetically
□ Validate JSON syntax
```

### Step 5: Verify
```bash
# Check Xcode can parse it
xcodebuild -showBuildSettings -json 2>&1 | grep -q error || echo "✅ Valid"

# Or just try building
xcodebuild build -scheme YourScheme -destination 'platform=iOS Simulator,name=iPhone 15'
```

---

## Example Usage

**Input:**
```
onboarding_welcome_title = Welcome to Wattora
  it = Benvenuti a Wattora
  el = Καλώς ήλθατε στο Wattora
  cs = Vítejte ve Wattora
  ro = Bun venit la Wattora
  sl = Dobrodošli v Wattora
  sk = Vitajte vo Wattora

onboarding_feature_prices = Hourly prices for 40 zones
  it = Prezzi orari per 40 zone
  el = Ωριαίες τιμές για 40 ζώνες
  cs = Hodinové ceny pro 40 zón
  ro = Prețuri orare pentru 40 de zone
  sl = Urne cene za 40 con
  sk = Hodinové ceny pre 40 zón
```

**Output:**
```
✅ Added 2 new keys to Localizable.xcstrings
   - onboarding_welcome_title (7 languages)
   - onboarding_feature_prices (7 languages)

📁 File: ios/Sources/Resources/Localizable.xcstrings
📊 Total keys: 234 (was 232)
```

---

## Advanced: Auto-Translation

If user provides only English and wants auto-translation:

```markdown
⚠️ Auto-translation not recommended for production apps.

For placeholder text during development:
- Use Google Translate API (requires API key)
- Use DeepL API (better quality, requires API key)
- Or use Xcode's Export/Import Localizations workflow with professional translators
```

**Better approach:** Export for translators
```bash
# Export .xliff for professional translation
xcodebuild -exportLocalizations -project YourProject.xcodeproj -localizationPath ./Localizations

# Send .xliff files to translators
# Import completed translations
xcodebuild -importLocalizations -project YourProject.xcodeproj -localizationPath ./Localizations
```

---

## Language Code Reference

Common language codes for `.xcstrings`:

| Code | Language | Code | Language |
|------|----------|------|----------|
| `en` | English | `de` | German |
| `it` | Italian | `fr` | French |
| `es` | Spanish | `pt-BR` | Portuguese (Brazil) |
| `el` | Greek | `pl` | Polish |
| `cs` | Czech | `ru` | Russian |
| `ro` | Romanian | `uk` | Ukrainian |
| `sl` | Slovenian | `hr` | Croatian |
| `sk` | Slovak | `hu` | Hungarian |
| `ja` | Japanese | `ko` | Korean |
| `zh-Hans` | Chinese (Simplified) | `zh-Hant` | Chinese (Traditional) |
| `ar` | Arabic | `he` | Hebrew |
| `tr` | Turkish | `vi` | Vietnamese |

---

## Key Naming Best Practices

Use structured naming:
```
{feature}_{component}_{property}

Examples:
✅ onboarding_feature_prices
✅ settings_language_picker_title
✅ chart_tooltip_price_range

❌ prices (too vague)
❌ languagePickerTitle (mixed casing)
❌ settings.language.title (dots don't work in JSON keys)
```

---

## Validation Checklist

Before completing:
```
□ All keys follow naming convention
□ No duplicate keys
□ All translations provided for each key
□ JSON is valid (test with `jq . Localizable.xcstrings`)
□ File is properly formatted (2-space indent)
□ Keys are alphabetically sorted
□ No typos in language codes
□ Xcode can build without errors
```

---

## Related Skills
- `/swift:localize` — Individual string localization (legacy .strings support)
- `/swift:app-store-prep` — Localized App Store metadata
- `/swift:full-cycle` — Complete app build + localization workflow

---

**Implementation Note:**
This skill operates on `.xcstrings` JSON directly. For legacy `.strings` files, use `/swift:localize` instead.

---
Last updated: 2025-02-25
