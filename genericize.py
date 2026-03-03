#!/usr/bin/env python3
"""
Genericize Claude Code workspace files for distribution.
Strips personal data (paths, IDs, company names) and replaces with placeholders.
"""

import os
import re
import shutil
from pathlib import Path

# Source locations
HOME = os.path.expanduser("~")
WORKSPACE = f"{HOME}/ClaudeCodeWorkspace"
CLAUDE_DIR = f"{HOME}/.claude"

# Output locations
SCRIPT_DIR = Path(__file__).parent
PRO_DIR = SCRIPT_DIR / "src" / "pro"

# Replacements: (pattern, replacement)
REPLACEMENTS = [
    # Personal paths
    (r"/Users/jenyagowork", "$HOME"),
    (r"jenyagowork", "YOUR_USERNAME"),
    # Company/org
    (r"thealternative\.co", "YOUR_COMPANY.com"),
    (r"thealternative", "YOUR_COMPANY"),
    (r"The Alternative", "YOUR_COMPANY"),
    (r"Strategyherogo", "YOUR_GITHUB_ORG"),
    # Monday.com IDs
    (r"5091380779", "YOUR_MONDAY_BOARD_ID"),
    (r"5090420844", "YOUR_MONDAY_BOARD_ID_2"),
    (r"5090410989", "YOUR_MONDAY_BOARD_ID_3"),
    (r"2628729", "YOUR_MONDAY_FOLDER_ID"),
    (r"color_mm0[a-z0-9]+", "YOUR_COLUMN_ID"),
    (r"text_mm0[a-z0-9]+", "YOUR_COLUMN_ID"),
    (r"numeric_mm0[a-z0-9]+", "YOUR_COLUMN_ID"),
    (r"link_mm0[a-z0-9]+", "YOUR_COLUMN_ID"),
    # Jira
    (r"40e33327-adf8-4b21-a33e-bf0c4759a3fe", "YOUR_JIRA_CLOUD_ID"),
    (r"thealternative\.atlassian\.net", "YOUR_ORG.atlassian.net"),
    # API tokens (safety net)
    (r"eyJhbGciOi[A-Za-z0-9._-]+", "YOUR_API_TOKEN"),
    (r"ATATT3x[A-Za-z0-9._-]+", "YOUR_JIRA_TOKEN"),
    (r"sk-ant-api[A-Za-z0-9._-]+", "YOUR_ANTHROPIC_KEY"),
    (r"xoxb-[0-9]{10,}[A-Za-z0-9-]+", "YOUR_SLACK_TOKEN"),
    # Specific project references
    (r"01-ir-email-monitor", "YOUR_PROJECT"),
    (r"06-slack-jira-bot-alternative", "YOUR_PROJECT"),
    (r"25-claude-usage-battery", "YOUR_PROJECT"),
    # Specific people
    (r"egoncharov@", "user@"),
    (r"kupranis", "YOUR_NAME"),
    # IP addresses
    (r"167\.71\.142\.118", "YOUR_SERVER_IP"),
    # GCP service accounts
    (r"gcp-service-account", "YOUR_SERVICE_ACCOUNT"),
]


def genericize_content(content: str) -> str:
    """Apply all replacements to file content."""
    for pattern, replacement in REPLACEMENTS:
        content = re.sub(pattern, replacement, content)
    return content


def copy_and_genericize(src: str, dst: str) -> None:
    """Copy a file, genericizing its content if it's text."""
    dst_path = Path(dst)
    dst_path.parent.mkdir(parents=True, exist_ok=True)

    # Binary files: copy as-is
    if src.endswith((".pyc", ".png", ".jpg", ".ico", ".car", ".scpt")):
        shutil.copy2(src, dst)
        return

    try:
        with open(src, "r", encoding="utf-8") as f:
            content = f.read()
        content = genericize_content(content)
        with open(dst, "w", encoding="utf-8") as f:
            f.write(content)
    except (UnicodeDecodeError, IsADirectoryError):
        shutil.copy2(src, dst)


