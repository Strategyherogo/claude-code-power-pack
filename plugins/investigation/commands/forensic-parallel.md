# Skill: forensic-parallel
Multi-agent forensic investigation with auto-correcting validation.

## Status: 🚧 ON THE HORIZON (Foundation)
This is a next-generation capability based on insights analysis. It extends your existing forensic workflows with coordinated parallel agents that self-validate before surfacing findings.

## Vision
Run entire multi-source forensic investigations overnight — a coordinator spawns parallel agents (Dropbox, email, laptop logs), each validates its own assumptions, cross-references timestamps, flags confidence levels, and self-corrects before assembling a court-ready report.

## How It Works

### 1. Coordinator Agent
```markdown
**Role:** Orchestrate the investigation, allocate data sources, merge timelines

**Responsibilities:**
- Spawn 3 sub-agents (Dropbox, Email, Laptop)
- Define validation checkpoints
- Cross-validate findings
- Produce final report
```

### 2. Data Source Agents (3 parallel)

#### Agent 1: Dropbox Audit Analyzer
```markdown
**Input:** Dropbox audit logs
**Tasks:**
- Normalize timestamps to UTC
- Extract file operations (delete, share, download, transfer)
- Build timeline with confidence scores
- Output structured JSON timeline

**Self-Validation:**
- Flag any timezone-naive timestamps
- Detect gaps >4 hours
- Output confidence: high/medium/low for each event
```

#### Agent 2: Email Metadata Analyzer
```markdown
**Input:** Email logs (MBOX/CSV)
**Tasks:**
- Parse sender/recipient/subject/timestamp
- Identify external recipients
- Correlate with Dropbox activity
- Output structured JSON timeline

**Self-Validation:**
- Normalize timezone (PST/UTC/local)
- Flag missing headers or corrupted entries
- Cross-check against Dropbox timeline for overlaps
```

#### Agent 3: Laptop/Network Log Analyzer
```markdown
**Input:** Laptop activity logs, network logs
**Tasks:**
- Extract login/logout events
- Network connections (VPN, IP changes)
- Application usage timestamps
- Output structured JSON timeline

**Self-Validation:**
- Detect impossible sequences (activity while asleep)
- Flag IP location contradictions
- Output system state timeline
```

### 3. Cross-Validation Step

After all agents complete, run validation:
```python
def cross_validate_timelines(dropbox_timeline, email_timeline, laptop_timeline):
    """
    Merge all timelines and detect contradictions.

    Returns:
    - merged_timeline (all events, sorted)
    - contradictions (list of impossible sequences)
    - confidence_report (per-event confidence scores)
    """
    contradictions = []

    # Check: Dropbox file deletion while laptop asleep
    for dropbox_event in dropbox_timeline:
        if dropbox_event['type'] == 'file_delete':
            laptop_state = get_laptop_state_at(dropbox_event['timestamp'], laptop_timeline)
            if laptop_state == 'asleep':
                contradictions.append({
                    'timestamp': dropbox_event['timestamp'],
                    'issue': 'File deletion while laptop asleep',
                    'sources': ['dropbox', 'laptop'],
                    'likely_cause': 'Mobile device or timezone error',
                    'requires_investigation': True
                })

    # Check: Email sent from location A while laptop at location B
    for email_event in email_timeline:
        laptop_ip = get_laptop_ip_at(email_event['timestamp'], laptop_timeline)
        if laptop_ip and email_event['sender_ip'] != laptop_ip:
            # Flag but don't auto-fail (could be VPN)
            contradictions.append({
                'timestamp': email_event['timestamp'],
                'issue': 'Email sent from different IP than laptop',
                'sources': ['email', 'laptop'],
                'likely_cause': 'VPN, mobile device, or IP database stale',
                'requires_investigation': False
            })

    return merged_timeline, contradictions
```

