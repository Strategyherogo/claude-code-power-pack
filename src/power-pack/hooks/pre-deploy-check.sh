#!/bin/bash
# Pre-Deploy Credential Check Hook
# Runs on PreToolUse for Bash - catches deploy/push/publish commands
# Warns if credentials aren't verified for the target service

INPUT=$(cat)
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // "unknown"')

# Only check Bash tool calls
[ "$TOOL_NAME" != "Bash" ] && exit 0

# Extract the command being run
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // ""')

# Check if this is a deploy/publish/push command
IS_DEPLOY=0
case "$COMMAND" in
    *"forge deploy"*|*"forge install"*)
        SERVICE="atlassian"
        IS_DEPLOY=1
        ;;
    *"npm publish"*)
        SERVICE="npm"
        IS_DEPLOY=1
        ;;
    *"wrangler deploy"*|*"wrangler publish"*)
        SERVICE="cloudflare"
        IS_DEPLOY=1
        ;;
    *"xcrun altool"*|*"xcrun notarytool"*)
        SERVICE="appstore"
        IS_DEPLOY=1
        ;;
    *"chrome-webstore-upload"*|*"cws-"*)
        SERVICE="chrome"
        IS_DEPLOY=1
        ;;
    *"doctl apps"*)
        SERVICE="digitalocean"
        IS_DEPLOY=1
        ;;
esac

# Skip if not a deploy command
[ "$IS_DEPLOY" -eq 0 ] && exit 0

# Check credentials for the detected service
CRED_OK=1
WARN_MSG=""

case "$SERVICE" in
    atlassian)
        if ! grep -q "JIRA_API_TOKEN\|ATLASSIAN" ~/.zshrc 2>/dev/null && \
           [ -z "$JIRA_API_TOKEN" ]; then
            CRED_OK=0
            WARN_MSG="No JIRA_API_TOKEN found. Check ~/.zshrc or .env"
        fi
        ;;
    npm)
        if ! npm whoami 2>/dev/null >/dev/null; then
            CRED_OK=0
            WARN_MSG="Not logged into npm. Run: npm login"
        fi
        ;;
    cloudflare)
        if [ ! -f ~/.wrangler/config/default.toml ] && [ -z "$CLOUDFLARE_API_TOKEN" ]; then
            CRED_OK=0
            WARN_MSG="No Cloudflare credentials. Run: wrangler login"
        fi
        ;;
    appstore)
        if ! ls ~/.appstoreconnect/private_keys/*.p8 2>/dev/null >/dev/null; then
            CRED_OK=0
            WARN_MSG="No App Store Connect API key (.p8) found"
        fi
        ;;
    chrome)
        if [ ! -f ~/.config/chrome-webstore-upload/config.json ]; then
            CRED_OK=0
            WARN_MSG="No Chrome Web Store config. Run /cred-discover chrome"
        fi
        ;;
    digitalocean)
        if ! doctl account get 2>/dev/null >/dev/null; then
            CRED_OK=0
            WARN_MSG="DigitalOcean not authenticated. Run: doctl auth init"
        fi
        ;;
esac

if [ "$CRED_OK" -eq 0 ]; then
    echo "{\"message\": \"⚠️ DEPLOY PREFLIGHT: $WARN_MSG. Run /preflight $SERVICE to check all requirements.\"}"
fi

exit 0
