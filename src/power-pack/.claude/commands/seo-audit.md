# Skill: seo-audit
Page and site SEO analysis.

## Auto-Trigger
**When:** "seo audit", "seo check", "search optimization", "meta tags", "seo analysis"

## Quick SEO Checklist

### Technical SEO
- [ ] **HTTPS** - Site uses SSL
- [ ] **Mobile-friendly** - Responsive design
- [ ] **Page speed** - <3s load time
- [ ] **robots.txt** - Exists and correct
- [ ] **sitemap.xml** - Exists and submitted
- [ ] **Canonical URLs** - Set correctly
- [ ] **404 handling** - Custom page
- [ ] **Redirects** - 301s, no chains

### On-Page SEO
- [ ] **Title tag** - 50-60 chars, keyword included
- [ ] **Meta description** - 150-160 chars, compelling
- [ ] **H1 tag** - One per page, includes keyword
- [ ] **Header hierarchy** - H1 > H2 > H3
- [ ] **Image alt text** - Descriptive, keyword-rich
- [ ] **Internal links** - Logical structure
- [ ] **URL structure** - Clean, descriptive

### Content
- [ ] **Keyword targeting** - Primary + secondary
- [ ] **Content length** - 1000+ words for main pages
- [ ] **Readability** - Clear, scannable
- [ ] **Fresh content** - Regular updates
- [ ] **No duplicate content** - Unique pages

## Page Audit Template

```markdown
## SEO Audit: [URL]
**Date:** [date]
**Score:** [X/100]

### Technical

| Check | Status | Notes |
|-------|--------|-------|
| HTTPS | ✅/❌ | |
| Mobile-friendly | ✅/❌ | |
| Page speed | Xs | Target: <3s |
| Core Web Vitals | | LCP/FID/CLS |

### Meta Tags

| Tag | Current | Recommendation |
|-----|---------|----------------|
| Title | "[current]" | [suggested] |
| Description | "[current]" | [suggested] |
| Canonical | [url] | |
| OG Tags | ✅/❌ | |

### Content

| Metric | Value | Target |
|--------|-------|--------|
| Word count | X | 1000+ |
| H1 count | X | 1 |
| Images | X | With alt text |
| Internal links | X | 3+ |
| External links | X | 1+ |

### Keywords

**Target keyword:** [keyword]
**In title:** ✅/❌
**In H1:** ✅/❌
**In URL:** ✅/❌
**In first 100 words:** ✅/❌
**Density:** X%

### Issues Found

| Priority | Issue | Fix |
|----------|-------|-----|
| HIGH | [issue] | [fix] |
| MEDIUM | [issue] | [fix] |
| LOW | [issue] | [fix] |

### Recommendations
1. [Top recommendation]
2. [Second recommendation]
3. [Third recommendation]
```

## Audit Commands

### Using curl/wget
```bash
# Check response headers
curl -I https://example.com

# Check page content
curl -s https://example.com | grep -E "<title>|<meta|<h1"

# Check robots.txt
curl -s https://example.com/robots.txt

# Check sitemap
curl -s https://example.com/sitemap.xml
```

### Using Lighthouse (CLI)
```bash
# Install
npm install -g lighthouse

# Run audit
lighthouse https://example.com --output json --output-path ./report.json

# Categories: performance, accessibility, best-practices, seo
lighthouse https://example.com --only-categories=seo
```

### Using PageSpeed API
```bash
# API call
curl "https://www.googleapis.com/pagespeedonline/v5/runPagespeed?url=https://example.com&strategy=mobile"
```

## Meta Tag Templates

### Basic HTML
```html
<head>
  <title>Primary Keyword - Secondary Keyword | Brand</title>
  <meta name="description" content="Compelling description with keyword in first 160 chars.">
  <link rel="canonical" href="https://example.com/page">

  <!-- Open Graph -->
  <meta property="og:title" content="Page Title">
  <meta property="og:description" content="Description for social sharing">
  <meta property="og:image" content="https://example.com/image.jpg">
  <meta property="og:url" content="https://example.com/page">
  <meta property="og:type" content="website">

  <!-- Twitter -->
  <meta name="twitter:card" content="summary_large_image">
  <meta name="twitter:title" content="Page Title">
  <meta name="twitter:description" content="Description">
  <meta name="twitter:image" content="https://example.com/image.jpg">
</head>
```

### Next.js
```tsx
export const metadata = {
  title: 'Page Title | Brand',
  description: 'Meta description here',
  openGraph: {
    title: 'OG Title',
    description: 'OG Description',
    images: ['/og-image.jpg'],
  },
};
```

## Tools Reference

| Tool | Use | Free |
|------|-----|------|
| Google Search Console | Rankings, indexing | ✅ |
| Google PageSpeed | Performance | ✅ |
| Lighthouse | Full audit | ✅ |
| Screaming Frog | Crawl analysis | Freemium |
| Ahrefs | Backlinks, keywords | Paid |
| SEMrush | Full SEO suite | Paid |

## Quick Commands
```
/seo-audit [url]        # Full page audit
/seo-audit meta [url]   # Check meta tags only
/seo-audit speed [url]  # Check page speed
/seo-audit checklist    # Show checklist
```

---
Last updated: 2026-01-29
