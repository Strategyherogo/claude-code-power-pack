# Skill: organize
Organize files and information.

## Auto-Trigger
**When:** "organize", "sort", "categorize", "structure"

## Organization Frameworks

### PARA Method
```
Projects: Active work with deadlines
Areas: Ongoing responsibilities (no end date)
Resources: Reference materials
Archive: Completed or inactive items
```

### Johnny Decimal
```
10-19: Category 1
  11: Subcategory
  12: Subcategory
20-29: Category 2
  21: Subcategory
  22: Subcategory
...
```

### GTD (Getting Things Done)
```
Inbox: Capture everything
Next Actions: Immediate tasks
Waiting For: Delegated/blocked
Someday/Maybe: Future possibilities
Reference: Information to keep
```

## File Organization Rules

### Naming Convention
```
[YYYY-MM-DD]-[descriptive-name].[ext]

Examples:
2026-01-27-meeting-notes-product-review.md
2026-01-27-invoice-acme-corp.pdf
2026-01-27-project-proposal-v2.docx
```

### Folder Structure
```
project-name/
├── docs/           # Documentation
├── src/            # Source code
├── tests/          # Test files
├── scripts/        # Build/automation
├── assets/         # Images, fonts, etc.
├── config/         # Configuration
├── .github/        # CI/CD
├── README.md
├── CHANGELOG.md
└── package.json
```

### Tag/Label System
```
Status: active, archived, review, draft
Priority: p1, p2, p3
Type: doc, code, data, media
Project: [project-name]
```

## Organization Tasks

### Quick Tidy (5 min)
```
□ Empty downloads folder
□ Process inbox items
□ File loose documents
□ Clear desktop
□ Archive completed items
```

### Weekly Organize (30 min)
```
□ Review all project folders
□ Archive completed projects
□ Update reference materials
□ Clean up duplicate files
□ Verify backup integrity
□ Update documentation
```

### Monthly Deep Organize (2 hours)
```
□ Full workspace audit
□ Archive old projects
□ Review and update PARA
□ Clean up cloud storage
□ Update naming conventions
□ Document any new systems
```

## Automation Ideas
```bash
# Auto-sort downloads by extension
#!/bin/bash
cd ~/Downloads
for file in *.pdf; do mv "$file" ~/Documents/PDFs/; done
for file in *.jpg *.png; do mv "$file" ~/Pictures/; done
for file in *.zip; do mv "$file" ~/Downloads/Archives/; done

# Auto-archive old files
find ~/Projects -type f -mtime +180 -exec mv {} ~/Archive/ \;

# Auto-rename with date prefix
for file in *; do
  mv "$file" "$(date +%Y-%m-%d)-$file"
done
```

## Decision Tree: Where Does This Go?
```
Is it actionable?
├── Yes → Is it a project?
│   ├── Yes → /Projects/[project-name]/
│   └── No → Is it a single task?
│       ├── Yes → Task manager
│       └── No → /Areas/[area]/
└── No → Is it reference material?
    ├── Yes → Do I need it?
    │   ├── Yes → /Resources/[topic]/
    │   └── No → Delete
    └── No → Archive or Delete
```

---
Last updated: 2026-01-27
