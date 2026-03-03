# Skill: orchestrate
Analyze task and run relevant skills automatically.

## Auto-Trigger
**When:** "orchestrate", "run workflow", "automate", "do everything", "full workflow"

## How It Works

### Step 1: Analyze Context
Claude analyzes the user's request and identifies:
- Task type (dev, content, business, ops)
- Required skills
- Execution order
- Dependencies between skills

### Step 2: Build Skill Chain
```
User: "I'm done with the feature, need to deploy"

Analysis:
1. /verify        - Pre-completion check
2. /commit-msg    - Generate commit message
3. /release-notes - Generate release notes
4. /deploy-verify - Pre-deployment gate
5. /quick-deploy  - Deploy (if approved)
```

### Step 3: Execute with Confirmations
Run each skill, confirm between critical steps.

---

## All Workflow Templates

### 1. DEPLOY
```
/orchestrate deploy

┌──────────────────────────────────────────┐
│ DEPLOY WORKFLOW                          │
├──────────────────────────────────────────┤
│ 1. /dependency-audit   Check packages    │
│ 2. /secret-scan        Security scan     │
│ 3. /perf-test          Performance check │
│ 4. /deploy-verify      Pre-deploy gate   │
│ 5. /release-notes      Document changes  │
│ 6. /quick-deploy       Deploy            │
└──────────────────────────────────────────┘
```

### 2. NEW-CLIENT
```
/orchestrate new-client

┌──────────────────────────────────────────┐
│ NEW CLIENT WORKFLOW                      │
├──────────────────────────────────────────┤
│ 1. /client-onboard     Checklist         │
│ 2. /scaffold           Project structure │
│ 3. /decision-log       Initial decisions │
│ 4. /write-plan         Project plan      │
│ 5. /proposal           SOW if needed     │
└──────────────────────────────────────────┘
```

### 3. SPRINT-END
```
/orchestrate sprint-end

┌──────────────────────────────────────────┐
│ SPRINT END WORKFLOW                      │
├──────────────────────────────────────────┤
│ 1. /retro              Retrospective     │
│ 2. /release-notes      What shipped      │
│ 3. /standup            Final summary     │
│ 4. /time-track         Log hours         │
│ 5. /invoice            Bill if needed    │
└──────────────────────────────────────────┘
```

### 4. FEATURE-DONE
```
/orchestrate feature-done

┌──────────────────────────────────────────┐
│ FEATURE COMPLETE WORKFLOW                │
├──────────────────────────────────────────┤
│ 1. /verify             Tests pass        │
│ 2. /commit-msg         Generate commit   │
│ 3. /changelog          Update changelog  │
│ 4. /release-notes      Document feature  │
└──────────────────────────────────────────┘
```

### 5. BUG-FIX
```
/orchestrate bug-fix

┌──────────────────────────────────────────┐
│ BUG FIX WORKFLOW                         │
├──────────────────────────────────────────┤
│ 1. /systematic-debug   Find root cause   │
│ 2. /root-trace         Trace issue       │
│ 3. /tdd                Write test first  │
│ 4. /verify             Confirm fix       │
│ 5. /commit-msg         Commit fix        │
└──────────────────────────────────────────┘
```

### 6. NEW-PROJECT
```
/orchestrate new-project

┌──────────────────────────────────────────┐
│ NEW PROJECT WORKFLOW                     │
├──────────────────────────────────────────┤
│ 1. /scaffold           Create structure  │
│ 2. /docker             Add Dockerfile    │
│ 3. /decision-log       Document choices  │
│ 4. /git-flow           Setup branches    │
│ 5. /c2c:readme         Write README      │
└──────────────────────────────────────────┘
```

### 7. CODE-REVIEW
```
/orchestrate code-review

┌──────────────────────────────────────────┐
│ CODE REVIEW WORKFLOW                     │
├──────────────────────────────────────────┤
│ 1. /agent:code-review  Automated review  │
│ 2. /secret-scan        Check for secrets │
│ 3. /dependency-audit   Check deps        │
│ 4. /tdd                Test coverage     │
└──────────────────────────────────────────┘
```

