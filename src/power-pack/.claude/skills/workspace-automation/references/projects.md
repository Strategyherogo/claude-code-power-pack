# Project Context Reference

## YourCompany

**Goal:** €5-15k/month consulting revenue within 3-6 months

**Focus Areas:**
- AI automation consulting (Stripe, billing, SEPA)
- Predictive models (recovery, upsell, risk scoring)
- NEPS (Neuro-Executive Performance System)

**Content Engine:**
- Podcast episodes with guests
- LinkedIn content tied to offers
- Weekly content tied to user pain points

**Key Triggers:**
- "consulting", "proposal" → consulting workflow
- "stripe", "billing", "payment" → payment integration
- "podcast", "episode" → podcast prep

---

## D&S (Apps Factory)

**Path:** `~/Desktop/Apps Factory/`

**Focus Areas:**
- MCP server development
- Mac utilities (Swift, AppKit)
- Chrome extensions
- Cloudflare Workers
- Automation tools

**Key Triggers:**
- "mcp", "server" → MCP builder workflow
- "swift", "mac app" → Swift development
- "chrome extension" → Extension debugging
- "cloudflare", "worker" → CF deployment
- "deploy" → Deployment workflows

---

## SelfOrg (Neuroperformance)

**Database:** `Data_Analytics/00_ACTIVE_PROJECTS/Personal_Health_Analysis/unified_personal_data_2025.db`

**Data:** 621 days of biometrics (Jan 2024 - Sep 2025)

**Key Tables:**
- `daily_metrics` - 63 columns, 621 records
- `raw_metrics` - 174+ metric types, 13,223 records

**Key Metrics:**
- `hrv_rmssd` - Heart rate variability (baseline: 29.7)
- `stress_day` - Daily stress level (baseline: 65.7)
- `energy_day` - Daily energy (baseline: 43.5)
- `sleep_duration`, `deep_sleep_pct`, `rem_sleep_pct`

**Performance States:**
- Peak: HRV>35, stress<50, energy>60 → hardest work
- Good: HRV>30, stress<60, energy>50 → normal work
- Functional: Baseline levels → routine tasks
- Struggling: HRV<25, stress>70, energy<40 → admin only
- Crisis: HRV<20, stress>80, energy<30 → stop, recover

**Key Triggers:**
- "hrv", "stress", "energy", "neuro" → neuroperformance check
- "performance", "optimize" → performance optimization
- "sleep", "recovery" → recovery analysis

---

## Cross-Project Patterns

**Common Workflows:**
1. Start session → load project context → check pending items
2. Development → TDD → deploy → verify
3. Content → draft → edit → publish → promote
4. Analysis → query DB → visualize → report

**Integration Points:**
- Neuroperformance data informs work scheduling
- YourCompany content feeds podcast prep
- D&S tools support consulting automation
