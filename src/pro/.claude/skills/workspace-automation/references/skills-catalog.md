# Complete Skills Catalog (612 Skills)

Source: `/3. Resources/CONSOLIDATED-RESOURCES.txt` (18MB, 1012 files)

## Quick Navigation

| Category | Count | Examples |
|----------|-------|----------|
| **Testing** | 45+ | tdd, test-loop, test-coverage, smoke-test |
| **Debug** | 20+ | smart-debug, systematic-debug, bug-detective |
| **Deploy** | 25+ | deploy, docker-deploy, cloudflare-deploy |
| **API** | 30+ | api-scaffold, api-mock, api-security-audit |
| **AI/ML** | 15+ | ai-agent-create, ai-review, ai-monitoring-setup |
| **Sync** | 12+ | sync-issues-to-linear, sync-pr-to-task |
| **Svelte** | 15+ | svelte:component, svelte:test, svelte:optimize |
| **Rust** | 10+ | rust:audit-clean-arch, rust:suggest-refactor |
| **Content** | 20+ | blog-post, newsletter, changelog |
| **DevOps** | 35+ | terraform, ansible, ci-cd, docker |

## By Trigger Keywords

### "debug" / "error" / "fix"
- `smart-debug` - Specialized debugging approach
- `systematic-debug` - Methodical bug hunting
- `bug-detective` - Root cause analysis
- `bug-fix` - Automated fix attempts
- `test-loop` - Auto-retry with debugging

### "test" / "tdd" / "coverage"
- `tdd` - Full TDD workflow
- `tdd-red` - Write failing tests
- `tdd-green` - Implement to pass
- `tdd-refactor` - Clean up with confidence
- `test-suite` - Unified test runner
- `test-coverage` - Coverage analysis
- `test-harness` - Comprehensive test setup
- `smoke-test` - Quick validation

### "deploy" / "release" / "ship"
- `deploy` - General deployment
- `docker-deploy` - Container deployment
- `cloudflare-deploy` - CF Workers/Pages
- `release-notes` - Generate release notes
- `changelog` - Automated changelog

### "api" / "endpoint" / "rest"
- `api-scaffold` - Generate API structure
- `api-mock` - Mock server setup
- `api-security-audit` - Security review
- `graphql-server` - GraphQL setup
- `websocket-server` - WebSocket setup

### "blog" / "content" / "post"
- `blog-post` - Write blog content
- `newsletter` - Email newsletter
- `linkedin-post` - LinkedIn content
- `changelog-demo-command` - Demo changelogs

### "jira" / "linear" / "ticket"
- `sync-issues-to-linear` - GitHub → Linear
- `sync-linear-to-issues` - Linear → GitHub
- `sync-pr-to-task` - PR → Task link
- `task-from-pr` - Create tasks from PRs
- `sprint-planning` - Sprint organization

### "review" / "audit" / "analyze"
- `architecture-review` - System architecture
- `code-review` - Code quality
- `ai-review` - AI/ML code review
- `security-audit` - Security analysis
- `tech-debt` - Technical debt analysis
- `analyze-codebase` - Full codebase scan

### "setup" / "init" / "scaffold"
- `auth-setup` - Authentication system
- `ai-agents-setup` - Multi-agent init
- `spec-workflow-setup` - Spec workflow
- `svelte:scaffold` - SvelteKit project
- `storybook-setup` - Storybook init

## Full Alphabetical Index

### A
- a11y-scan, accessibility-audit, adapt-transfer
- add-authentication-system, add-changelog, add-mutation-testing
- add-package, add-performance-monitoring, add-property-based-testing
- add-rate-limiting, add-to-todos, aggregate-metrics
- aggregate-news, ai-agent-create, ai-agents-setup
- ai-agents-test, ai-assistant, ai-monitoring-setup
- ai-review, alert-test, all-tools
- analytics, analyze, analyze-capacity
- analyze-chain, analyze-codebase, analyze-coverage
- analyze-flow, analyze-headers, analyze-issue
- analyze-latency, analyze-logs, analyze-nft
- analyze-pool, analyze-sentiment, analyze-throughput
- analyze-trends, ansible-playbook, api-mock
- api-scaffold, api-security-audit, architecture-review
- architecture-scenario-explorer, archival, archive
- audit, audit-clean-arch, audit-dependencies
- audit-layer-boundaries, audit-log, audit-ports-adapters
- audit-report, audit-skill, audit-slash-command
- audit-subagent, auth-setup

### B
- backtest-strategy, backup, bidirectional-sync
- boundary-bbcr-fallback, boundary-detect, boundary-heatmap
- boundary-risk-assess, boundary-safe-bridge, brainstorm
- branch-create, browser-test, bug-detective
- bug-fix, build-api-gateway, build-auth-system
- build-graphql-server, build-skill, build-test
- build-websocket-server, bulk-import-issues, business-scenario-explorer

### C
- caching, calculate-tax, call-ipc
- changelog, changelog-demo-command, check-again
- check-deps, check-todos, ci-cd-build
- (... continues through alphabet)

### D-Z
See CONSOLIDATED-RESOURCES.txt Section 14 for complete listing.

## Recommended Auto-Triggers

```yaml
# Add to workspace-automation triggers.md
keywords_to_skills:
  # Testing
  "test": [tdd, test-suite, test-coverage]
  "failing test": [test-loop, tdd-green]
  "coverage": [test-coverage, analyze-coverage]

  # Debugging
  "bug": [bug-detective, bug-fix]
  "error": [smart-debug, systematic-debug]
  "debug": [smart-debug, systematic-debug]

  # Deployment
  "deploy": [deploy, cloudflare-deploy]
  "release": [release-notes, changelog]
  "ship": [deploy, release-notes]

  # Content
  "blog": [blog-post]
  "linkedin": [linkedin-post]
  "newsletter": [newsletter]

  # Project Management
  "jira": [sync-issues-to-linear]
  "linear": [sync-issues-to-linear, sync-linear-to-issues]
  "sprint": [sprint-planning]

  # Code Quality
  "review": [code-review, architecture-review]
  "refactor": [suggest-refactor, tdd-refactor]
  "audit": [audit, security-audit]
```

## Integration with Active MCPs

| MCP Server | Relevant Skills |
|------------|-----------------|
| **atlassian** | sync-issues-to-linear, sprint-planning |
| **playwright** | browser-test, e2e-test |
| **slack** | notification skills |
| **postgres** | sql-query-builder, stored-proc |
| **cloudflare** | cloudflare-deploy, workers skills |
| **github** | sync-pr-to-task, changelog |

## Usage

To find skills for a task:
1. Search this file for keywords
2. Check CONSOLIDATED-RESOURCES.txt for full skill content
3. Reference: `grep -A 50 "skills/{skill-name}.md" CONSOLIDATED-RESOURCES.txt`