### 8. RELEASE
```
/orchestrate release

┌──────────────────────────────────────────┐
│ RELEASE WORKFLOW                         │
├──────────────────────────────────────────┤
│ 1. /changelog          Update changelog  │
│ 2. /release-notes      Generate notes    │
│ 3. /dependency-audit   Final audit       │
│ 4. /git-flow           Create release    │
│ 5. /deploy-verify      Pre-deploy check  │
└──────────────────────────────────────────┘
```

### 9. MORNING
```
/orchestrate morning

┌──────────────────────────────────────────┐
│ MORNING WORKFLOW                         │
├──────────────────────────────────────────┤
│ 1. /cs (quick status)  Workspace status  │
│ 2. /neuro:daily-check  Energy check      │
│ 3. /standup            Plan the day      │
│ 4. /focus              Set focus block   │
└──────────────────────────────────────────┘
```

### 10. EVENING
```
/orchestrate evening

┌──────────────────────────────────────────┐
│ EVENING WORKFLOW                         │
├──────────────────────────────────────────┤
│ 1. /standup            What got done     │
│ 2. /time-track         Log hours         │
│ 3. /cs                 Save context      │
│ 4. /reflect            Day learnings     │
└──────────────────────────────────────────┘
```

### 11. WEEKLY
```
/orchestrate weekly

┌──────────────────────────────────────────┐
│ WEEKLY REVIEW WORKFLOW                   │
├──────────────────────────────────────────┤
│ 1. /weekly-ops-review  Ops status        │
│ 2. /time-track         Hours summary     │
│ 3. /neuro:weekly-report Health trends    │
│ 4. /reflect            Week learnings    │
│ 5. /workspace-audit    Cleanup           │
└──────────────────────────────────────────┘
```

### 12. MONTHLY
```
/orchestrate monthly

┌──────────────────────────────────────────┐
│ MONTHLY REVIEW WORKFLOW                  │
├──────────────────────────────────────────┤
│ 1. /time-track         Month hours       │
│ 2. /invoice            All clients       │
│ 3. /dependency-audit   All projects      │
│ 4. /workspace-audit    Full cleanup      │
│ 5. /system-health      Full system check │
└──────────────────────────────────────────┘
```

### 13. SECURITY
```
/orchestrate security

┌──────────────────────────────────────────┐
│ SECURITY AUDIT WORKFLOW                  │
├──────────────────────────────────────────┤
│ 1. /secret-scan        Find leaked creds │
│ 2. /dependency-audit   Vulnerable deps   │
│ 3. /system-health      System integrity  │
│ 4. /compliance-pack    Compliance check  │
└──────────────────────────────────────────┘
```

### 14. CONTENT
```
/orchestrate content

┌──────────────────────────────────────────┐
│ CONTENT CREATION WORKFLOW                │
├──────────────────────────────────────────┤
│ 1. /content-brief      Define topic      │
│ 2. /brainstorm         Generate ideas    │
│ 3. /c2c:blog           Write draft       │
│ 4. /seo-audit          Optimize for SEO  │
└──────────────────────────────────────────┘
```

### 15. CLIENT-MEETING
```
/orchestrate client-meeting

┌──────────────────────────────────────────┐
│ CLIENT MEETING PREP WORKFLOW             │
├──────────────────────────────────────────┤
│ 1. /1on1               Prep questions    │
│ 2. /standup            Status update     │
│ 3. /time-track         Hours review      │
│ 4. /invoice            If billing        │
└──────────────────────────────────────────┘
```

### 16. INVOICE-CYCLE
```
/orchestrate invoice-cycle

┌──────────────────────────────────────────┐
│ INVOICE CYCLE WORKFLOW                   │
├──────────────────────────────────────────┤
│ 1. /time-track         Gather hours      │
│ 2. /invoice            Generate invoice  │
│ 3. /mail               Send to client    │
└──────────────────────────────────────────┘
```

### 17. PODCAST
```
/orchestrate podcast

┌──────────────────────────────────────────┐
│ PODCAST WORKFLOW                         │
├──────────────────────────────────────────┤
│ 1. /podcast-prep       Episode outline   │
│ 2. /brainstorm         Topic ideas       │
│ 3. /content-brief      Show notes draft  │
└──────────────────────────────────────────┘
```

### 18. API-BUILD
```
/orchestrate api-build

┌──────────────────────────────────────────┐
│ API BUILD WORKFLOW                       │
├──────────────────────────────────────────┤
│ 1. /scaffold           Project structure │
│ 2. /docker             Containerize      │
│ 3. /api-docs           Document API      │
│ 4. /tdd                Write tests       │
│ 5. /perf-test          Load test         │
└──────────────────────────────────────────┘
```

