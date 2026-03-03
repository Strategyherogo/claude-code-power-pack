# Skill: swift:localize
App localization workflow for iOS/macOS apps.

## Auto-Trigger
**When:** "localize", "localization", "translate app", "i18n", "l10n", "strings file"

## Localization Workflow

### Step 1: Setup Strings Files
```
Project/
├── en.lproj/
│   └── Localizable.strings
├── de.lproj/
│   └── Localizable.strings
├── es.lproj/
│   └── Localizable.strings
└── Base.lproj/
    └── Main.storyboard
```

### Step 2: String Extraction

#### From SwiftUI
```swift
// Use LocalizedStringKey
Text("welcome_message")
Button("button_save") { }
```

#### From UIKit
```swift
let text = NSLocalizedString("welcome_message", comment: "Welcome screen greeting")
```

### Step 3: Localizable.strings Format
```
/* Welcome screen greeting */
"welcome_message" = "Welcome to the app!";

/* Save button title */
"button_save" = "Save";

/* Error message with parameter */
"error_message_%@" = "Error: %@";
```

## String Catalog (Modern Approach)

### Localizable.xcstrings
```json
{
  "sourceLanguage": "en",
  "strings": {
    "welcome_message": {
      "localizations": {
        "en": {
          "stringUnit": {
            "state": "translated",
            "value": "Welcome!"
          }
        },
        "de": {
          "stringUnit": {
            "state": "translated",
            "value": "Willkommen!"
          }
        }
      }
    }
  }
}
```

## Localization Checklist

### Code
- [ ] All user-facing strings use NSLocalizedString or LocalizedStringKey
- [ ] No hardcoded strings in views
- [ ] Format strings handle plurals correctly
- [ ] Date/number formatters use locale

### Assets
- [ ] Images with text have localized versions
- [ ] App icon (if contains text)
- [ ] Launch screen localized

### Metadata
- [ ] App Store description per language
- [ ] Keywords per language
- [ ] Screenshots per language
- [ ] What's New per language

## Extract Strings Script

```bash
#!/bin/bash
# Extract all localizable strings from Swift files

find . -name "*.swift" -exec grep -h 'NSLocalizedString\|LocalizedStringKey\|"[a-z_]*"' {} \; | \
  grep -oE '"[a-z_]+"' | \
  sort | uniq > extracted_keys.txt

echo "Found $(wc -l < extracted_keys.txt) unique string keys"
```

## Translation Template

### For Translators
```markdown
# Localization: [Language]

## App: [App Name]
## Version: [version]
## Total strings: XX

| Key | English | [Target Language] | Notes |
|-----|---------|-------------------|-------|
| welcome_message | Welcome! | | Shown on launch |
| button_save | Save | | Action button |
| error_network | Network error | | Error state |
```

## Common Languages (Priority)

| Language | Code | Market |
|----------|------|--------|
| English | en | Global |
| German | de | DACH region |
| Spanish | es | Spain, LatAm |
| French | fr | France, Canada |
| Japanese | ja | Japan |
| Chinese (Simplified) | zh-Hans | China |

## Pluralization

### Stringsdict
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "...">
<plist version="1.0">
<dict>
    <key>items_count</key>
    <dict>
        <key>NSStringLocalizedFormatKey</key>
        <string>%#@count@</string>
        <key>count</key>
        <dict>
            <key>NSStringFormatSpecTypeKey</key>
            <string>NSStringPluralRuleType</string>
            <key>NSStringFormatValueTypeKey</key>
            <string>d</string>
            <key>one</key>
            <string>%d item</string>
            <key>other</key>
            <string>%d items</string>
        </dict>
    </dict>
</dict>
</plist>
```

### Usage
```swift
String(format: NSLocalizedString("items_count", comment: ""), itemCount)
```

## Quick Commands
```
/swift:localize extract           # Extract strings from code
/swift:localize add [language]    # Add new language
/swift:localize check             # Find missing translations
/swift:localize export            # Export for translators
```

## Testing Localization

```bash
# Run app in specific locale
xcrun simctl boot "iPhone 15"
xcrun simctl launch booted com.app.bundleid -AppleLanguages "(de)" -AppleLocale "de_DE"
```

### Pseudolocalization
Test layout with longer strings:
```swift
#if DEBUG
extension String {
    var pseudoLocalized: String {
        return "[\(self.map { "[\($0)]" }.joined())]"
    }
}
#endif
```

---
Last updated: 2026-01-29
