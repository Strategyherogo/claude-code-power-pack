# Community Post: Claude Code Power Pack

**Title:** I built 151 skills for Claude Code — open source, free to use

**Body:**

I've been using Claude Code daily for 2 months across 24 projects. Along the way, I built a full workflow system: 151 reusable skills, lifecycle hooks, coding rules, and session automation.

I just open-sourced the whole thing.

**What it does:**

The Power Pack adds structured workflows to Claude Code via skill files (markdown in `.claude/commands/`). Instead of re-explaining "debug this systematically" or "follow TDD" every session, you type `/commands:systematic-debug` or `/commands:tdd` and Claude follows a battle-tested workflow.

**What's included:**

- **151 skills** — debugging, TDD, git flow, deployment verification, session save/restore, content creation, sales workflows, PM tools, security scanning, and more
- **3 lifecycle hooks** — auto-check on startup, credential verification before deploys, auto-save on session end
- **4 coding rule sets** — Python (PEP 8 + types), TypeScript (strict), Swift (concurrency + SwiftUI), common best practices
- **Trigger mappings** — type "debug" and Claude suggests the right skill automatically

**How Claude helped build it:**

Every skill was created *during* real work sessions. When I hit friction (repeated debugging steps, forgotten deploy checks, lost context between sessions), Claude and I would build a skill to fix it. The `/session-retro` skill analyzes each session and identifies new skill candidates from friction points — so the system grows itself.

The genericizer that strips personal data for distribution (`genericize.py`) was also built with Claude Code.

**Install:**

```bash
git clone https://github.com/Strategyherogo/claude-code-power-pack.git
cd your-project
bash /path/to/claude-code-power-pack/src/pro/install.sh
```

Skills are just markdown files — no dependencies, no build step, no runtime. Edit any skill to match your workflow.

**Security:** The package contains only markdown and shell scripts. No API calls, no data collection, no credentials required. Hook scripts only read local git state. Full source is available to review.

**Repo:** https://github.com/Strategyherogo/claude-code-power-pack

Contributions welcome — see [CONTRIBUTING.md](https://github.com/Strategyherogo/claude-code-power-pack/blob/main/CONTRIBUTING.md) for how to add your own skills.

Happy to answer questions about the system architecture or specific skills.
