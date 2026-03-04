# Skill: geo-audit
AI Search Visibility Audit — optimize content for ChatGPT, Perplexity, Google AI Overviews, and other generative engines.

## Auto-Trigger
**When:** "geo audit", "ai seo", "ai search", "llms.txt", "generative engine", "ai visibility", "citation optimization"

## Context
GEO (Generative Engine Optimization) ensures your content gets cited by AI systems — not just ranked by Google. Traditional SEO gets you into search results; GEO gets you into AI-generated answers.

## Workflow

### Step 1 — Identify Target
Ask for URL or domain if not provided. Determine:
- Is this a product site, SaaS, blog, or app landing page?
- Primary audience and intent

### Step 2 — Technical AI Readiness (use Bash curl + WebFetch)

Check these in parallel:

**a) robots.txt AI policy**
```bash
curl -s [URL]/robots.txt
```
Check for:
- `User-agent: GPTBot` (ChatGPT crawler)
- `User-agent: Google-Extended` (Gemini/AI Overviews)
- `User-agent: ClaudeBot` (Anthropic)
- `User-agent: PerplexityBot`
- `User-agent: Applebot-Extended` (Apple Intelligence)
Verdict: Are AI crawlers allowed or blocked?

**b) llms.txt / llms-full.txt**
```bash
curl -sI [URL]/llms.txt
curl -sI [URL]/llms-full.txt
```
If missing → recommend creating one. See generation step below.

**c) Structured Data (JSON-LD)**
Fetch page and check for `<script type="application/ld+json">`:
- Organization schema
- Product/SoftwareApplication schema
- FAQ schema
- HowTo schema
- Article/BlogPosting schema
- BreadcrumbList schema

**d) Sitemap.xml**
```bash
curl -s [URL]/sitemap.xml | head -50
```

### Step 3 — Content Citability Audit (use WebFetch)

Fetch 3-5 key pages and evaluate:

| Signal | What to check | Score (0-10) |
|--------|--------------|-------------|
| **Authoritative claims** | Stats, data points, specific numbers AI can cite | |
| **Entity clarity** | Is the brand/product clearly defined as an entity? | |
| **Structured answers** | Q&A format, definition-style paragraphs, listicles | |
| **Source attribution** | Links to authoritative sources that validate claims | |
| **Unique data** | Original research, benchmarks, case studies AI can't find elsewhere | |
| **Concise definitions** | 1-2 sentence answers AI can extract directly | |
| **Topical authority** | Deep coverage of a niche vs thin spread | |
| **Freshness signals** | Published/updated dates, recent data references | |

### Step 4 — E-E-A-T for AI Engines

| Dimension | Evidence to look for |
|-----------|---------------------|
| **Experience** | First-person accounts, screenshots, original photos |
| **Expertise** | Author bios, credentials, technical depth |
| **Authority** | Backlink profile, brand mentions, industry recognition |
| **Trust** | HTTPS, privacy policy, contact info, reviews |

### Step 5 — AI Citation Test (use WebSearch)

Test how AI engines currently surface the brand:
```
WebSearch: "[brand name] [primary keyword]"
WebSearch: "best [category] [year]"
WebSearch: "[brand] vs [competitor]"
```
Check: Does the brand appear in AI-generated summaries? In what context?

### Step 6 — Generate Recommendations

#### Priority fixes (output as actionable items):

**llms.txt generation** (if missing):
```
# [Brand Name]
> [One-line description]

## About
[2-3 sentences about the company/product]

## Key Products/Services
- [Product 1]: [description]
- [Product 2]: [description]

## Documentation
- [Link to docs]
- [Link to API reference]

## Contact
- [website]
- [support email]
```

**JSON-LD schema** (generate for the specific site type):
- SoftwareApplication for apps
- Organization + WebSite for company sites
- Product for e-commerce
- Article for blogs

**Content optimization** — rewrite suggestions for top pages:
- Add definition-style opening paragraphs
- Add FAQ sections with concise answers
- Add structured data markup
- Add "What is [X]?" sections AI can extract

**robots.txt updates** — ensure AI crawlers are allowed

### Step 7 — Competitor AI Visibility Comparison

If competitors provided, compare:
| Metric | You | Competitor A | Competitor B |
|--------|-----|-------------|-------------|
| llms.txt | ✅/❌ | | |
| JSON-LD schemas | count | | |
| AI crawler access | ✅/❌ | | |
| Citation in ChatGPT | ✅/❌ | | |
| Citation in Perplexity | ✅/❌ | | |
| Citation in Google AI | ✅/❌ | | |

## Output Format

```markdown
## GEO Audit: [URL]
**Date:** [date]
**AI Visibility Score:** [X/100]

### AI Crawler Access
| Crawler | Status | Action |
|---------|--------|--------|
| GPTBot | ✅/❌ | |
| Google-Extended | ✅/❌ | |
| ClaudeBot | ✅/❌ | |
| PerplexityBot | ✅/❌ | |
| Applebot-Extended | ✅/❌ | |

### AI Infrastructure
| Asset | Status | Action |
|-------|--------|--------|
| llms.txt | ✅/❌ | [Generate/Update] |
| JSON-LD | X schemas | [Add: FAQ, Product] |
| Sitemap | ✅/❌ | |

### Content Citability: [X/80]
[Table from Step 3 with scores filled in]

### E-E-A-T Signals: [X/40]
[Table from Step 4 with findings]

### Current AI Citations
[Results from Step 5]

### Top 5 Fixes (by impact)
1. [Highest impact fix]
2. ...
3. ...
4. ...
5. ...

### Generated Assets
- llms.txt (if needed)
- JSON-LD schemas (if needed)
- Content rewrite suggestions for top pages
```

## Quick Commands
```
/geo-audit [url]              # Full AI visibility audit
/geo-audit llms [url]         # Check/generate llms.txt only
/geo-audit schema [url]       # Check/generate JSON-LD only
/geo-audit citation [brand]   # Test AI citation only
/geo-audit compare [url] [competitor1] [competitor2]
```

## Reference: AI Crawlers
| Crawler | Engine | robots.txt directive |
|---------|--------|---------------------|
| GPTBot | ChatGPT/OpenAI | `User-agent: GPTBot` |
| OAI-SearchBot | ChatGPT Search | `User-agent: OAI-SearchBot` |
| Google-Extended | Gemini/AI Overviews | `User-agent: Google-Extended` |
| ClaudeBot | Claude/Anthropic | `User-agent: ClaudeBot` |
| PerplexityBot | Perplexity | `User-agent: PerplexityBot` |
| Applebot-Extended | Apple Intelligence | `User-agent: Applebot-Extended` |
| Bytespider | TikTok/Doubao | `User-agent: Bytespider` |
| CCBot | Common Crawl | `User-agent: CCBot` |

## Research Basis
- Princeton KDD 2024: 9 GEO techniques showing +6% to +115% visibility gains
- Key techniques: citation addition, statistics inclusion, fluency optimization, authoritative tone, quotation addition
- Most effective: adding specific statistics (+115%) and authoritative citations (+80%)

---
Last updated: 2026-03-03
