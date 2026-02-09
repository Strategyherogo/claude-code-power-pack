# Skill: archive
Archive completed or inactive items.

## Auto-Trigger
**When:** "archive", "complete", "done with", "close project"

## Archive Checklist

### Before Archiving
```
□ Project/task is truly complete
□ All deliverables submitted
□ Documentation updated
□ Lessons learned captured
□ Stakeholders notified (if relevant)
□ No pending follow-ups
```

### Archive Actions

#### Git Repository
```bash
# Tag final version
git tag -a v1.0.0-final -m "Project complete"
git push origin --tags

# Archive branch
git checkout main
git branch -m feature-x archived/feature-x
git push origin archived/feature-x

# Or full repo archive
gh repo archive owner/repo
```

#### Project Folder
```bash
# Create archive with date
ARCHIVE_NAME="2026-01-27-project-name"
tar -czvf "archive/$ARCHIVE_NAME.tar.gz" ./project-name/

# Move to archive folder
mv project-name/ "4. Archive/2026/$ARCHIVE_NAME/"
```

#### Cloud Storage
```
Google Drive: Right-click → Move to "Archive" folder
Notion: Move page to "Archive" workspace
Dropbox: Move to Archive folder
```

## Archive Metadata Template
```markdown
## Archive Record: [Project Name]

**Archived:** [date]
**Original Location:** [path]
**Archive Location:** [path]

### Project Summary
- **Duration:** [start] to [end]
- **Goal:** [what we set out to do]
- **Outcome:** [what was achieved]
- **Status:** Completed / Abandoned / Superseded

### Key Deliverables
- [deliverable 1] - [location]
- [deliverable 2] - [location]

### Key Learnings
1. [learning 1]
2. [learning 2]
3. [learning 3]

### Related Items
- [related project/doc 1]
- [related project/doc 2]

### Retrieval Notes
To restore this project:
1. [step 1]
2. [step 2]

### Tags
[project-type], [client], [technology], [year]
```

## Archive Structure
```
4. Archive/
├── 2024/
│   ├── Q1/
│   ├── Q2/
│   ├── Q3/
│   └── Q4/
├── 2025/
│   └── ...
└── 2026/
    └── 2026-01-project-name/
        ├── ARCHIVE-RECORD.md
        ├── src/
        ├── docs/
        └── deliverables/
```

## When to Archive
```
Immediately:
- Project delivered and accepted
- Contract ended
- Decision made to stop

After 30 days:
- No activity on project
- Waiting for response that never came
- Superseded by new version

After 90 days:
- Reference materials not accessed
- Old drafts and versions
- Completed experiments
```

## Archive vs Delete
```
ARCHIVE if:
- Might need to reference later
- Contains unique information
- Has historical value
- Legal/compliance requirements

DELETE if:
- Duplicate of something archived
- Temporary/scratch work
- No future value
- Outdated and misleading
```

## Restore from Archive
```bash
# Extract archived project
tar -xzvf "archive/2026-01-27-project-name.tar.gz" -C ./restored/

# Review archive record first
cat "./restored/project-name/ARCHIVE-RECORD.md"

# Verify integrity
# Check that key files exist and are readable
```

---
Last updated: 2026-01-27
