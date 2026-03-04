# MCP Server Configuration Reference

## Currently Active MCPs

| Server | Purpose | Key Tools |
|--------|---------|-----------|
| atlassian | Jira/Confluence | Create/update issues, search, comments |
| playwright | Browser automation | Navigate, click, fill, screenshot |
| slack | Messaging | Send messages, read channels, search |
| postgres | Database | Query, schema exploration |
| fetch | HTTP requests | GET/POST to APIs |
| sequential-thinking | Reasoning | Multi-step analysis |
| gdrive | Google Drive | List, read, create files |
| notion | Notion | Pages, databases, search |
| aws | AWS services | S3, Lambda, etc. |
| gmail | Email | Search, send, drafts |
| zapier | Automation | Trigger workflows |

## Recommended Additional MCPs

Based on user's D&S project and YourCompany goals:

### Stripe (Payment Processing)
```json
{
  "stripe": {
    "command": "npx",
    "args": ["-y", "@stripe/mcp", "--tools=all"],
    "env": { "STRIPE_SECRET_KEY": "sk_..." }
  }
}
```
Use for: Customer management, subscriptions, invoicing, refunds

### Cloudflare (Workers/D1/R2)
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
Use for: Deploy workers, D1 queries, R2 storage, KV

### GitHub (Repo Management)
```json
{
  "github": {
    "command": "npx",
    "args": ["-y", "@github/github-mcp-server"],
    "env": { "GITHUB_PERSONAL_ACCESS_TOKEN": "ghp_..." }
  }
}
```
Use for: Issues, PRs, CI/CD, code search

### SQLite (Local Databases)
```json
{
  "sqlite": {
    "command": "uvx",
    "args": ["mcp-server-sqlite", "--db-path", "/path/to/db.db"]
  }
}
```
Use for: Neuroperformance DB queries, local data

## MCP Usage Patterns

### Query Pattern
1. Check which MCP has the capability
2. Use appropriate tool (e.g., `postgres_query`, `d1_database_query`)
3. Handle pagination for large results
4. Format output for user consumption

### Action Pattern
1. Confirm destructive actions with user
2. Use read-only tools when exploring
3. Batch related operations
4. Log significant actions to protocol

### Integration Pattern
1. Chain MCPs for complex workflows (e.g., Jira → Slack notification)
2. Use sequential-thinking for multi-step planning
3. Combine with local scripts for processing
