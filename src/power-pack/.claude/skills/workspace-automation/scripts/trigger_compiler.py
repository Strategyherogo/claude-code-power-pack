#!/usr/bin/env python3
"""
Trigger Compiler - Parse MASTER.md to generate compiled_triggers.json
Usage: python3 trigger_compiler.py [--master /path/to/MASTER.md]
"""

import json
import re
import os
import sys
from pathlib import Path

# Default paths
DEFAULT_MASTER = Path.home() / "ClaudeCodeWorkspace" / ".claude" / "MASTER.md"
OUTPUT_DIR = Path.home() / ".claude" / "skills" / "workspace-automation" / "data"
OUTPUT_FILE = OUTPUT_DIR / "compiled_triggers.json"


def parse_trigger_table(lines: list[str], tier: int) -> list[dict]:
    """Parse markdown table rows into trigger mappings."""
    triggers = []

    for line in lines:
        line = line.strip()
        if not line.startswith("|") or line.startswith("|-") or "Trigger" in line:
            continue

        parts = [p.strip() for p in line.split("|")[1:-1]]  # Remove empty first/last
        if len(parts) < 2:
            continue

        keywords_raw = parts[0]
        command = parts[1]
        gate = parts[2] if len(parts) > 2 else None

        # Parse keywords (comma-separated)
        keywords = [k.strip().lower() for k in keywords_raw.split(",")]

        triggers.append({
            "tier": tier,
            "keywords": keywords,
            "command": command,
            "gate": gate
        })

    return triggers


def parse_master_file(filepath: Path) -> dict:
    """Parse MASTER.md and extract all trigger tiers."""
    with open(filepath, "r") as f:
        content = f.read()

    lines = content.split("\n")

    result = {
        "version": "1.0",
        "source": str(filepath),
        "tiers": {
            "1": {"name": "BLOCKING", "description": "Must complete gate before proceeding", "triggers": []},
            "2": {"name": "SUGGEST", "description": "Offer workflow, allow skip", "triggers": []},
            "3": {"name": "CONVENIENCE", "description": "Mention if relevant", "triggers": []}
        },
        "keyword_index": {}  # keyword -> [{"tier": X, "command": Y}]
    }

    current_tier = None
    table_lines = []
    in_table = False

    for i, line in enumerate(lines):
        # Detect tier sections
        if "TIER 1: BLOCKING" in line:
            current_tier = 1
            in_table = False
            table_lines = []
        elif "TIER 2: SUGGEST" in line:
            # Save tier 1 if we were collecting
            if current_tier == 1 and table_lines:
                result["tiers"]["1"]["triggers"] = parse_trigger_table(table_lines, 1)
            current_tier = 2
            in_table = False
            table_lines = []
        elif "TIER 3: CONVENIENCE" in line:
            # Save tier 2 if we were collecting
            if current_tier == 2 and table_lines:
                result["tiers"]["2"]["triggers"] = parse_trigger_table(table_lines, 2)
            current_tier = 3
            in_table = False
            table_lines = []
        elif "# MCP SERVERS" in line:
            # Save tier 3 if we were collecting
            if current_tier == 3 and table_lines:
                result["tiers"]["3"]["triggers"] = parse_trigger_table(table_lines, 3)
            current_tier = None
            in_table = False

        # Collect table lines
        if current_tier and line.strip().startswith("|"):
            table_lines.append(line)
            in_table = True
        elif current_tier and in_table and line.strip() and not line.strip().startswith("|") and not line.strip().startswith("#"):
            # End of table but same tier - might be subsection header
            if table_lines:
                result["tiers"][str(current_tier)]["triggers"].extend(parse_trigger_table(table_lines, current_tier))
                table_lines = []
            in_table = False

    # Build keyword index for fast lookup
    for tier_num, tier_data in result["tiers"].items():
        for trigger in tier_data["triggers"]:
            for keyword in trigger["keywords"]:
                if keyword not in result["keyword_index"]:
                    result["keyword_index"][keyword] = []
                result["keyword_index"][keyword].append({
                    "tier": int(tier_num),
                    "command": trigger["command"],
                    "gate": trigger.get("gate")
                })

    return result


def main():
    # Parse arguments
    master_path = DEFAULT_MASTER
    if "--master" in sys.argv:
        idx = sys.argv.index("--master")
        if idx + 1 < len(sys.argv):
            master_path = Path(sys.argv[idx + 1])

    if not master_path.exists():
        print(f"Error: MASTER.md not found at {master_path}", file=sys.stderr)
        sys.exit(1)

    # Parse and compile
    result = parse_master_file(master_path)

    # Ensure output directory exists
    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)

    # Write output
    with open(OUTPUT_FILE, "w") as f:
        json.dump(result, f, indent=2)

    # Summary
    total_triggers = sum(len(t["triggers"]) for t in result["tiers"].values())
    total_keywords = len(result["keyword_index"])

    print(json.dumps({
        "status": "success",
        "output": str(OUTPUT_FILE),
        "stats": {
            "tier1_triggers": len(result["tiers"]["1"]["triggers"]),
            "tier2_triggers": len(result["tiers"]["2"]["triggers"]),
            "tier3_triggers": len(result["tiers"]["3"]["triggers"]),
            "total_triggers": total_triggers,
            "total_keywords": total_keywords
        }
    }, indent=2))


if __name__ == "__main__":
    main()
