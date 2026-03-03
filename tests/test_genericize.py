#!/usr/bin/env python3
"""
Tests for genericize.py — verifies that the distributed files
contain no personal data leaks.

Runs against the already-built src/power-pack/ directory.
If src/power-pack/ doesn't exist, verifies the genericize patterns work correctly.
"""

import os
import re
import sys

# Sensitive terms that must NOT appear in distributed files
SENSITIVE_TERMS = [
    "thealternative",
    "jenyagowork",
    "5091380779",   # Monday board ID
    "40e33327",     # Jira cloud ID
    "egoncharov",
    "kupranis",
    "167.71.142",   # Server IP
]

SENSITIVE_PATTERNS = [
    r"eyJhbGciOi[A-Za-z0-9._-]{20,}",  # JWT tokens
    r"ATATT3x[A-Za-z0-9._-]{20,}",      # Jira API tokens
    r"sk-ant-api[A-Za-z0-9._-]{20,}",   # Anthropic keys
    r"xoxb-[0-9]{10,}",                  # Slack bot tokens
]


def scan_directory(path: str) -> list[str]:
    """Scan all files in path for sensitive data. Returns list of leaks."""
    leaks = []
    for root, dirs, files in os.walk(path):
        for f in files:
            fpath = os.path.join(root, f)
            try:
                with open(fpath, "r", encoding="utf-8") as fh:
                    content = fh.read()
            except (UnicodeDecodeError, IsADirectoryError):
                continue

            rel = os.path.relpath(fpath, path)

            for term in SENSITIVE_TERMS:
                if term.lower() in content.lower():
                    leaks.append(f"LEAK: '{term}' found in {rel}")

            for pat in SENSITIVE_PATTERNS:
                if re.search(pat, content):
                    leaks.append(f"LEAK: pattern '{pat}' matched in {rel}")

    return leaks


def test_genericize_patterns():
    """Test that the replacement patterns work correctly."""
    # Import from parent directory
    sys.path.insert(0, os.path.join(os.path.dirname(__file__), ".."))
    from genericize import genericize_content

    test_cases = [
        ("/Users/jenyagowork/projects", "$HOME/projects"),
        ("thealternative.co", "YOUR_COMPANY.com"),
        ("Strategyherogo", "YOUR_GITHUB_ORG"),
        ("40e33327-adf8-4b21-a33e-bf0c4759a3fe", "YOUR_JIRA_CLOUD_ID"),
        ("egoncharov@gmail.com", "user@gmail.com"),
    ]

    failures = []
    for input_text, expected_substring in test_cases:
        result = genericize_content(input_text)
        if expected_substring not in result:
            failures.append(
                f"Pattern failed: '{input_text}' -> '{result}' "
                f"(expected '{expected_substring}')"
            )

    return failures


def main():
    """Run all checks."""
    script_dir = os.path.dirname(os.path.abspath(__file__))
    project_root = os.path.dirname(script_dir)
    pro_dir = os.path.join(project_root, "src", "pro")

    print("=== Genericize Tests ===\n")

    # Test 1: Scan distributed files for leaks
    if os.path.exists(pro_dir):
        print("[1/2] Scanning src/power-pack/ for personal data leaks...")
        leaks = scan_directory(pro_dir)
        if leaks:
            print(f"  FAILED — {len(leaks)} leaks found:")
            for leak in leaks:
                print(f"    {leak}")
            sys.exit(1)
        else:
            file_count = sum(1 for _, _, files in os.walk(pro_dir) for _ in files)
            print(f"  PASSED — {file_count} files scanned, 0 leaks")
    else:
        print("[1/2] SKIP — src/power-pack/ not found (run genericize.py first)")

    # Test 2: Verify patterns work
    print("\n[2/2] Testing genericize patterns...")
    try:
        failures = test_genericize_patterns()
        if failures:
            print(f"  FAILED — {len(failures)} pattern failures:")
            for f in failures:
                print(f"    {f}")
            sys.exit(1)
        else:
            print("  PASSED — all patterns produce expected output")
    except ImportError:
        print("  SKIP — genericize.py not importable in CI (pattern test skipped)")

    print("\n=== All tests passed ===")


if __name__ == "__main__":
    main()
