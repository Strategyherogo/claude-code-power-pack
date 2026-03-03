# Skill: scaffold
Generate project boilerplate and code structure.

## Auto-Trigger
**When:** "scaffold", "generate project", "boilerplate", "create project", "init project", "starter"

## Project Templates

### Node.js/TypeScript API
```
my-api/
├── src/
│   ├── index.ts
│   ├── routes/
│   │   └── index.ts
│   ├── controllers/
│   │   └── healthController.ts
│   ├── services/
│   │   └── index.ts
│   ├── middleware/
│   │   ├── auth.ts
│   │   └── errorHandler.ts
│   ├── utils/
│   │   └── logger.ts
│   └── types/
│       └── index.ts
├── tests/
│   └── health.test.ts
├── package.json
├── tsconfig.json
├── .env.example
├── .gitignore
├── README.md
└── Dockerfile
```

### React/Next.js App
```
my-app/
├── src/
│   ├── app/
│   │   ├── layout.tsx
│   │   ├── page.tsx
│   │   └── globals.css
│   ├── components/
│   │   ├── ui/
│   │   └── common/
│   ├── hooks/
│   ├── lib/
│   ├── services/
│   └── types/
├── public/
├── tests/
├── package.json
├── next.config.js
├── tailwind.config.js
└── tsconfig.json
```

### Python FastAPI
```
my-api/
├── app/
│   ├── __init__.py
│   ├── main.py
│   ├── routers/
│   │   └── health.py
│   ├── services/
│   ├── models/
│   ├── schemas/
│   └── utils/
├── tests/
├── requirements.txt
├── Dockerfile
├── .env.example
└── README.md
```

### Swift iOS App
```
MyApp/
├── MyApp/
│   ├── App/
│   │   └── MyAppApp.swift
│   ├── Views/
│   │   ├── ContentView.swift
│   │   └── Components/
│   ├── ViewModels/
│   ├── Models/
│   ├── Services/
│   ├── Utilities/
│   └── Resources/
│       └── Assets.xcassets
├── MyAppTests/
├── MyAppUITests/
└── README.md
```

### MCP Server
```
my-mcp-server/
├── src/
│   ├── index.ts
│   ├── tools/
│   │   └── myTool.ts
│   └── resources/
├── package.json
├── tsconfig.json
└── README.md
```

## Quick Scaffold Commands

### Node.js
```bash
# Create directory
mkdir my-project && cd my-project

# Initialize
npm init -y

# Add TypeScript
npm install -D typescript @types/node ts-node
npx tsc --init

# Create structure
mkdir -p src/{routes,controllers,services,middleware,utils,types}
mkdir tests

# Create entry point
cat > src/index.ts << 'EOF'
import express from 'express';

const app = express();
const PORT = process.env.PORT || 3000;

app.get('/health', (req, res) => {
  res.json({ status: 'ok' });
});

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
EOF
```

### Python
```bash
# Create directory
mkdir my-project && cd my-project

# Create venv
python3 -m venv venv
source venv/bin/activate

# Create structure
mkdir -p app/{routers,services,models,schemas,utils}
mkdir tests

# Create main
cat > app/main.py << 'EOF'
from fastapi import FastAPI

app = FastAPI()

@app.get("/health")
def health():
    return {"status": "ok"}
EOF

# Requirements
cat > requirements.txt << 'EOF'
fastapi
uvicorn
EOF
```

## File Templates

### .gitignore (Node)
```
node_modules/
dist/
.env
*.log
.DS_Store
coverage/
```

### .env.example
```
NODE_ENV=development
PORT=3000
DATABASE_URL=postgres://localhost/mydb
API_KEY=your-api-key-here
```

### README.md Template
```markdown
# Project Name

Brief description.

## Setup

\`\`\`bash
npm install
cp .env.example .env
npm run dev
\`\`\`

## Scripts

- `npm run dev` - Development server
- `npm run build` - Build for production
- `npm test` - Run tests

## API

| Endpoint | Method | Description |
|----------|--------|-------------|
| /health | GET | Health check |

## License

MIT
```

## Usage

```
/scaffold node-api [name]     # Node.js API
/scaffold next-app [name]     # Next.js app
/scaffold python-api [name]   # FastAPI
/scaffold swift-app [name]    # iOS app
/scaffold mcp [name]          # MCP server
/scaffold cli [name]          # CLI tool
```

---
Last updated: 2026-01-29
