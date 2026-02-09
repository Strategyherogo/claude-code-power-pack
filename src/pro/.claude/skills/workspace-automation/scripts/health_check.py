#!/usr/bin/env python3
"""
Health check script for services and infrastructure.
"""

import subprocess
import json
from datetime import datetime

def check_endpoint(url: str, timeout: int = 5) -> dict:
    """Check if HTTP endpoint responds."""
    try:
        result = subprocess.run(
            ["curl", "-s", "-o", "/dev/null", "-w", "%{http_code},%{time_total}", url],
            capture_output=True, text=True, timeout=timeout
        )
        code, time = result.stdout.strip().split(",")
        return {"status": "ok" if code.startswith("2") else "error", "code": code, "time_ms": float(time) * 1000}
    except Exception as e:
        return {"status": "error", "error": str(e)}

def check_command(cmd: list[str], timeout: int = 10) -> dict:
    """Check if command succeeds."""
    try:
        result = subprocess.run(cmd, capture_output=True, text=True, timeout=timeout)
        return {"status": "ok" if result.returncode == 0 else "error", "returncode": result.returncode}
    except Exception as e:
        return {"status": "error", "error": str(e)}

def run_health_checks(config: dict) -> dict:
    """Run all configured health checks."""
    results = {"timestamp": datetime.now().isoformat(), "checks": {}}

    for name, check in config.get("endpoints", {}).items():
        results["checks"][name] = check_endpoint(check["url"], check.get("timeout", 5))

    for name, check in config.get("commands", {}).items():
        results["checks"][name] = check_command(check["cmd"], check.get("timeout", 10))

    # Summary
    ok = sum(1 for c in results["checks"].values() if c.get("status") == "ok")
    total = len(results["checks"])
    results["summary"] = {"ok": ok, "total": total, "healthy": ok == total}

    return results

# Default config - customize per project
DEFAULT_CONFIG = {
    "endpoints": {
        "cloudflare_api": {"url": "https://api.cloudflare.com/client/v4/", "timeout": 5},
    },
    "commands": {
        "git": {"cmd": ["git", "--version"]},
        "node": {"cmd": ["node", "--version"]},
        "python": {"cmd": ["python3", "--version"]},
    }
}

if __name__ == "__main__":
    import sys
    config_file = sys.argv[1] if len(sys.argv) > 1 else None

    if config_file:
        config = json.loads(open(config_file).read())
    else:
        config = DEFAULT_CONFIG

    results = run_health_checks(config)
    print(json.dumps(results, indent=2))

    # Exit with error if unhealthy
    sys.exit(0 if results["summary"]["healthy"] else 1)