### 4. Assertion Framework
```python
import pytest

def test_no_timezone_naive_timestamps(merged_timeline):
    """All timestamps must be timezone-aware (UTC)."""
    for event in merged_timeline:
        assert event['timestamp'].tzinfo is not None, f"Timezone-naive timestamp: {event}"

def test_timeline_coverage_overlap(dropbox_timeline, email_timeline, laptop_timeline):
    """All sources must have overlapping time coverage."""
    dropbox_range = (min(dropbox_timeline)['timestamp'], max(dropbox_timeline)['timestamp'])
    email_range = (min(email_timeline)['timestamp'], max(email_timeline)['timestamp'])
    laptop_range = (min(laptop_timeline)['timestamp'], max(laptop_timeline)['timestamp'])

    # Check for overlap (at least 50% of date range)
    overlap = calculate_overlap(dropbox_range, email_range, laptop_range)
    assert overlap > 0.5, f"Insufficient timeline overlap: {overlap}"

def test_no_unresolved_contradictions(contradictions):
    """Critical contradictions must be explained or resolved."""
    critical = [c for c in contradictions if c['requires_investigation']]
    assert len(critical) == 0, f"Unresolved contradictions: {critical}"

# Run all tests before generating final report
pytest.main([__file__, '-v'])
```

## Usage

### Step 1: Prepare Data Sources
```bash
# Place investigation data in structured directories
mkdir -p ./investigation/{dropbox,email,laptop}

# Dropbox audit logs → CSV
# Email exports → MBOX or CSV
# Laptop logs → TXT or JSON
```

### Step 2: Run Parallel Investigation
```python
# Use Claude Code's Task tool to orchestrate
from claude_code import Task

coordinator = Task(
    agent_type="forensic-coordinator",
    prompt="""
    Run parallel forensic analysis:

    Data sources:
    - Dropbox: ./investigation/dropbox/audit.csv
    - Email: ./investigation/email/export.mbox
    - Laptop: ./investigation/laptop/activity.log

    1. Spawn 3 parallel agents (one per source)
    2. Each agent: normalize timestamps, build timeline, output JSON
    3. Cross-validate: merge timelines, detect contradictions
    4. Run pytest assertions
    5. Only if all tests pass: generate final HTML report

    Output:
    - timelines/*.json (one per source)
    - contradictions.json
    - validation-report.md
    - final-report.html (only if validated)
    """
)

coordinator.run()
```

### Step 3: Review Validation Report
```markdown
# Validation Report

## Agent Results
✅ Dropbox Agent: 247 events, 0 timezone errors, 2 gaps >4h
✅ Email Agent: 1,543 emails, normalized PST→UTC, 0 corrupted
✅ Laptop Agent: 89,342 events, 12 gaps (system sleep expected)

## Cross-Validation
⚠️  2 contradictions detected:
1. File deletion while laptop asleep (2024-02-18 14:23 UTC)
   → Likely: mobile device deletion
2. Email from office IP while laptop at home (2024-02-20 09:15 UTC)
   → Likely: VPN connection

## Pytest Results
✅ test_no_timezone_naive_timestamps: PASSED
✅ test_timeline_coverage_overlap: PASSED
⚠️  test_no_unresolved_contradictions: FAILED (2 critical)

## Action Required
Investigate 2 contradictions before generating final report.
```

## Getting Started

### Phase 1: Foundation (Now)
```bash
# Create agent templates
mkdir -p .claude/agents/{coordinator,dropbox,email,laptop}

# Define validation schemas
# Install pytest for assertion framework
# Create sample test data
```

### Phase 2: Agent Development
```python
# Implement coordinator agent
# Implement 3 data source agents
# Build cross-validation logic
# Write pytest test suite
```

### Phase 3: Automation
```bash
# Schedule overnight runs via cron
# Email results to user in the morning
# Auto-archive investigation data
```

## Benefits Over Current Workflow

| Current | With Parallel Agents |
|---------|---------------------|
| Manual timezone checks | Auto-detected and corrected |
| Sequential analysis | Parallel (3x faster) |
| User catches errors | Self-validating before report |
| Daytime work | Overnight autonomous runs |
| Correction rounds | One-shot accuracy |

## Next Steps

1. **Read insights analysis** section on "Parallel Forensic Analysis"
2. **Build coordinator agent** scaffold
3. **Create test data** for validation
4. **Implement one agent** (start with Dropbox)
5. **Add pytest assertions**
6. **Test on past investigation** (Dropbox deletion case)

---
**Status:** Foundation phase
**Priority:** High (eliminates #1 friction: data accuracy errors)
**Estimated setup:** 4-6 hours for Phase 1
**Payoff:** Court-ready reports with zero correction rounds
