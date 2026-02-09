# Recommended MCP Servers for Your Workflow

Based on your projects and workflow, here are MCP servers to add.

## Currently Enabled (from settings.local.json)
✅ atlassian, playwright, slack, postgres, fetch, sequential-thinking, gdrive, notion, aws, gmail, zapier

---

## HIGH PRIORITY: Add These Now

### 1. GitHub MCP (Official)
**Why:** You have 20+ projects that likely use Git
```json
{
  "github": {
    "command": "npx",
    "args": ["-y", "@github/github-mcp-server"],
    "env": {
      "GITHUB_PERSONAL_ACCESS_TOKEN": "ghp_..."
    }
  }
}
```
**Capabilities:** Repository management, PR automation, issue tracking, CI/CD intelligence

### 2. Stripe MCP (Official)
**Why:** TechConcepts monetization, payment integrations
```json
{
  "stripe": {
    "command": "npx",
    "args": ["-y", "@stripe/mcp", "--tools=all"],
    "env": {
      "STRIPE_SECRET_KEY": "sk_test_..."
    }
  }
}
```
**Capabilities:** Customer management, subscriptions, invoicing, payment processing

### 3. Supabase MCP
**Why:** Backend for your apps, replaces complex AWS setup
```json
{
  "supabase": {
    "command": "npx",
    "args": ["-y", "@supabase/mcp-server-supabase@latest", "--project-ref=your-ref"],
    "env": {
      "SUPABASE_SERVICE_ROLE_KEY": "..."
    }
  }
}
```
**Capabilities:** Real-time DB, auth, edge functions, storage

### 4. Cloudflare Workers MCP
**Why:** Deploy serverless functions for your bots and tools
```json
{
  "cloudflare": {
    "command": "npx",
    "args": ["-y", "@cloudflare/mcp-server-cloudflare"],
    "env": {
      "CLOUDFLARE_API_TOKEN": "...",
      "CLOUDFLARE_ACCOUNT_ID": "..."
    }
  }
}
```
**Capabilities:** Workers deployment, D1 databases, R2 storage, KV stores

---

## MEDIUM PRIORITY: Project-Specific

### 5. Linear MCP (Alternative to Jira)
**Why:** Better for solo/small team project tracking
```json
{
  "linear": {
    "command": "npx",
    "args": ["-y", "@linear/mcp-server"],
    "env": {
      "LINEAR_API_KEY": "..."
    }
  }
}
```

### 6. Resend MCP (Email API)
**Why:** Transactional emails for your apps
```json
{
  "resend": {
    "command": "npx",
    "args": ["-y", "@resend/mcp-server"],
    "env": {
      "RESEND_API_KEY": "..."
    }
  }
}
```

### 7. Browser/Puppeteer MCP
**Why:** Web automation, testing Chrome extensions
```json
{
  "puppeteer": {
    "command": "npx",
    "args": ["-y", "@modelcontextprotocol/server-puppeteer"]
  }
}
```

---

## SPECIALIZED: For Specific Workflows

### 8. SQLite MCP (Local Databases)
**Why:** Your neuroperformance data is in SQLite
```json
{
  "sqlite": {
    "command": "uvx",
    "args": ["mcp-server-sqlite", "--db-path", "~/Data_Analytics/00_ACTIVE_PROJECTS/Personal_Health_Analysis/unified_personal_data_2025.db"]
  }
}
```

### 9. Filesystem MCP (Enhanced)
**Why:** Direct file operations in Apps Factory
```json
{
  "filesystem": {
    "command": "npx",
    "args": ["-y", "@modelcontextprotocol/server-filesystem", "/Users/jenyago/Desktop/Apps Factory/"]
  }
}
```

### 10. CLI MCP (Safe Command Execution)
**Why:** Run development commands securely
```json
{
  "cli": {
    "command": "npx",
    "args": ["-y", "@mladensu/cli-mcp-server"],
    "env": {
      "ALLOWED_COMMANDS": "git,npm,python,make,docker,xcodebuild,swift"
    }
  }
}
```

---

## Installation Priority Order

1. **Week 1:** GitHub + Stripe (core development + monetization)
2. **Week 2:** Cloudflare + Supabase (deployment infrastructure)
3. **Week 3:** SQLite + Filesystem (local data access)
4. **Week 4:** CLI + Browser (automation)

---

## How to Add MCPs

1. Open `~/.claude/mcp.json` (or create it)
2. Add the server configuration
3. Restart Claude Code
4. Verify with: `/mcp` command

---
Last updated: 2026-01-27
