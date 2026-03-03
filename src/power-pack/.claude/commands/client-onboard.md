# Skill: client-onboard
New client onboarding checklist and setup.

## Auto-Trigger
**When:** "new client", "onboard client", "client onboarding", "client setup"

## Onboarding Checklist

### Phase 1: Pre-Engagement
- [ ] **NDA signed** - Mutual NDA if handling sensitive data
- [ ] **Contract signed** - MSA or project-specific agreement
- [ ] **Payment terms agreed** - Net 14/30, retainer, milestone
- [ ] **Point of contact** - Primary contact + backup
- [ ] **Communication channel** - Slack, email, Teams

### Phase 2: Access Setup
- [ ] **Create client folder** - `1. Projects/XX-[client-name]/`
- [ ] **Jira/Linear project** - If using issue tracking
- [ ] **Slack channel** - `#client-[name]` if applicable
- [ ] **Calendar invites** - Recurring syncs scheduled
- [ ] **Credentials received** - Store in 1Password/secure vault

### Phase 3: Technical Setup
- [ ] **Repo access** - GitHub/GitLab permissions
- [ ] **Environment access** - Staging/prod as needed
- [ ] **API keys** - Document in secure location
- [ ] **Documentation reviewed** - Existing docs, architecture
- [ ] **Dev environment** - Local setup working

### Phase 4: Kickoff
- [ ] **Kickoff meeting** - Scope, timeline, expectations
- [ ] **Success criteria** - Define deliverables
- [ ] **Reporting cadence** - Weekly updates, demos
- [ ] **Escalation path** - Who to contact for blockers

## Client Folder Structure
```
1. Projects/XX-[client-name]/
├── README.md           # Project overview
├── CHANGELOG.md        # Progress log
├── docs/
│   ├── requirements.md
│   ├── architecture.md
│   └── decisions.md
├── src/                # If code project
└── deliverables/       # Final outputs
```

## Templates

### Welcome Email
```markdown
Subject: Welcome to TechConcepts - [Project Name] Kickoff

Hi [Name],

Excited to start working on [project]. Here's what's next:

1. **Kickoff call:** [date/time]
2. **Shared folder:** [link]
3. **Communication:** [Slack/email preference]

Please share:
- [ ] Access to [system/repo]
- [ ] Existing documentation
- [ ] Key stakeholder contacts

Looking forward to working together!

Best,
[Your name]
```

### Project README Template
```markdown
# [Client] - [Project Name]

## Overview
[Brief description]

## Contacts
- **Client:** [name] - [email]
- **TechConcepts:** [name]

## Timeline
- Start: [date]
- Target completion: [date]

## Scope
[Deliverables list]

## Access
- Repo: [link]
- Staging: [link]
- Docs: [link]
```

## Notion/Database Entry
Track in client database:
- Client name
- Project type
- Start date
- Contract value
- Status
- Next action

---
Last updated: 2026-01-29
