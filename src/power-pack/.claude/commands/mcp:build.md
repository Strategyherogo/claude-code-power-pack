# Skill: mcp:build
Create new MCP (Model Context Protocol) servers.

## Auto-Trigger
**When:** "build mcp", "create mcp server", "new mcp", "mcp server"

## MCP Server Structure

### TypeScript Template
```
my-mcp-server/
├── package.json
├── tsconfig.json
├── src/
│   ├── index.ts        # Entry point
│   ├── server.ts       # MCP server setup
│   ├── tools/          # Tool implementations
│   │   └── myTool.ts
│   └── resources/      # Resource providers
│       └── myResource.ts
└── README.md
```

### package.json
```json
{
  "name": "@your-org/mcp-server-name",
  "version": "0.1.0",
  "description": "MCP server for [purpose]",
  "main": "dist/index.js",
  "types": "dist/index.d.ts",
  "bin": {
    "mcp-server-name": "dist/index.js"
  },
  "scripts": {
    "build": "tsc",
    "start": "node dist/index.js",
    "dev": "ts-node src/index.ts"
  },
  "dependencies": {
    "@modelcontextprotocol/sdk": "^0.5.0"
  },
  "devDependencies": {
    "@types/node": "^20.0.0",
    "typescript": "^5.0.0",
    "ts-node": "^10.9.0"
  }
}
```

### Basic Server (src/index.ts)
```typescript
#!/usr/bin/env node

import { Server } from "@modelcontextprotocol/sdk/server/index.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
import {
  CallToolRequestSchema,
  ListToolsRequestSchema,
} from "@modelcontextprotocol/sdk/types.js";

const server = new Server(
  {
    name: "my-mcp-server",
    version: "0.1.0",
  },
  {
    capabilities: {
      tools: {},
    },
  }
);

// List available tools
server.setRequestHandler(ListToolsRequestSchema, async () => {
  return {
    tools: [
      {
        name: "my_tool",
        description: "Description of what this tool does",
        inputSchema: {
          type: "object",
          properties: {
            param1: {
              type: "string",
              description: "Description of param1",
            },
          },
          required: ["param1"],
        },
      },
    ],
  };
});

// Handle tool calls
server.setRequestHandler(CallToolRequestSchema, async (request) => {
  const { name, arguments: args } = request.params;

  if (name === "my_tool") {
    const { param1 } = args as { param1: string };

    // Your tool logic here
    const result = `Processed: ${param1}`;

    return {
      content: [
        {
          type: "text",
          text: result,
        },
      ],
    };
  }

  throw new Error(`Unknown tool: ${name}`);
});

// Start server
async function main() {
  const transport = new StdioServerTransport();
  await server.connect(transport);
  console.error("MCP server running on stdio");
}

main().catch(console.error);
```

## Adding to Claude Code

### mcp.json entry
```json
{
  "my-server": {
    "command": "node",
    "args": ["/path/to/dist/index.js"],
    "env": {
      "API_KEY": "your-key"
    }
  }
}
```

### Or via npx
```json
{
  "my-server": {
    "command": "npx",
    "args": ["-y", "@your-org/mcp-server-name"]
  }
}
```

## Tool Types

### Query Tool
```typescript
{
  name: "search",
  description: "Search for items",
  inputSchema: {
    type: "object",
    properties: {
      query: { type: "string" },
      limit: { type: "number", default: 10 }
    },
    required: ["query"]
  }
}
```

### Action Tool
```typescript
{
  name: "create_item",
  description: "Create a new item",
  inputSchema: {
    type: "object",
    properties: {
      name: { type: "string" },
      data: { type: "object" }
    },
    required: ["name"]
  }
}
```

## Testing

### Local test
```bash
# Build
npm run build

# Test with echo
echo '{"jsonrpc":"2.0","method":"tools/list","id":1}' | node dist/index.js
```

### In Claude Code
```bash
# Restart Claude Code after adding to mcp.json
# Then test the tool
```

## Common Patterns

### With API Client
```typescript
import axios from 'axios';

const client = axios.create({
  baseURL: process.env.API_URL,
  headers: { 'Authorization': `Bearer ${process.env.API_KEY}` }
});
```

### With Database
```typescript
import { Pool } from 'pg';

const pool = new Pool({
  connectionString: process.env.DATABASE_URL
});
```

### Error Handling
```typescript
try {
  // Tool logic
} catch (error) {
  return {
    content: [{
      type: "text",
      text: `Error: ${error.message}`
    }],
    isError: true
  };
}
```

## Quick Commands
```
/mcp:build [name]           # Scaffold new MCP server
/mcp:build tool [name]      # Add tool to existing server
/mcp:build test             # Test current server
```

## Resources
- [MCP SDK](https://github.com/modelcontextprotocol/typescript-sdk)
- [MCP Spec](https://spec.modelcontextprotocol.io)
- [Example Servers](https://github.com/modelcontextprotocol/servers)

---
Last updated: 2026-01-29
