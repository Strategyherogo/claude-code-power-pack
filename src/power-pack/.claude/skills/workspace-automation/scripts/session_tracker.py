#!/usr/bin/env python3
"""
Session tracker for Claude Code workspace automation.
Tracks sessions, triggers automations every N sessions, and logs trigger events.
"""

import json
import hashlib
import os
from datetime import datetime
from pathlib import Path

COUNTER_FILE = Path.home() / "ClaudeCodeWorkspace" / ".session-counter.json"
COUNTER_FILE.parent.mkdir(parents=True, exist_ok=True)

DEFAULT_STATE = {
    "total_sessions": 0,
    "last_health_check": 0,
    "last_sync": 0,
    "last_backup": 0,
    "history": [],
    "trigger_history": []  # New: track when skill triggers fire
}


def load_state() -> dict:
    if COUNTER_FILE.exists():
        state = json.loads(COUNTER_FILE.read_text())
        # Ensure trigger_history exists (migration)
        if "trigger_history" not in state:
            state["trigger_history"] = []
        return state
    return DEFAULT_STATE.copy()


def save_state(state: dict):
    COUNTER_FILE.write_text(json.dumps(state, indent=2))


def start_session(interval: int = 10) -> dict:
    """Start new session, return triggers that should run."""
    state = load_state()

    # Debounce: skip if last session was < 5 minutes ago
    if state["history"]:
        last_ts = state["history"][-1].get("timestamp", "")
        try:
            last_time = datetime.fromisoformat(last_ts)
            if (datetime.now() - last_time).total_seconds() < 300:
                return {
                    "session_number": state["total_sessions"],
                    "triggers": [],
                    "next_automation": interval - (state["total_sessions"] % interval) if state["total_sessions"] % interval else interval,
                    "skipped": "debounce"
                }
        except (ValueError, TypeError):
            pass

    state["total_sessions"] += 1
    n = state["total_sessions"]

    triggers = []

    if n - state["last_health_check"] >= interval:
        triggers.append("health_check")
        state["last_health_check"] = n

    if n - state["last_sync"] >= interval:
        triggers.append("skill_sync")
        state["last_sync"] = n

    if n - state["last_backup"] >= interval:
        triggers.append("backup")
        state["last_backup"] = n

    if n - state.get("last_retro", 0) >= interval:
        triggers.append("auto_retro")
        state["last_retro"] = n

    state["history"].append({
        "session": n,
        "timestamp": datetime.now().isoformat(),
        "triggers": triggers
    })

    # Keep last 100 entries
    state["history"] = state["history"][-100:]

    save_state(state)

    return {
        "session_number": n,
        "triggers": triggers,
        "next_automation": interval - (n % interval) if n % interval else interval
    }


def get_status() -> dict:
    """Get current session status."""
    state = load_state()
    n = state["total_sessions"]
    return {
        "total_sessions": n,
        "since_health_check": n - state["last_health_check"],
        "since_sync": n - state["last_sync"],
        "since_backup": n - state["last_backup"],
        "last_5_sessions": state["history"][-5:]
    }


def log_trigger_event(tier: int, skill: str, input_text: str, keywords_matched: list = None) -> dict:
    """
    Log when a skill trigger fires.

    Args:
        tier: 1 (blocking), 2 (suggest), 3 (convenience)
        skill: The skill command (e.g., "/deploy-verify")
        input_text: The user input that triggered it
        keywords_matched: List of keywords that matched

    Returns:
        The logged event
    """
    state = load_state()

    # Hash the input for privacy (don't store full text)
    input_hash = hashlib.sha256(input_text.encode()).hexdigest()[:16]

    event = {
        "timestamp": datetime.now().isoformat(),
        "session": state["total_sessions"],
        "tier": tier,
        "skill": skill,
        "input_hash": input_hash,
        "input_length": len(input_text),
        "keywords": keywords_matched or []
    }

    state["trigger_history"].append(event)

    # Keep last 500 trigger events
    state["trigger_history"] = state["trigger_history"][-500:]

    save_state(state)

    return event


def get_trigger_analytics() -> dict:
    """
    Get analytics on trigger usage.

    Returns:
        Stats on which skills are triggered most, by tier, etc.
    """
    state = load_state()
    history = state.get("trigger_history", [])

    if not history:
        return {
            "total_triggers": 0,
            "by_tier": {"1": 0, "2": 0, "3": 0},
            "by_skill": {},
            "recent_triggers": []
        }

    # Count by tier
    by_tier = {"1": 0, "2": 0, "3": 0}
    by_skill = {}

    for event in history:
        tier = str(event.get("tier", 0))
        skill = event.get("skill", "unknown")

        if tier in by_tier:
            by_tier[tier] += 1

        if skill not in by_skill:
            by_skill[skill] = 0
        by_skill[skill] += 1

    # Sort skills by count
    top_skills = sorted(by_skill.items(), key=lambda x: -x[1])[:10]

    return {
        "total_triggers": len(history),
        "by_tier": by_tier,
        "by_skill": dict(top_skills),
        "recent_triggers": history[-10:]
    }


def clear_trigger_history() -> dict:
    """Clear trigger history (for testing/reset)."""
    state = load_state()
    count = len(state.get("trigger_history", []))
    state["trigger_history"] = []
    save_state(state)
    return {"cleared": count}


if __name__ == "__main__":
    import sys
    cmd = sys.argv[1] if len(sys.argv) > 1 else "start"

    if cmd == "start":
        result = start_session()
        print(f"Session #{result['session_number']} started")
        if result["triggers"]:
            print(f"Triggers: {', '.join(result['triggers'])}")
        print(f"Next automation in {result['next_automation']} sessions")

    elif cmd == "status":
        status = get_status()
        print(json.dumps(status, indent=2))

    elif cmd == "trigger-analytics":
        analytics = get_trigger_analytics()
        print(json.dumps(analytics, indent=2))

    elif cmd == "log-trigger":
        # Usage: session_tracker.py log-trigger <tier> <skill> <input>
        if len(sys.argv) >= 5:
            tier = int(sys.argv[2])
            skill = sys.argv[3]
            input_text = sys.argv[4]
            keywords = sys.argv[5].split(",") if len(sys.argv) > 5 else []
            event = log_trigger_event(tier, skill, input_text, keywords)
            print(json.dumps(event, indent=2))
        else:
            print("Usage: session_tracker.py log-trigger <tier> <skill> <input> [keywords]")

    elif cmd == "clear-triggers":
        result = clear_trigger_history()
        print(json.dumps(result, indent=2))

    else:
        print("Usage: session_tracker.py [start|status|trigger-analytics|log-trigger|clear-triggers]")
