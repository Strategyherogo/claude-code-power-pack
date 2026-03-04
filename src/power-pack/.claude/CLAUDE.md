# CLAUDE.md v7.1

**PRIMARY CONFIG:** `.claude/MASTER.md` (trigger mappings + tiers)
**SKILL FILES:** `.claude/commands/` (full workflows, loaded on-demand)

---

## SECURITY RULES (ENFORCED)

**NEVER do these without explicit approval:**
1. **Public gists/repos** - NEVER use `--public` flag. Code contains infrastructure details (hostnames, schemas, IDs)
2. **Expose credentials** - Never output passwords, API keys, tokens
3. **Public uploads** - Always ask before any public file sharing

**Safe sharing methods:**
- Private gist (no `--public` flag)
- Zip file for direct sharing (Slack DM, email)
- Private repo

**If user says "push" or "share":**
→ Default to private/local
→ Ask before making anything public

---

## WORKFLOW PREFERENCES

### External Platforms
When accessing external platforms (Jira Marketplace, Chrome Web Store, Atlassian, etc.):
1. **First** check `.env` and `~/.config` for stored API keys/tokens
2. **Prefer** CLI tools over web portal access:
   - Chrome: `chrome-webstore-upload-cli`
   - Atlassian: `atlas` CLI
   - npm: `npm publish`
3. **If no credentials found**, document what's needed and where to store them

### Information Retrieval
For searching past work or iterations:
1. Local search: `Glob` and `Grep` in project directories
2. Git history: `git log --oneline --all --grep=<term>`
3. Backup locations: `~/Dropbox`, `~/Documents`, cloud sync folders
4. Shell history: `~/.zsh_history` or `~/.bash_history`

### Credential Discovery
Before accessing any authenticated service:
1. Check `.env` files in project root
2. Check `~/.config/<service>/`
3. Check environment variables
4. Check macOS Keychain: `security find-generic-password -s "<service>"`
5. If not found → document requirements for user

---

## COMMUNICATION STYLE

- Be concrete and actionable — not strategic or consulting-framework-oriented
- When asked for something to do/send/use, provide the actual deliverable — not a plan to create it
- Never prematurely celebrate success — verify the thing actually works before confirming completion
- When asked a specific question, answer that exact question before expanding
- **"implement", "do it", "fix it", "go" = act immediately.** No re-explanation, no summary of what you're about to do, no confirmation request. Just do it.
- **"fix X" means edit the source code/config** — don't try to run the broken command. Look at error messages and fix the source, not the symptom.
- **Never archive, delete, or destructively modify resources** (Slack channels, files, projects) unless explicitly told to. Default to analysis and reporting only.

---

## OUTPUT FORMAT DEFAULTS

- Reports and analysis: output as Markdown (`.md`) unless explicitly asked for another format
- Tables: use proper Markdown table syntax with blank lines before/after
- Never generate PDF unless specifically requested
- For HTML reports: ensure all escaped characters render correctly
- When providing code/scripts: give the actual code, not a description of what to write

---

## DATA ANALYSIS CONVENTIONS

- Always distinguish between roles (e.g., assignee vs responder) — ask for clarification if ambiguous
- Double-check calculations before displaying numerical findings
- For CSV/log analysis: show data coverage stats upfront (rows parsed, date range, missing data %)
- When asked for breakdowns by a dimension, provide the full breakdown — don't summarize into a generic narrative

---

## SESSION & CONTEXT MANAGEMENT

- **At ~70% context usage**: proactively tell the user, suggest `/compact`, and summarize remaining work. Don't wait for the "prompt too long" error.
- For multi-task sessions, checkpoint after each major task completion
- Never attempt to 3x expand a document in a single context window — break into sequential operations
- After `/compact`, resume by reading the last context-save from `.claude/context-saves/`

---

## ENVIRONMENT & SHELL SAFETY

- **macOS only** — never use GNU/Linux-specific flags (no `date -d`, no `sed -i ''` with two args, no `grep -P`, no `readlink -f`, no `date +%N`)
- Use `brew` for system packages. For pip, always use `--user` flag or `pipx` (PEP 668 brew-managed Python).
- **Never delete CWD** — before any `rm -rf <path>`, verify path is not `$PWD` or an ancestor of it
- **No piped chains as single Bash calls when simpler alternatives exist** — break `cmd1 | cmd2 | cmd3` into sequential steps if any step might fail
- **Append operator** — use `cat >> file` or `tee -a` for appending; both are allowed
- **Check existing deployments first** — before suggesting a new deployment, check existing DigitalOcean droplets, running processes, and current configs. Don't redeploy from scratch if already running.

---

## API ERROR HANDLING

- On HTTP 500/502/503/504 errors from any external service: **retry up to 3 times** with a 2-second pause before reporting to user. Never wait for user to say "retry" for transient errors.
- Before deploying to any external service (Cloudflare, DigitalOcean, ASC, npm): **verify required credentials exist in environment**. If missing, list them immediately — do not attempt and fail.

