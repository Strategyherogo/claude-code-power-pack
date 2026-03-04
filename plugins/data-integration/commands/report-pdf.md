# Skill: report-pdf
Generate PDF or HTML email reports from data.

## Auto-Trigger
**When:** "generate report", "pdf report", "export pdf", "create report", "html email", "email report"

## Report Types

### Executive Summary
```markdown
# Executive Summary Report
**Period:** [date range]
**Generated:** [timestamp]

## Key Highlights
- [Metric 1]: [value] ([change]%)
- [Metric 2]: [value] ([change]%)
- [Metric 3]: [value] ([change]%)

## Summary
[2-3 paragraph overview]

## Key Achievements
1. [Achievement]
2. [Achievement]
3. [Achievement]

## Challenges
1. [Challenge] - [Mitigation]
2. [Challenge] - [Mitigation]

## Next Period Focus
1. [Priority]
2. [Priority]
3. [Priority]
```

### Detailed Analytics Report
```markdown
# Analytics Report
**Period:** [date range]

## Executive Summary
[Brief overview]

## Key Metrics

### Metric 1: [Name]
**Current:** [value]
**Previous:** [value]
**Change:** [+/-X%]

[Chart/Graph placeholder]

[Analysis paragraph]

### Metric 2: [Name]
[Same structure]

## Trends Analysis
[Trend observations]

## Recommendations
1. [Recommendation based on data]
2. [Recommendation]
3. [Recommendation]

## Appendix
### Data Sources
- [Source 1]
- [Source 2]

### Methodology
[Brief methodology description]
```

### Project Status Report
```markdown
# Project Status Report
**Project:** [Name]
**Date:** [date]
**Status:** 🟢 On Track / 🟡 At Risk / 🔴 Delayed

## Summary
**Completion:** [X]%
**Budget Used:** [X]%
**Timeline:** [On/Ahead/Behind] schedule

## Milestones
| Milestone | Target | Actual | Status |
|-----------|--------|--------|--------|
| [M1] | [date] | [date] | ✅ |
| [M2] | [date] | - | 🔄 |
| [M3] | [date] | - | ⏳ |

## This Period
### Completed
- [Item]
- [Item]

### In Progress
- [Item] - [X]%
- [Item] - [X]%

## Risks & Issues
| Risk | Probability | Impact | Mitigation |
|------|-------------|--------|------------|
| [Risk] | Med | High | [Plan] |

## Next Period Plan
- [Task]
- [Task]

## Resource Needs
- [Need]
```

## PDF Generation Methods

### Using Python (ReportLab)
```python
from reportlab.lib.pagesizes import letter
from reportlab.pdfgen import canvas
from reportlab.lib.styles import getSampleStyleSheet
from reportlab.platypus import SimpleDocTemplate, Paragraph, Table

def generate_report_pdf(data, output_path):
    doc = SimpleDocTemplate(output_path, pagesize=letter)
    elements = []
    styles = getSampleStyleSheet()

    # Title
    elements.append(Paragraph("Report Title", styles['Title']))

    # Content
    elements.append(Paragraph(data['summary'], styles['Normal']))

    # Table
    table_data = [['Metric', 'Value', 'Change']]
    for metric in data['metrics']:
        table_data.append([metric['name'], metric['value'], metric['change']])

    table = Table(table_data)
    elements.append(table)

    doc.build(elements)
```

### Using Node.js (PDFKit)
```javascript
const PDFDocument = require('pdfkit');
const fs = require('fs');

function generateReport(data, outputPath) {
    const doc = new PDFDocument();
    doc.pipe(fs.createWriteStream(outputPath));

    // Title
    doc.fontSize(24).text('Report Title', { align: 'center' });
    doc.moveDown();

    // Content
    doc.fontSize(12).text(data.summary);
    doc.moveDown();

    // Table (simplified)
    data.metrics.forEach(metric => {
        doc.text(`${metric.name}: ${metric.value} (${metric.change})`);
    });

    doc.end();
}
```

### Using Markdown → PDF
```bash
# Using pandoc
pandoc report.md -o report.pdf --pdf-engine=xelatex

# Using md-to-pdf (Node.js)
npx md-to-pdf report.md

# Using grip (GitHub-styled)
grip report.md --export report.html
# Then print to PDF
```

### HTML Email Output
For reports shared via email with styled tables (investor reports, SLA summaries, etc.):

```
1. Use the template: .claude/templates/email-tables.html
2. Copy template, replace placeholder content
3. CSS classes available:
   - .num       — right-align numeric cells
   - .red       — red bold (breaches, failures)
   - .green     — green (compliant, good)
   - .orange    — orange bold (warnings)
   - .muted     — gray secondary info
   - tr.total   — bold summary row with top border
   - .note      — small gray footnote
4. Preview: open output.html in browser
5. Send: copy HTML body into email client, or paste as HTML source
```

**Important for email clients:**
- Avoid backtick formatting (doesn't render in email)
- Use quotes "ir" instead of `ir`
- Test in Gmail/Outlook before sending — some strip `<style>` blocks
- For maximum compatibility, consider inline styles for critical formatting

### Markdown → Chrome PDF (no weasyprint needed)
```bash
# Step 1: Markdown → HTML
pandoc report.md -o /tmp/report.html --standalone

# Step 2: Chrome headless → PDF
"/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" \
  --headless --disable-gpu --no-pdf-header-footer \
  --print-to-pdf=report.pdf /tmp/report.html
```

## Report Checklist
```
□ Clear title and date
□ Executive summary first
□ Key metrics highlighted
□ Charts/visuals for data
□ Clear section headers
□ Page numbers
□ Consistent formatting
□ Sources cited
□ Contact information
□ Version/date stamp
```

## Styling Guidelines
```
Fonts: Professional (Helvetica, Arial, Times)
Colors: Minimal, brand-aligned
Margins: 1 inch standard
Spacing: Adequate white space
Headers: Consistent hierarchy
Tables: Clear borders, alternating rows
Charts: Labeled axes, legends
```

---
Last updated: 2026-02-10
