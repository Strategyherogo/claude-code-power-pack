# Swift Development Workflow
Reference hub for all Swift/iOS/macOS development skills.

## One Command
```
/commands:swift:full-cycle          → Auto-detect phase and run pipeline
/commands:swift:full-cycle new      → New feature
/commands:swift:full-cycle debug    → Debugging
/commands:swift:full-cycle ship     → Shipping to App Store
```

## Quick Reference
| Problem | Skill | Time |
|---------|-------|------|
| Full pipeline | `/swift:full-cycle` | Varies |
| UX decisions | `/swift:ux-patterns` | Reference |
| MainActor/async error | `/swift:async-troubleshoot` | 5-15 min |
| Memory leak | `/swift:debug-memory` | 10-20 min |
| Localization | `/swift:localize` | 15-30 min |
| Ready to ship | `/swift:app-store-prep` | 30-60 min |

## Your Swift Projects
- **18-tools-iphone-layout** – SwiftUI layouts
- **20-email-converter-app** – File I/O + format parsing
- **YOUR_PROJECT** – macOS menu bar app
- **26-ai-bulk-editor** – Multi-file editing

## Lessons Learned
- 2026-01-20: autoreleasepool can block async/await
- 2026-01-20: MainActor issues common in menu bar apps
- 2026-01-21: Structured concurrency patterns matter
- 2026-02-24: Toggle paywalls banned by Apple (Jan 2026)

## Resources
- Apple: [Swift Docs](https://developer.apple.com/swift)
- Concurrency: [Structured Concurrency](https://developer.apple.com/wwdc21/10134)
- Memory: Instruments → Product → Profile
- UX Reference: `3. Resources/19-apple-ux-patterns/` (4 detailed docs)

---
Last updated: 2026-02-24
