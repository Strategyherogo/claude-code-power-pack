# Skill: invoice
Generate and send invoices for consulting work.

## Auto-Trigger
**When:** "invoice", "bill client", "send invoice", "billing"

## Invoice Workflow

### Step 1: Gather Invoice Details
```
Client: [client name]
Project: [project/engagement name]
Period: [date range]
Hours: [total billable hours]
Rate: [hourly/daily/fixed rate]
Currency: EUR/USD
```

### Step 2: Calculate Totals
```markdown
## Invoice #[YYYY-MM-XXX]

**From:** TechConcepts
**To:** [Client Name]
**Date:** [today]
**Due:** [+14 days]

### Services Rendered

| Description | Hours | Rate | Amount |
|-------------|-------|------|--------|
| [Service 1] | X | €XXX | €X,XXX |
| [Service 2] | X | €XXX | €X,XXX |

**Subtotal:** €X,XXX
**VAT (21%):** €XXX
**Total:** €X,XXX

### Payment Details
Bank: [bank]
IBAN: [iban]
Reference: INV-[number]
```

### Step 3: Generate Invoice

**Option A: Stripe Invoice**
```bash
# Create Stripe invoice via MCP
# Use stripe MCP server when available
```

**Option B: PDF Generation**
```bash
# Generate PDF from template
# Save to: 3. Resources/00-financial/invoices/[YYYY]/INV-[number].pdf
```

### Step 4: Send Invoice
- Email to client with PDF attached
- Log in financial tracking
- Set reminder for payment due date

## Invoice Templates

### Consulting (Hourly)
- Standard rate: €150-200/hour
- Include timesheet summary

### Project (Fixed)
- Milestone-based billing
- 50% upfront, 50% on completion

### Retainer (Monthly)
- Fixed monthly fee
- Hours included: X
- Overage rate: €XXX/hour

## Storage
```
3. Resources/00-financial/
├── invoices/
│   └── 2026/
│       └── INV-2026-001.pdf
├── timesheets/
└── payments/
```

## Integration
- Stripe: Create/send invoices
- Google Drive: Store PDFs
- Notion: Track payments

---
Last updated: 2026-01-29
