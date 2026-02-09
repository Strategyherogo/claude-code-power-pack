# Skill: api-test
Quick API endpoint testing — hit endpoints, inspect responses, validate schemas.

## Auto-Trigger
**When:** "test endpoint", "hit api", "curl", "api test", "test this endpoint"

## Workflow

### Quick Test
```bash
# GET
curl -s -w "\n---\nHTTP %{http_code} | %{time_total}s | %{size_download} bytes\n" \
  -H "Content-Type: application/json" \
  "[URL]" | jq '.'

# POST
curl -s -w "\n---\nHTTP %{http_code} | %{time_total}s\n" \
  -X POST \
  -H "Content-Type: application/json" \
  -d '[JSON_BODY]' \
  "[URL]" | jq '.'
```

### Auth Patterns
```bash
# Bearer token
-H "Authorization: Bearer $TOKEN"

# API key header
-H "X-API-Key: $API_KEY"

# Basic auth
-u "user:password"

# Jira (from env)
-u "$JIRA_EMAIL:$JIRA_API_TOKEN"
```

### Response Validation
After hitting endpoint, check:
1. Status code (2xx = success)
2. Response time (< 500ms = good, < 1s = ok, > 1s = slow)
3. JSON structure (valid JSON, expected fields present)
4. Error messages (if non-2xx)

### Batch Test
Test multiple endpoints in sequence:
```bash
ENDPOINTS=(
  "GET https://api.example.com/health"
  "GET https://api.example.com/users"
  "POST https://api.example.com/auth/token"
)

for ep in "${ENDPOINTS[@]}"; do
  METHOD=$(echo $ep | cut -d' ' -f1)
  URL=$(echo $ep | cut -d' ' -f2)
  echo "--- $METHOD $URL ---"
  curl -s -o /dev/null -w "HTTP %{http_code} | %{time_total}s\n" -X $METHOD "$URL"
done
```

### Save & Compare
```bash
# Save response for comparison
curl -s "[URL]" | jq '.' > /tmp/api-response-$(date +%H%M).json

# Diff with previous
diff /tmp/api-response-*.json
```

---

*Last updated: 2026-02-07*
