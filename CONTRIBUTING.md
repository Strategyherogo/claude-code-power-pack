# Contributing to Claude Code Power Pack

Thanks for your interest in contributing! This project is open source and welcomes contributions.

## Ways to Contribute

### Add a New Skill
1. Create a markdown file in `src/power-pack/.claude/commands/`
2. Follow the naming convention: `skill-name.md` (kebab-case)
3. Use namespaces for domain-specific skills: `swift:skill-name.md`, `sales:skill-name.md`
4. Include these sections:
   ```markdown
   # Skill: skill-name
   Brief description.

   ## Auto-Trigger
   **When:** "keyword1", "keyword2"

   ## Steps
   1. First step
   2. Second step

   ## Output Format
   What the skill produces.
   ```
5. Open a PR with a description of what the skill does and when it's useful

### Improve an Existing Skill
- Fix typos or unclear instructions
- Add missing steps or edge cases
- Improve output format

### Add Coding Rules
- Drop a `.md` file in `src/power-pack/.claude/rules/`
- Follow the pattern of existing rules (common.md, python.md, etc.)

### Report Issues
- Use the **Bug Report** template for broken skills or install issues
- Use the **Skill Request** template to suggest new skills

## Development Setup

```bash
# Clone
git clone https://github.com/Strategyherogo/claude-code-power-pack.git
cd claude-code-power-pack

# Install into a test project
mkdir /tmp/test-project && cd /tmp/test-project
bash /path/to/claude-code-power-pack/src/power-pack/install.sh

# Test your changes
cd /tmp/test-project
claude  # Start Claude Code and test your skill
```

## Guidelines

- **Keep skills focused** — one skill, one workflow
- **No dependencies** — skills are markdown only, no build step
- **No credentials** — never include API keys, tokens, or personal data
- **Test your skill** — run it in Claude Code before submitting
- **Keep it concise** — if a skill exceeds 200 lines, consider splitting it

## Pull Request Process

1. Fork the repo
2. Create a feature branch (`git checkout -b add-skill-name`)
3. Make your changes
4. Run the genericize check: `python3 genericize.py` (ensures no personal data)
5. Open a PR with a clear description

## Code of Conduct

Be respectful. We're all here to make Claude Code better.
