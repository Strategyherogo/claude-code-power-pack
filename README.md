# Claude Code Power Pack

**151 skills, 3 lifecycle hooks, 4 coding rule sets, and session automation for Claude Code.**

Built entirely with Claude Code over 10+ sessions of real production work across 24 projects. Every skill has been battle-tested — not theoretical templates.

## What's Inside

### 151 Skills (`.claude/commands/`)

Skills are structured prompts that Claude Code executes as workflows. Type `/commands:skill-name` to run any of them.

| Category | Count | Examples |
|----------|-------|---------|
| **Development** | 25 | `systematic-debug`, `tdd`, `build-test`, `edge-test`, `root-trace`, `scaffold` |
| **Git & Deploy** | 15 | `git-flow`, `deploy-verify`, `quick-deploy`, `changelog`, `release-notes`, `commit-msg` |
| **Session Mgmt** | 12 | `cs` (session start), `save`, `restore`, `handoff`, `wrap`, `focus`, `session-retro` |
| **Content** | 14 | `blog`, `quick-blog`, `newsletter`, `linkedin-post`, `carousel`, `tutorial`, `readme` |
| **Sales** | 8 | `call-prep`, `forecast`, `pipeline-review`, `competitive-intel`, `draft-outreach` |
| **PM** | 6 | `feature-prioritize`, `roadmap-build`, `brainstorm`, `write-plan`, `decision-log` |
| **Security** | 5 | `secret-scan`, `compliance-pack`, `cred-discover`, `forensic-audit` |
| **Agents** | 4 | `code-review`, `deploy-pipeline`, `project-analyzer`, `parallel-agents` |
| **Domain** | 20+ | Swift, Docker, MCP servers, Jira, App Store, email forensics, Chrome extensions |
| **Ops** | 15+ | `morning-check`, `infra-health`, `log-errors`, `env-sync`, `dependency-audit` |

### 3 Lifecycle Hooks

Shell scripts that fire automatically on Claude Code events:

| Hook | Event | What It Does |
|------|-------|-------------|
| `startup-parallel.sh` | Session start | Checks git status, GitHub auth, uncommitted files. Warns only if issues found. |
| `pre-deploy-check.sh` | Before Bash commands | Catches deploy/publish/push commands and verifies credentials before execution. Covers npm, Cloudflare, App Store, Chrome Web Store, DigitalOcean, Atlassian. |
| `session-end-save.sh` | Session end | Auto-saves context (branch, commits, modified files) so next session can pick up seamlessly. |

### 4 Coding Rule Sets (`.claude/rules/`)

Rules that Claude Code follows automatically when writing code:

- **`common.md`** — Git workflow, code quality, testing, security, performance
- **`python.md`** — PEP 8, type hints, pytest, async patterns
- **`typescript.md`** — Strict mode, no `any`, discriminated unions, error handling
- **`swift.md`** — Concurrency (`@MainActor`, actors), SwiftUI, localization patterns

### Config Templates

- **`CLAUDE.md`** — Project-level instructions: security rules, workflow preferences, anti-friction patterns
- **`MASTER.md`** — Trigger mappings that auto-suggest skills based on keywords (e.g., "debug" suggests `/systematic-debug`)

## Quick Start

```bash
# Clone the repo
git clone https://github.com/Strategyherogo/claude-code-power-pack.git

# Install into your project
cd your-project
bash /path/to/claude-code-power-pack/src/pro/install.sh
```

The installer:
- Copies skills to `.claude/commands/` (skips any you already have)
- Copies rules to `.claude/rules/`
- Copies config templates (only if you don't have existing ones)
- Creates a context-saves directory for session handoffs

### Try It

```
# Start a Claude Code session, then:
/commands:cs                    # Session briefing
/commands:systematic-debug      # Debug a problem
/commands:tdd                   # Test-driven development
/commands:git-flow              # Git branch workflow
/commands:SKILL-INDEX           # See all 151 skills
```

## Hook Setup

Hooks require manual wiring in `~/.claude/settings.json`. Add to the `hooks` object:

```json
{
  "hooks": {
    "UserPromptSubmit": [
      {
        "type": "command",
        "command": "bash ~/.claude/hooks/startup-parallel.sh"
      }
    ],
    "PreToolUse": [
      {
        "matcher": "Bash",
        "type": "command",
        "command": "bash ~/.claude/hooks/pre-deploy-check.sh"
      }
    ],
    "Stop": [
      {
        "type": "command",
        "command": "bash ~/.claude/hooks/session-end-save.sh"
      }
    ]
  }
}
```

## How It Works

```
You type a keyword ──> MASTER.md trigger mapping ──> Suggests the right skill
                                                          │
                                                          v
                                               Claude executes the workflow
                                               (debug steps, deploy checks,
                                                session save, etc.)
```

Skills are just markdown files — Claude reads them as structured instructions. No compilation, no dependencies, no runtime. Edit any skill to match your workflow.

## Customization

**Add your own skills:**
```bash
# Create a new skill
echo "# Skill: my-workflow\nDo the thing.\n\n## Steps\n1. Step one\n2. Step two" \
  > .claude/commands/my-workflow.md

# Use it
/commands:my-workflow
```

**Modify trigger mappings** in `MASTER.md`:
```markdown
- my keyword | another keyword → `/my-workflow`
```

**Add coding rules** — drop a `.md` file in `.claude/rules/` and Claude follows it automatically.

## Structure

```
.claude/
├── CLAUDE.md              # Project config (security, preferences)
├── MASTER.md              # Trigger keyword → skill mappings
├── commands/              # 151 skill files
│   ├── cs.md              # Session start
│   ├── systematic-debug.md
│   ├── tdd.md
│   ├── git-flow.md
│   ├── deploy-verify.md
│   └── ...
├── rules/                 # Coding standards
│   ├── common.md
│   ├── python.md
│   ├── typescript.md
│   └── swift.md
└── hooks/                 # Lifecycle automation
    ├── startup-parallel.sh
    ├── pre-deploy-check.sh
    └── session-end-save.sh
```

## Built With Claude Code

This entire system was built iteratively with Claude Code:
- Skills were created as real workflows were needed (not pre-planned)
- Hooks were added after identifying friction points across sessions
- The genericizer that strips personal data for distribution was itself built with Claude Code
- The session retro skill (`/session-retro`) identifies new skill candidates from each session's friction points

## Security Note

This package contains only markdown instruction files and shell scripts. It does not:
- Access any external APIs or services
- Collect or transmit any data
- Require any credentials or authentication
- Modify any system configuration

The hook scripts read only local git state and environment variables. Review them before enabling.

## License

MIT

---

*Questions? Open an issue or reach out on the [Anthropic Community](https://community.anthropic.com).*
