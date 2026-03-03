# Swift Rules

## Safety
- Avoid force unwrapping (`!`) — use `guard let`, `if let`, or `??`
- Use `@MainActor` for UI-related code
- Mark classes as `final` unless designed for inheritance
- Use `Sendable` protocol for types crossing concurrency boundaries

## Patterns
- Prefer structs over classes (value semantics)
- Use protocols with extensions for shared behavior
- Use `Result<T, Error>` for failable operations
- Use property wrappers for cross-cutting concerns
- Prefer composition over inheritance

## Naming
- Follow Swift API Design Guidelines
- Use camelCase for variables, functions, parameters
- Use PascalCase for types, protocols, enums
- Prefix boolean properties with `is`, `has`, `should`

## Concurrency
- Use structured concurrency (async/await, TaskGroup)
- Avoid unstructured `Task { }` when possible
- Use actors for mutable shared state
- Cancel tasks when their owner is deallocated

## Memory
- Use `[weak self]` in closures that outlive their scope
- Avoid retain cycles — break with `weak` or `unowned`
- Use `Instruments` to profile memory usage
- Prefer value types to avoid reference counting overhead

## SwiftUI
- Keep views small and focused
- Extract subviews for reuse
- Use `@StateObject` for creation, `@ObservedObject` for injection
- Prefer `@Environment` over deep prop drilling
- Use `ViewModifier` for reusable styling

## Error Handling
- Use typed throws where possible (Swift 6+)
- Define domain-specific error enums
- Provide user-facing error messages separately from technical errors
- Log errors with structured context

## Localization

### Modern Approach (.xcstrings)
- Use Xcode 15+ String Catalogs (`Localizable.xcstrings`) over legacy `.strings` files
- Inline editing, compile-time validation, zero typos
- Export/import for professional translators: Editor → Export/Import Localizations

### Runtime Language Switching
⚠️ **Common Gotcha:** `.environment(\.locale)` does NOT affect `String(localized:)` calls

**Why:** `String(localized:)` reads from `Bundle.main` directly, ignoring SwiftUI environment.

**Solution:** Bundle override pattern for in-app language switching without restart:
```swift
// LocalizationManager.swift
@MainActor @Observable
class LocalizationManager {
    var currentLanguage: String = Locale.current.language.languageCode?.identifier ?? "en"
    var refreshID = UUID()

    func setLanguage(_ code: String) {
        currentLanguage = code
        Bundle.setLanguage(code)
        UserDefaults.standard.set([code], forKey: "AppleLanguages")
        refreshID = UUID() // Force SwiftUI redraw
    }
}

extension Bundle {
    private static var bundleKey: UInt8 = 0

    static func setLanguage(_ code: String) {
        object_setClass(Bundle.main, PrivateBundle.self)
    }

    class PrivateBundle: Bundle {
        override func localizedString(forKey key: String, value: String?, table tableName: String?) -> String {
            guard let path = Bundle.main.path(forResource: UserDefaults.standard.stringArray(forKey: "AppleLanguages")?.first, ofType: "lproj"),
                  let bundle = Bundle(path: path) else {
                return super.localizedString(forKey: key, value: value, table: tableName)
            }
            return bundle.localizedString(forKey: key, value: value, table: tableName)
        }
    }
}

// In WattoraApp.swift
@main
struct WattoraApp: App {
    @State private var localizationManager = LocalizationManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(localizationManager)
                .id(localizationManager.refreshID) // Key: force redraw on language change
        }
    }
}
```

### Enum Localization
⚠️ **SwiftUI caches enum computed properties** — language changes won't refresh them.

```swift
// ❌ Don't do this (SwiftUI caches the result)
enum Country: String {
    case italy, france
    var displayName: String { String(localized: "country_\(rawValue)") }
}

// ✅ Do this instead (function called on each render)
enum Country: String {
    case italy, france
    func displayName() -> String { String(localized: "country_\(rawValue)") }
}

// Or store in view layer
struct CountryRow: View {
    let country: Country
    var body: some View {
        Text(String(localized: "country_\(country.rawValue)"))
    }
}
```

### Key Naming Convention
Use structured key names for better organization:
```
{feature}_{component}_{property}

Examples:
- onboarding_feature_prices
- settings_language_picker_title
- chart_tooltip_price_range
```
