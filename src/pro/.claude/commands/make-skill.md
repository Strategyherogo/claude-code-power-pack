# Skill: make-skill
Create new Claude Code skills.

## Auto-Trigger
**When:** "create skill", "new skill", "make skill", "add skill"

## Skill Template
```markdown
# Skill: [skill-name]
[One-line description of what this skill does]

## Auto-Trigger
**When:** "[keyword1]", "[keyword2]", "[phrase]"

## [Main Section Title]

### [Subsection]
\`\`\`
[Template, code, or instructions]
\`\`\`

### [Subsection]
[Content]

## [Second Section]
[Content]

## Checklist
\`\`\`
□ [Item 1]
□ [Item 2]
□ [Item 3]
\`\`\`

---
Last updated: [date]
```

## Skill Categories

### Workflow Skills
```
Purpose: Guide multi-step processes
Example: /deploy-verify, /email:forensic-workflow

Structure:
- Step-by-step process
- Checklists at each step
- Expected outputs
- Error handling
```

### Reference Skills
```
Purpose: Quick lookup information
Example: /lookup, /db-query

Structure:
- Common patterns/templates
- Quick reference tables
- Copy-paste commands
- Examples
```

### Generator Skills
```
Purpose: Create content from templates
Example: /c2c:blog, /case-study

Structure:
- Template with placeholders
- Variation options
- Example outputs
- Quality checklist
```

### Analysis Skills
```
Purpose: Analyze and report
Example: /workspace-audit, /log-errors

Structure:
- Data gathering steps
- Analysis criteria
- Report template
- Recommendations format
```

### Integration Skills
```
Purpose: Work with external tools
Example: /jira-quick, /gws-search

Structure:
- API/tool reference
- Common commands
- Example queries
- Troubleshooting
```

## Skill Naming Convention
```
Category prefixes:
- deploy: Deployment operations
- email: Email-related
- pm: Project management
- swift: Swift/iOS development
- bot: Bot/automation
- mcp: MCP configuration
- neuro: Neuroperformance
- c2c: Content creation

Format: [category]:[action-noun]
Examples:
- deploy:verify
- email:forensic-workflow
- c2c:blog
- neuro:daily-check
```

## Creating a New Skill

### Step 1: Define Purpose
```
□ What problem does this solve?
□ When should it trigger?
□ What's the expected output?
□ Who is the target user?
```

### Step 2: Structure Content
```
□ Clear, descriptive title
□ Auto-trigger keywords
□ Logical sections
□ Actionable steps
□ Templates/examples
□ Checklists where helpful
```

### Step 3: Test and Refine
```
□ Try using the skill
□ Check for missing steps
□ Verify examples work
□ Add edge case handling
□ Update based on usage
```

## File Location
```
Save to: .claude/commands/[skill-name].md

Naming:
- All lowercase
- Use colons for namespaces: category:name.md
- Use hyphens for multi-word: my-skill-name.md
```

## Skill Registry Entry
After creating, add to SKILL-INDEX.md:
```markdown
| /[skill-name] | [brief description] | [category] |
```

---
Last updated: 2026-01-27
