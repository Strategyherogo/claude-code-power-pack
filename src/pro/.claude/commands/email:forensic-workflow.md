# Skill: email:forensic-workflow
5-step methodology for defensible email investigations.

## Auto-Trigger
**When:** "email forensic", "email investigation", "investigate emails", "email audit"

## Forensic Workflow (5 Steps)

### Step 1: Scope & Preparation (30 min)

#### Define Investigation Parameters
```
□ What question are we answering?
□ Who are the custodians (email owners)?
□ What date range is relevant?
□ What search terms/keywords apply?
□ Are legal holds in place?
□ Who needs to be notified?
```

#### Document Scope
```markdown
## Investigation Scope

**Matter:** [name]
**Objective:** [specific question to answer]
**Custodians:** [list of email accounts]
**Date Range:** [start] to [end]
**Keywords:** [search terms]
**Authorized By:** [name, date]
```

### Step 2: Data Collection (1-2 hours)

#### Collection Methods
```bash
# Google Workspace (via Admin Console)
# Data Export → Select user → Email → Download

# Microsoft 365 (via eDiscovery)
# Compliance Center → Content Search → Export

# MBOX Export (if available)
# Export settings → Download MBOX → Verify integrity
```

#### Verification Checklist
```
□ Full mailbox exported (not just inbox)
□ Sent mail included
□ Deleted items recovered
□ Attachments preserved
□ Headers captured (full MIME)
□ Hash value computed for integrity
□ Export logged with timestamp
```

#### Metadata to Capture
```
- Message-ID (unique identifier)
- From/To/CC/BCC
- Date and time (with timezone)
- Subject
- X-Originating-IP
- Received headers (full chain)
- DKIM/SPF/DMARC results
- Attachment filenames and hashes
```

### Step 3: Analysis (2-4 hours)

#### Thread Reconstruction
```
1. Sort by conversation/thread ID
2. Map reply chains (In-Reply-To header)
3. Identify missing messages
4. Note forwarded content
5. Flag edited/modified messages
```

#### Metadata Analysis
```bash
# Extract headers
grep -E "^(From|To|Date|Subject|Message-ID|X-Originating-IP):" email.eml

# Check authentication
grep -E "^(DKIM-Signature|Authentication-Results):" email.eml
```

#### Attachment Analysis
```
□ List all attachments with file types
□ Compute hash values (SHA-256)
□ Check for embedded metadata
□ Scan for malware (if relevant)
□ Cross-reference across custodians
```

#### Pattern Analysis
```
- Communication frequency (who talks to whom)
- Timing patterns (unusual hours)
- IP addresses (location anomalies)
- Language changes (tone shifts)
- Attachment patterns (what's shared)
```

### Step 4: Documentation (1-2 hours)

#### Required Deliverables
```
□ Executive summary (1 page)
□ Numbered findings (each with evidence)
□ Chronological timeline
□ Chain of custody log
□ Evidence appendix
□ Methodology description
□ Limitations acknowledgment
```

#### Use /email:compliance-report
Run `/email:compliance-report` to generate the formal report structure.

### Step 5: Verification & Sign-Off (30 min)

#### Final Review Checklist
```
□ Every finding cites specific evidence
□ Timeline is accurate and complete
□ No speculation or assumptions
□ Chain of custody documented
□ All exports verified against source
□ Legal review (if applicable)
□ Investigator signature and date
□ Witness signature (if required)
```

## Tools & MCP Servers

| Tool | Use Case |
|------|----------|
| /gws-search | Search Google Workspace emails |
| mcp:gdrive | Access Drive for attachments |
| mcp:gmail | Read email content |
| /email:metadata-extract | Analyze headers |

## Your Compliance Projects
- 03-compl-gws-search
- 04-compl-mbox-extractor
- 05-compl-dropbox-search
- 16-gws-forensic-product

## Red Flags to Watch For
```
- Emails to personal accounts before departure
- Large attachment transfers near key dates
- BCC patterns (hiding recipients)
- Deleted emails in relevant timeframe
- Forwarding rules to external addresses
- Unusual login locations (IP analysis)
```

---
Last updated: 2026-01-27
