# Skill: swift:full-cycle
Single orchestrator for the full iOS/macOS app development cycle. Runs the right skills in order based on your current phase.

## Auto-Trigger
**When:** "full cycle", "swift full", "ios pipeline", "ship my app", "full ios workflow"

## Usage
```
/commands:swift:full-cycle              → Auto-detect phase
/commands:swift:full-cycle new          → New feature
/commands:swift:full-cycle debug        → Debugging
/commands:swift:full-cycle ship         → Shipping to App Store
```

---

## Phase Detection

If no argument given, detect phase from context:
```
□ Has Xcode project? → Which one? (18/20/25/26)
□ Has failing tests or crashes? → DEBUG phase
□ Has uncommitted feature code? → BUILD phase
□ Has passing tests + clean build? → SHIP phase
□ Starting fresh? → NEW phase
```

---

## Phase: NEW (New Feature / New Project)

### Step 1: Gate Check
Run `/commands:gate` — verify environment is ready:
```
□ Xcode installed + correct version
□ Signing identity valid
□ Provisioning profiles current
□ Target device/simulator available
```

### Step 2: Scaffold (if new project)
Run `/commands:scaffold swift-app` — generate project structure:
```
Views/ ViewModels/ Models/ Services/ Utilities/
```

### Step 3: UX Patterns
Run `/commands:swift:ux-patterns` — reference for the feature being built:
- Onboarding? → Check permission timing, tutorial rules
- Subscription? → Check paywall design, trial length, required disclosures
- Feedback? → Check form design, NPS patterns

### Step 4: TDD
Run `/commands:tdd` — write tests first:
```
Red → Green → Refactor
XCTest template for Swift
```

**Output:** Project scaffolded, tests written, feature implemented.

---

## Phase: BUILD (Active Development)

### Step 1: UX Patterns Check
Run `/commands:swift:ux-patterns` — verify implementation matches best practices:
```
□ Onboarding: learn-by-doing, <30s to value, permissions just-in-time
□ Subscription: side-by-side paywall (no toggles!), required disclosures
□ Ratings: pre-prompt pattern, trigger after value moments
□ Feedback: emoji scales, 1-3 questions max
```

### Step 2: Localization (if multi-language)
Run `/commands:swift:localize`:
```
□ String Catalog setup
□ Pluralization rules
□ Pseudolocalization test
```

### Step 3: Edge Testing
Run `/commands:edge-test`:
```
□ Input boundaries (nil, empty, max)
□ Network failure states
□ Concurrency edge cases
□ Memory pressure
```

**Output:** Feature built, tested, UX-compliant.

---

## Phase: DEBUG

### Step 1: Identify Problem Type
```
Async/await error?     → /commands:swift:async-troubleshoot (5-15 min)
  MainActor isolation, Sendable, task cancellation, deadlocks

Memory leak?           → /commands:swift:debug-memory (10-20 min)
  Instruments, retain cycles, closure captures, observers

General bug?           → /commands:systematic-debug
  Reproduce → Isolate → Hypothesize → Test → Fix → Prevent

Performance?           → /commands:perf-test
  Profiling, bottleneck identification
```

### Step 2: Fix + Regression Test
After fixing, write a regression test via `/commands:tdd`.

**Output:** Bug fixed, regression test added.

---

## Phase: SHIP (App Store Submission)

### Step 1: Preflight
Run `/commands:preflight`:
```
□ ASC API key configured
□ Signing identity valid
□ Provisioning profiles current
□ Bundle ID matches App Store Connect
□ Version/build number incremented
```

### Step 2: UX Compliance Audit
Run `/commands:swift:ux-patterns` — final check:
```
□ No toggle paywalls (banned 2026)
□ All subscription disclosures present
□ Restore Purchases button exists
□ Rating prompts use SKStoreReviewController only
□ Permissions have priming screens
```

### Step 3: App Store Prep
Run `/commands:swift:app-store-prep` (30-60 min):
```
□ Code: no force unwraps, no debug prints, strict concurrency
□ Build: release config, archive succeeds
□ Metadata: screenshots, description, keywords, privacy labels
□ TestFlight: internal → external → feedback incorporated
□ Common rejections checklist
```

### Step 4: Publish
Run `/commands:publish`:
```
□ Archive: xcodebuild -scheme MyApp archive
□ Export: xcodebuild -exportArchive
□ Upload: xcrun altool --upload-app (or Transporter)
□ Verify: App Store Connect shows build
□ Submit for review
```

**Output:** App submitted to App Store.

---

## Your Swift Projects
| # | Project | Type |
|---|---------|------|
| 18 | tools-iphone-layout | SwiftUI layouts |
| 20 | email-converter-app | File I/O + format parsing |
| 25 | claude-usage-battery | macOS menu bar app |
| 26 | ai-bulk-editor | Multi-file editing |

## All Swift Skills
| Skill | Purpose | When |
|-------|---------|------|
| `gate` | Environment check | Before any build |
| `scaffold` | Project structure | New projects |
| `swift:ux-patterns` | UX reference card | During feature dev |
| `tdd` | Test-driven dev | Writing features |
| `edge-test` | Boundary testing | QA phase |
| `swift:async-troubleshoot` | Concurrency bugs | Debugging |
| `swift:debug-memory` | Memory leaks | Debugging |
| `swift:localize` | i18n/l10n | Multi-language |
| `preflight` | Pre-submit checks | Before shipping |
| `swift:app-store-prep` | Submission checklist | Shipping |
| `publish` | Archive + upload | Final step |

---
Last updated: 2026-02-24
