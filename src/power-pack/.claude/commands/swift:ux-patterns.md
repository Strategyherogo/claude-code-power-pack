# Skill: swift:ux-patterns
Quick-reference for iOS/macOS app UX patterns: onboarding, subscriptions, ratings, feedback.

## Auto-Trigger
**When:** "ux pattern", "onboarding flow", "paywall design", "rating prompt", "feedback form", "trial design", "subscription ux", "app review prompt"

## Source Documents
`3. Resources/19-apple-ux-patterns/` — 4 detailed reference docs with full research and citations.

---

## 1. Onboarding

### Key Numbers
| Metric | Target |
|--------|--------|
| Time to value | <30 seconds |
| Tutorial screens | Max 3 |
| Day 1 retention | 35%+ (avg: 25.6%) |
| Permission grant rate | 3× higher with priming |

### Rules
- **Learn-by-doing > walkthroughs** — 80-95% completion vs 15-25%
- **Delay registration** — show value first, ask for account after "aha moment" (+20% conversion)
- **Permissions: just-in-time only** — never on launch (72% reject upfront)
- **Prime before system prompt** — custom screen explaining WHY, then trigger system dialog
- **iOS 17+ TipKit** for progressive disclosure — max 1 tip/session, 3+ sessions between tips

### Permission Timing
```
Launch         → Nothing
Session 2-3    → Notifications (after user sees value)
Feature tap    → Camera / Location / Contacts
Content created → Account creation
```

### Anti-Patterns
- ❌ All permissions upfront → 72% rejection
- ❌ Account creation before value → 60-80% drop-off
- ❌ 5+ tutorial screens → 80%+ skip without reading

---

## 2. Subscriptions & Trials

### Key Numbers
| Trial Length | Conversion | Best For |
|-------------|-----------|----------|
| 7 days | 40.4% | Simple apps |
| 14 days | Best with urgency | Standard apps |
| 30+ days | 30.6% | Avoid |

| Paywall Type | Conversion | Retention |
|-------------|-----------|-----------|
| Hard | 12.1% | 12.8% |
| Soft | 2.2% | 9.3% |

### Rules
- **Visual trial timeline** — "Today: Full Access → Day 5: Reminder → Day 7: Charge" (+23% conversion)
- **Side-by-side pricing** — show monthly next to annual with savings badge
- **Pause > Cancel** — offer 1/3/6 month pause (saves ~10% of cancellations)
- **Cancellation = as easy as signup** — FTC "Click to Cancel" rule

### ⚠️ 2026 Breaking Change
**Toggle paywalls BANNED** — Apple mass-rejecting since Jan 2026. Use side-by-side plans instead.

### Required Disclosures (Apple 3.1.2)
All must appear in-app (not just StoreKit modal):
```
□ Subscription name, duration, price
□ Auto-renewal terms + how to cancel
□ "Payment charged to iTunes at confirmation"
□ "Unused trial forfeited upon purchase"
□ Restore Purchases button
□ Privacy Policy + Terms links
```

### Cancellation Flow
```
1. Ask why (multi-choice)
2. Offer alternative:
   - Pause (1/3/6 months)
   - Discount (10-50% for 3-6 months)
   - Downgrade tier
3. Show what they'll lose
4. Confirm
```

---

## 3. Ratings

### Key Numbers
| Threshold | Value |
|-----------|-------|
| System cap | 3 prompts/user/year |
| Min days since install | 7 |
| Min sessions | 5 |
| Min significant actions | 10 |
| Spacing between prompts | 90-120 days |

### Rules
- **Pre-prompt first** — "Enjoying the app?" → happy → `SKStoreReviewController`, unhappy → feedback form
- **Trigger after value moments** — task completed, milestone reached, streak continued
- **Never after**: first launch, errors, crashes, mid-task, onboarding
- **SKStoreReviewController only** — no custom dialogs mimicking native (Guideline 5.6.1)

### Pre-Prompt Pattern
```
┌─────────────────────────┐
│  Are you enjoying App?  │
│                         │
│  [Not Really]  [Yes!]   │
│                         │
│  Not Really → Feedback  │
│  Yes → SKStoreReview    │
└─────────────────────────┘
```

### Settings "Rate This App" Button
```
First tap  → SKStoreReviewController (may show native dialog)
Second tap → Open App Store review page directly
```

### Anti-Patterns
- ❌ Custom UI mimicking native rating dialog
- ❌ Incentivized reviews ("Rate 5★ for premium")
- ❌ Gate features behind rating
- ❌ Prompt after crash/error

---

## 4. Feedback

### Key Numbers
| Questions | Completion |
|-----------|-----------|
| 1-3 | 85% |
| 4-8 | 60% |
| 9-12 | 35% |
| 12+ | <20% |

| Input Type | Completion |
|-----------|-----------|
| Yes/No | 92% |
| Emoji scale | 88% |
| Single choice | 76% |
| Short text | 54% |
| Matrix/grid | 18% |

### Rules
- **Emoji scales > text scales** — 88% vs 54% completion
- **Max once per 30 days** per survey type
- **Follow up when fixed** — users who hear back are 3.5× more likely to give feedback again
- **Auto-capture device info** with consent checkbox
- **Sanitize logs** — strip emails, API tokens, PII before sending

### Feedback Form Template
```
[Category ▾] Bug / Feature / General  (optional)
[Text field] "Tell us what's on your mind..."  (required)
[📸 Attach Screenshot]  (one-tap auto-capture)
☑ Include device info
[Email] (optional)
[Cancel] [Submit]
```

### NPS Mobile Pattern
```
How likely to recommend?
😞          😐          😄
0-6         7-8         9-10

Detractor → "What disappointed you?"
Passive   → "What would make this a 10?"
Promoter  → "Mind leaving a review?" → SKStoreReview
```

### Timing
- First survey: 7 days or 3 sessions minimum
- After dismissal: wait 7-14 days
- Best times: before 10 AM (+15%), Monday (+10%)
- Optimal cadence: bi-weekly (67% maintained response)

---

## Quick Decision Tree

```
Building onboarding?
  → Learn-by-doing + TipKit + delayed registration

Adding subscription?
  → Side-by-side paywall + 7-day trial + visual timeline

Want more ratings?
  → Pre-prompt pattern + trigger after value moments

Collecting feedback?
  → Emoji scale + 1-3 questions + auto screenshot
```

## Related Skills
- `/commands:swift:app-store-prep` — Full submission checklist
- `/commands:swift:async-troubleshoot` — Concurrency debugging
- `/commands:swift:localize` — Localization workflow

---
Last updated: 2026-02-24