def build_pro_tier():
    """Build the pro power pack."""
    print("Building Pro Power Pack...")

    # ALL skills
    commands_dir = f"{WORKSPACE}/.claude/commands"
    for item in os.listdir(commands_dir):
        src = f"{commands_dir}/{item}"
        if os.path.isfile(src) and item.endswith(".md"):
            copy_and_genericize(src, str(PRO_DIR / ".claude" / "commands" / item))
        elif os.path.isdir(src):
            # Subdirectories (like sales/)
            for f in os.listdir(src):
                if f.endswith(".md"):
                    copy_and_genericize(
                        f"{src}/{f}",
                        str(PRO_DIR / ".claude" / "commands" / item / f)
                    )

    # Rules
    rules_dir = f"{WORKSPACE}/.claude/rules"
    for f in os.listdir(rules_dir):
        if f.endswith(".md"):
            copy_and_genericize(
                f"{rules_dir}/{f}",
                str(PRO_DIR / ".claude" / "rules" / f)
            )

    # CLAUDE.md + MASTER.md
    for f in ["CLAUDE.md", "MASTER.md"]:
        src = f"{WORKSPACE}/.claude/{f}"
        if os.path.exists(src):
            copy_and_genericize(src, str(PRO_DIR / ".claude" / f))

    # Hooks
    for hook in ["startup-parallel.sh", "pre-deploy-check.sh", "session-end-save.sh"]:
        src = f"{CLAUDE_DIR}/hooks/{hook}"
        if os.path.exists(src):
            copy_and_genericize(src, str(PRO_DIR / "hooks" / hook))

    # Scripts
    for script in [
        "cs.sh", "context-analyzer.sh", "auto-retro.sh",
        "status-log.sh", "daily-package-check.sh",
        "daily-monday-check.sh", "log-stats.sh"
    ]:
        src = f"{CLAUDE_DIR}/scripts/{script}"
        if os.path.exists(src):
            copy_and_genericize(src, str(PRO_DIR / "scripts" / script))

    # Workspace automation
    wa_dir = f"{CLAUDE_DIR}/skills/workspace-automation"
    if os.path.exists(wa_dir):
        for root, dirs, files in os.walk(wa_dir):
            for f in files:
                src = os.path.join(root, f)
                rel = os.path.relpath(src, wa_dir)
                copy_and_genericize(
                    src,
                    str(PRO_DIR / ".claude" / "skills" / "workspace-automation" / rel)
                )

    # Crontab
    crontab_src = f"{SCRIPT_DIR}/src/pro/cron/crontab.txt"
    # Will be created separately

    # .gitkeep
    (PRO_DIR / "context-saves").mkdir(parents=True, exist_ok=True)
    (PRO_DIR / "context-saves" / ".gitkeep").touch()

    skill_count = sum(
        1 for f in (PRO_DIR / ".claude" / "commands").rglob("*.md")
    )
    print(f"  Skills: {skill_count}")
    print(f"  Hooks: {len(list((PRO_DIR / 'hooks').glob('*.sh')))}")
    print(f"  Scripts: {len(list((PRO_DIR / 'scripts').glob('*')))}")


def verify_no_personal_data():
    """Check that no personal data leaked into output."""
    print("\nVerifying no personal data...")
    leaks = []
    sensitive = [
        "thealternative", "jenyagowork", "5091380", "40e33327",
        "egoncharov", "kupranis", "167.71.142", "eyJhbGciOi",
        "ATATT3x", "sk-ant-api",
    ]
    # xoxb- only counts as a leak if followed by 10+ digits (actual token)
    sensitive_patterns = [
        r"xoxb-[0-9]{10,}",
    ]

    for tier_dir in [PRO_DIR]:
        for root, dirs, files in os.walk(tier_dir):
            for f in files:
                fpath = os.path.join(root, f)
                try:
                    with open(fpath, "r", encoding="utf-8") as fh:
                        content = fh.read()
                    for term in sensitive:
                        if term.lower() in content.lower():
                            rel = os.path.relpath(fpath, SCRIPT_DIR)
                            leaks.append(f"  LEAK: '{term}' in {rel}")
                    for pat in sensitive_patterns:
                        if re.search(pat, content):
                            rel = os.path.relpath(fpath, SCRIPT_DIR)
                            leaks.append(f"  LEAK: pattern '{pat}' in {rel}")
                except (UnicodeDecodeError, IsADirectoryError):
                    pass

    if leaks:
        print(f"  FOUND {len(leaks)} leaks:")
        for l in leaks:
            print(l)
        return False
    else:
        print("  No personal data found. Clean.")
        return True


if __name__ == "__main__":
    # Clean output dir
    if PRO_DIR.exists():
        shutil.rmtree(PRO_DIR)
    PRO_DIR.mkdir(parents=True)

    build_pro_tier()
    verify_no_personal_data()
    print("\nDone. Files in src/pro/")
