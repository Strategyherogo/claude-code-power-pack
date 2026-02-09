#!/usr/bin/env python3
"""
Trigger Detector - Detect skill triggers in user input
Usage: echo "user input" | python3 trigger_detector.py
       python3 trigger_detector.py --input "user input"
"""

import json
import re
import sys
from pathlib import Path

# Paths
DATA_DIR = Path.home() / ".claude" / "skills" / "workspace-automation" / "data"
TRIGGERS_FILE = DATA_DIR / "compiled_triggers.json"
CONFIG_FILE = DATA_DIR / "trigger_config.json"

# Default thresholds
DEFAULT_MIN_LENGTH = 50
DEFAULT_MIN_KEYWORDS = 2

# Skip patterns (false positive prevention)
SKIP_PATTERNS = [
    # Past tense - user reporting what happened, not requesting action
    r"\bi (already |just )?(deployed|fixed|completed|resolved|done)\b",
    r"\bi (have |had )?(deployed|fixed|completed|resolved)\b",
    r"\bit('s| is| was) (deployed|fixed|completed|resolved|done)\b",
    r"\bwe (already |just )?(deployed|fixed|completed|resolved)\b",

    # Questions - asking about, not requesting
    r"\bwhat (is|are|was|were) .*(deploy|debug|error|fix)\b",
    r"\bhow (do|does|can|should|would) .*(deploy|debug|error|fix)\b",
    r"\bwhy (is|are|was|were|did) .*(deploy|debug|error|fix)\b",
    r"\bcan you explain .*(deploy|debug|error|fix)\b",

    # Negations
    r"\bdon'?t (deploy|fix|debug|release)\b",
    r"\bnot (deploy|fix|debug|release)\b",
    r"\bno need to (deploy|fix|debug|release)\b",
    r"\bskip (deploy|verify|check)\b",
]


def load_triggers() -> dict:
    """Load compiled triggers from JSON file."""
    if not TRIGGERS_FILE.exists():
        return None
    with open(TRIGGERS_FILE, "r") as f:
        return json.load(f)


def load_settings() -> dict:
    """Load settings for thresholds."""
    settings = {
        "enabled": True,
        "tier1_blocking": True,
        "tier2_suggest": True,
        "tier3_convenience": True,
        "thresholds": {
            "min_message_length": DEFAULT_MIN_LENGTH,
            "min_keywords": DEFAULT_MIN_KEYWORDS
        },
        "disabled_skills": []
    }

    if CONFIG_FILE.exists():
        with open(CONFIG_FILE, "r") as f:
            loaded = json.load(f)
            settings.update(loaded)

    return settings


def should_skip(text: str) -> tuple[bool, str]:
    """Check if input matches skip patterns."""
    text_lower = text.lower()

    for pattern in SKIP_PATTERNS:
        if re.search(pattern, text_lower, re.IGNORECASE):
            return True, pattern

    return False, None


def detect_triggers(text: str, triggers_data: dict, settings: dict) -> dict:
    """
    Detect triggers in user input.

    Returns:
        {
            "detected": bool,
            "matches": [{"tier": int, "command": str, "keywords_matched": [...], "gate": str|None}],
            "skipped": bool,
            "skip_reason": str|None,
            "input_length": int
        }
    """
    result = {
        "detected": False,
        "matches": [],
        "skipped": False,
        "skip_reason": None,
        "input_length": len(text)
    }

    # Check if triggers are enabled
    if not settings.get("enabled", True):
        result["skipped"] = True
        result["skip_reason"] = "triggers_disabled"
        return result

    # Check minimum length
    min_length = settings.get("thresholds", {}).get("min_message_length", DEFAULT_MIN_LENGTH)
    if len(text) < min_length:
        result["skipped"] = True
        result["skip_reason"] = f"input_too_short (min: {min_length})"
        return result

    # Check skip patterns
    should_skip_result, skip_pattern = should_skip(text)
    if should_skip_result:
        result["skipped"] = True
        result["skip_reason"] = f"matched_skip_pattern: {skip_pattern}"
        return result

    # Normalize text for matching
    text_lower = text.lower()
    text_words = set(re.findall(r'\b[\w\'-]+\b', text_lower))

    # Find keyword matches
    keyword_index = triggers_data.get("keyword_index", {})
    min_keywords = settings.get("thresholds", {}).get("min_keywords", DEFAULT_MIN_KEYWORDS)

    # Track matches per command
    command_matches = {}  # command -> {tier, keywords_matched, gate}

    for keyword, mappings in keyword_index.items():
        # Check for keyword match (as whole word or phrase)
        if keyword in text_lower or keyword in text_words:
            for mapping in mappings:
                command = mapping["command"]
                tier = mapping["tier"]

                # Check if tier is enabled
                tier_key = f"tier{tier}_{'blocking' if tier == 1 else 'suggest' if tier == 2 else 'convenience'}"
                if not settings.get(tier_key, True):
                    continue

                # Check if skill is disabled
                if command in settings.get("disabled_skills", []):
                    continue

                if command not in command_matches:
                    command_matches[command] = {
                        "tier": tier,
                        "command": command,
                        "keywords_matched": [],
                        "gate": mapping.get("gate")
                    }

                if keyword not in command_matches[command]["keywords_matched"]:
                    command_matches[command]["keywords_matched"].append(keyword)

    # Filter by minimum keyword count (except tier 1 which is always important)
    for command, match_data in command_matches.items():
        keyword_count = len(match_data["keywords_matched"])
        tier = match_data["tier"]

        # Tier 1 (blocking) triggers with 1+ keyword, others need min_keywords
        if tier == 1 or keyword_count >= min_keywords:
            result["matches"].append(match_data)

    # Sort by tier (tier 1 first) then by keyword count
    result["matches"].sort(key=lambda x: (x["tier"], -len(x["keywords_matched"])))

    result["detected"] = len(result["matches"]) > 0

    return result


def format_output(result: dict, verbose: bool = False) -> str:
    """Format detection result for display."""
    if not result["detected"]:
        if result["skipped"]:
            return json.dumps({"status": "skipped", "reason": result["skip_reason"]})
        return json.dumps({"status": "no_triggers"})

    # Group by tier
    tier1 = [m for m in result["matches"] if m["tier"] == 1]
    tier2 = [m for m in result["matches"] if m["tier"] == 2]
    tier3 = [m for m in result["matches"] if m["tier"] == 3]

    output = {
        "status": "detected",
        "tier1_blocking": tier1,
        "tier2_suggest": tier2[:3],  # Limit suggestions to top 3
        "tier3_convenience": tier3[:1],  # Limit convenience to 1
        "total_matches": len(result["matches"])
    }

    return json.dumps(output, indent=2)


def main():
    # Get input
    if "--input" in sys.argv:
        idx = sys.argv.index("--input")
        if idx + 1 < len(sys.argv):
            text = sys.argv[idx + 1]
        else:
            print(json.dumps({"error": "No input provided"}))
            sys.exit(1)
    elif not sys.stdin.isatty():
        text = sys.stdin.read().strip()
    else:
        print(json.dumps({"error": "No input provided. Use --input or pipe text."}))
        sys.exit(1)

    # Load data
    triggers_data = load_triggers()
    if not triggers_data:
        print(json.dumps({"error": "Compiled triggers not found. Run trigger_compiler.py first."}))
        sys.exit(1)

    settings = load_settings()

    # Detect
    result = detect_triggers(text, triggers_data, settings)

    # Output
    verbose = "--verbose" in sys.argv or "-v" in sys.argv
    print(format_output(result, verbose))


if __name__ == "__main__":
    main()
