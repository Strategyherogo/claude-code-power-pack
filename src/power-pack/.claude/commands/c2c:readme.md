# Skill: c2c:readme
Create effective README files.

## Auto-Trigger
**When:** "readme", "documentation", "project docs"

## README Structure

### Essential Sections
```markdown
# Project Name

One-line description of what this does.

## Quick Start

\`\`\`bash
npm install project-name
npm start
\`\`\`

## Features

- Feature 1: Brief description
- Feature 2: Brief description
- Feature 3: Brief description

## Installation

\`\`\`bash
npm install project-name
# or
yarn add project-name
\`\`\`

## Usage

\`\`\`javascript
import { thing } from 'project-name';

const result = thing.doSomething();
\`\`\`

## Configuration

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| option1 | string | 'default' | What it does |
| option2 | boolean | false | What it does |

## API Reference

### `methodName(param)`

Description of what this method does.

**Parameters:**
- `param` (string): Description

**Returns:** Description of return value

**Example:**
\`\`\`javascript
const result = methodName('value');
\`\`\`

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md)

## License

MIT
```

### Extended Sections (if needed)
```markdown
## Why This Exists

[Problem this solves and motivation]

## Architecture

[High-level overview of how it works]

## Roadmap

- [ ] Planned feature 1
- [ ] Planned feature 2
- [x] Completed feature

## FAQ

**Q: Common question?**
A: Answer

## Troubleshooting

### Issue: [Problem]
**Solution:** [Fix]

## Changelog

See [CHANGELOG.md](CHANGELOG.md)

## Acknowledgments

- [Credit 1]
- [Credit 2]
```

## README Templates by Type

### Library/Package
```markdown
# library-name

> Short tagline

[![npm version](badge-url)](link)
[![Build Status](badge-url)](link)

## Install

## Usage

## API

## Examples

## Contributing

## License
```

### CLI Tool
```markdown
# tool-name

> What it does

## Installation

## Commands

## Options

## Examples

## Configuration
```

### Application
```markdown
# App Name

> What it does

## Demo

[Link or screenshot]

## Features

## Getting Started

### Prerequisites

### Installation

### Configuration

## Usage

## Deployment

## Contributing
```

## Quality Checklist
```
□ Clear one-line description
□ Quick start in <30 seconds
□ Installation instructions work
□ Usage example is copy-pasteable
□ All configuration options documented
□ Common issues addressed
□ License specified
□ Badges are accurate
□ Links work
□ No typos in code examples
```

---
Last updated: 2026-01-27