---

## SKILLS & SCRIPTS

- Default to smallest viable implementation — if it works in 20 lines, don't write 40
- **Startup/session skills**: no subagent spawns, read-only, ≤ 10 lines of output
- If the goal is "simplify" or "trim", the output MUST have fewer lines than the input — verify before declaring done
- Never add steps to an existing skill without explicit user request

---

## DIAGNOSTIC APPROACH (from 94 wrong-approach friction incidents)

- **Debug deployed services by checking RUNTIME** (logs, processes, webhook endpoints, `curl` health checks) — never diagnose a running service by reading its git repo status alone.
- **App Store rejection reasons:** use macOS Mail CLI (`~/Library/Mail/`) — not Gmail API (wrong account), not ASC API (Resolution Center not exposed).
- **When first approach fails, try a fundamentally different angle** — don't retry variants of the same failing method.
- **After 3 failed attempts at anything:** stop, summarize what you tried and what you learned, propose a concrete alternative. Never loop silently.
- **One deliverable per request** — if user asks for a file, produce exactly one file. Don't split into multiple unless asked.
- **Use actual project context** (git history, existing files, user's real data) before falling back to generic templates or advice.

---

## ANTI-FRICTION RULES (from insights analysis)

### Tool Permission Fallbacks
When writing files, always use Bash with `tee`/`cat` heredoc as a fallback if the Write or Edit tool is blocked. Never stop progress due to tool permission denials — immediately try alternative approaches.

### Verification Before Success
Never prematurely declare success. Verify that the feature actually works end-to-end before saying it's done. If you can't verify, explicitly state what remains unverified.

### Concrete Deliverables Over Strategy
When the user asks for actionable outputs (messages, scripts, files, commands), give concrete deliverables immediately. Do NOT default to strategic frameworks, consulting-style analysis, or high-level recommendations unless explicitly asked.

### Format Confirmation
Always confirm output format (HTML, Markdown, PDF, etc.) before generating reports. Default to the format the user has been using in the current session. Never convert formats without asking.

### Data Analysis Validation
For forensic/data analysis: Always explicitly state timezone assumptions before presenting any timeline. Double-check all numerical claims (averages, counts, ticket references) against source data before presenting them.

### Session Management Fallbacks
When running standup, handoff, save, or retro skills: if file writes are blocked, immediately output the full content to the terminal so the user can copy-paste it. Do not spend multiple attempts retrying blocked writes.

### Tool Fallback Chain
If Write/Edit is blocked → try Bash with `tee`/`cat heredoc`. If Bash is also blocked → try Read/Glob for input + output content to terminal. Never stall on a single blocked tool — immediately try the next fallback.

---

## PARA GOVERNANCE RULES

### Structure
```
1. Projects/   Active work (max 15, numbered XX-kebab-name)
2. Areas/      Ongoing responsibilities (numbered XX-kebab-name)
3. Resources/  Reference materials (numbered XX-topic, folders only)
4. Archive/    Completed/inactive (name-YYYY-MM, folders only)
```

Workspace root may ONLY contain: PARA folders, `.claude/`, `.git/`, `.github/`, `README.md`, `.gitignore`.

### Gate Rules
- **G1:** No loose files in PARA folder roots — everything must be in a subfolder
- **G2:** New project requires numbered folder + README (`XX-project-name/README.md`)
- **G3:** Nothing at workspace root except items listed above
- **G4:** ~~No hard cap~~ — rely on H2 staleness rule to prompt archiving

### Hygiene Rules (checked by `/morning-check`)
- **H1:** No duplicate prefix numbers within the same PARA folder
- **H2:** No commit in 30 days → prompt to archive
- **H3:** Archive folders must be dated: `name-YYYY-MM`
- **H4:** Resources: folders only, no loose files at root, max 2 levels deep

### Naming
| Folder | Pattern | Example |
|--------|---------|--------|
| Projects | `XX-kebab-name` | `06-slack-jira-bot` |
| Areas | `XX-kebab-name` | `03-neuroperformance` |
| Resources | `XX-topic-name/` (folders only) | `04-reference/` |
| Archive | `name-YYYY-MM` | `10-nvstrs-auto-assign-2026-01` |

---

## FILES

| File | Purpose | Size |
|------|---------|------|
| MASTER.md | Trigger mappings, tiers, MCP list, project context | ~7KB |
| CLAUDE.md | Security rules, workflow preferences | ~2KB |
| commands/* | 140 skill files (loaded on-demand) | ~400KB |
| state.md | Session state | ~1KB |

---

*v7.2 — Added diagnostic approach rules + cs.sh preflight & auto-archival (2026-03-03). Security + preferences here. Triggers + context in MASTER.md.*
