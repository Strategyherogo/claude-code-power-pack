# Skill: email:metadata-extract
Deep dive into email headers, IPs, and authentication verification.

## Auto-Trigger
**When:** "email metadata", "email headers", "check email source", "verify sender", "email authentication"

## Header Analysis Workflow

### Step 1: Extract Raw Headers
```bash
# View full headers in email client
Gmail: Open email → ⋮ → Show original
Outlook: Open email → File → Properties → Internet headers

# From MBOX/EML file
grep -A 50 "^Received:" email.eml
```

### Step 2: Key Headers to Analyze

| Header | What It Reveals | Red Flags |
|--------|----------------|-----------|
| **From** | Display name and email | Mismatch between display and address |
| **Return-Path** | Where bounces go | Different from From address |
| **Reply-To** | Where replies go | Different from From (possible phishing) |
| **X-Originating-IP** | Sender's IP | VPN, proxy, unexpected country |
| **Date** | Send timestamp | Future date, inconsistent with Received |
| **Message-ID** | Unique identifier | Malformed or missing |
| **Received** | Server hop chain | Read bottom-to-top for path |

### Step 3: Authentication Verification

#### SPF (Sender Policy Framework)
```
Look for: Authentication-Results header
         Received-SPF header

Results:
pass    = Sender IP authorized for domain
fail    = Sender IP NOT authorized (likely spoofed)
softfail = Not authorized but not enforced
neutral = No policy exists
```

#### DKIM (DomainKeys Identified Mail)
```
Look for: DKIM-Signature header
         Authentication-Results: dkim=pass

Results:
pass    = Signature valid, email unmodified
fail    = Signature invalid (modified or forged)
none    = No DKIM signature
```

#### DMARC (Domain-based Message Authentication)
```
Look for: Authentication-Results: dmarc=pass

Policy values:
p=none      = No action on failure
p=quarantine = Move to spam on failure
p=reject    = Reject email on failure
```

### Step 4: IP Address Analysis

```bash
# Extract originating IP
grep "X-Originating-IP" email.eml

# Lookup IP information
whois [IP_ADDRESS]
curl ipinfo.io/[IP_ADDRESS]

# Check geolocation
curl ipinfo.io/[IP_ADDRESS]/country
```

#### IP Red Flags
```
- Different country than sender claims
- Known VPN/proxy provider
- Hosting company (not ISP)
- Tor exit node
- Previously flagged for spam/abuse
```

### Step 5: Received Chain Analysis

Read from **bottom to top** (oldest first):
```
Received: from mail.sender.com (192.168.1.1)     ← First hop (sender's server)
    by mx.google.com (10.0.0.1)                  ← Second hop
    for <recipient@gmail.com>;                   ← Destination
    Mon, 27 Jan 2026 10:30:00 -0000              ← Timestamp
```

#### What to Check
```
□ Timestamps progress logically (no time travel)
□ Server names match expected domains
□ IPs resolve to expected organizations
□ No unexpected intermediate hops
□ Internal headers match external path
```

### Step 6: Output Report

```markdown
## Email Authentication Report

**Email:** [Subject line]
**From:** [sender@domain.com]
**Date:** [timestamp]

### Authentication Results
| Check | Result | Status |
|-------|--------|--------|
| SPF | pass/fail | ✅/❌ |
| DKIM | pass/fail | ✅/❌ |
| DMARC | pass/fail | ✅/❌ |

### IP Analysis
**Originating IP:** [IP]
**Location:** [City, Country]
**ISP/Org:** [Organization]
**Risk Level:** [Low/Medium/High]

### Conclusion
[Likely legitimate / Potentially spoofed / Confirmed spoofed]

### Evidence
[Relevant header excerpts]
```

## Common Spoofing Patterns

### Display Name Spoofing
```
From: "CEO Name" <random@attacker.com>
             ↑ Real email hidden behind trusted name
```

### Lookalike Domain
```
From: admin@g00gle.com (zeros instead of 'o')
From: support@company-secure.com (added suffix)
```

### Reply-To Hijack
```
From: legitimate@company.com
Reply-To: attacker@gmail.com
          ↑ Replies go to attacker
```

## Quick Reference Commands

```bash
# Full header dump
cat email.eml | head -100

# Extract just authentication
grep -E "^(DKIM|SPF|Authentication-Results):" email.eml

# Get all Received headers
grep "^Received:" email.eml

# Check if IP is in spam blacklist
curl https://api.abuseipdb.com/api/v2/check?ipAddress=[IP]
```

---
Last updated: 2026-01-27