### 19. MCP-BUILD
```
/orchestrate mcp-build

┌──────────────────────────────────────────┐
│ MCP SERVER WORKFLOW                      │
├──────────────────────────────────────────┤
│ 1. /mcp:build          Scaffold server   │
│ 2. /tdd                Write tests       │
│ 3. /c2c:readme         Document          │
│ 4. /release-notes      Prepare release   │
└──────────────────────────────────────────┘
```

### 20. SWIFT-APP
```
/orchestrate swift-app

┌──────────────────────────────────────────┐
│ SWIFT APP WORKFLOW                       │
├──────────────────────────────────────────┤
│ 1. /scaffold           Project structure │
│ 2. /swift:localize     Add localization  │
│ 3. /swift:debug-memory Memory check      │
│ 4. /swift:app-store-prep App Store prep  │
└──────────────────────────────────────────┘
```

---

## Skill Categories for Auto-Selection

### By Task Type

| Task Type | Relevant Skills |
|-----------|-----------------|
| **Coding** | scaffold, tdd, debug, commit-msg, verify |
| **Deploying** | dependency-audit, secret-scan, deploy-verify, release-notes |
| **Writing** | content-brief, c2c:blog, seo-audit |
| **Client Work** | client-onboard, proposal, time-track, invoice |
| **Planning** | write-plan, decision-log, brainstorm |
| **Meetings** | 1on1, retro, standup |

### By Keyword Detection

```python
SKILL_KEYWORDS = {
    # Development
    "bug|error|broken|debug": ["systematic-debug", "root-trace"],
    "deploy|release|ship": ["deploy-verify", "release-notes"],
    "test|tdd": ["tdd", "edge-test"],
    "commit|push": ["commit-msg", "verify"],

    # Business
    "client|customer": ["client-onboard", "proposal"],
    "invoice|bill|payment": ["invoice", "time-track"],
    "meeting|1on1|standup": ["1on1", "standup"],

    # Content
    "blog|article|post": ["content-brief", "c2c:blog", "seo-audit"],
    "video|youtube": ["c2c:video-script"],

    # Ops
    "health|status": ["do-health", "system-health"],
    "security|audit": ["secret-scan", "dependency-audit"],
}
```

---

## Usage

### Quick Commands
```
/orchestrate deploy           → Deploy workflow
/orchestrate new-client       → Client onboarding
/orchestrate sprint-end       → Sprint close
/orchestrate feature-done     → Complete feature
/orchestrate bug-fix          → Debug & fix
/orchestrate new-project      → Start project
/orchestrate code-review      → Review code
/orchestrate release          → Prepare release
/orchestrate morning          → Start day
/orchestrate evening          → End day
/orchestrate weekly           → Weekly review
/orchestrate monthly          → Monthly review
/orchestrate security         → Security audit
/orchestrate content          → Create content
/orchestrate client-meeting   → Prep for client
/orchestrate invoice-cycle    → Billing workflow
```

### Implicit (Auto-Detect)
```
User: "I finished the auth feature and need to deploy to production"

Claude detects:
- "finished" → /verify
- "feature" → /commit-msg, /changelog
- "deploy" → /deploy-verify
- "production" → /secret-scan, /release-notes

Proposes chain, user confirms.
```

---

## Execution Flow

```
┌─────────────────┐
│ Analyze Request │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Identify Skills │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Build Chain     │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Show Plan       │◄── User confirms
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Execute Skills  │
│ (with checks)   │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Summary Report  │
└─────────────────┘
```

---

## Example Session

```
User: /orchestrate deploy

Claude:
┌─────────────────────────────────────┐
│ ORCHESTRATE: Deploy Workflow        │
├─────────────────────────────────────┤
│ 1. /dependency-audit - Check deps   │
│ 2. /secret-scan - Security scan     │
│ 3. /deploy-verify - Pre-deploy gate │
│ 4. /release-notes - Document        │
│ 5. /quick-deploy - Deploy           │
└─────────────────────────────────────┘

Run this workflow? (y/n/edit)

User: y

[Runs each skill in sequence, showing progress]

✓ Workflow complete. 5 skills executed.
```

---
Last updated: 2026-01-29
