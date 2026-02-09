# Swift Development Workflow
Reference for debugging and shipping Swift/macOS apps.

## Quick Reference
| Problem | Skill | Time |
|---------|-------|------|
| MainActor/async error | `/swift:async-troubleshoot` | 5-15 min |
| Memory leak | `/swift:debug-memory` | 10-20 min |
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

## Resources
- Apple: [Swift Docs](https://developer.apple.com/swift)
- Concurrency: [Structured Concurrency](https://developer.apple.com/wwdc21/10134)
- Memory: Instruments → Product → Profile
- App Store: Use `/swift:app-store-prep` checklist

---
Last updated: 2026-01-27
