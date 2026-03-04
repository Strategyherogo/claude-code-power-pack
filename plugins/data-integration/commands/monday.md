# Skill: monday
Quick Monday.com operations via GraphQL API.

## Auto-Trigger
**When:** "monday", "monday board", "monday items", "check monday", "create monday item"

## Prerequisites
```bash
# Requires MONDAY_API_TOKEN in environment
echo $MONDAY_API_TOKEN | head -c 10  # Should show token prefix
```

## Quick Reference

### List Boards
```bash
curl -s -X POST https://api.monday.com/v2 \
  -H "Authorization: $MONDAY_API_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"query": "{ boards(limit: 10) { id name } }"}' | python3 -m json.tool
```

### Get Board Items
```bash
BOARD_ID="YOUR_MONDAY_BOARD_ID_2"
curl -s -X POST https://api.monday.com/v2 \
  -H "Authorization: $MONDAY_API_TOKEN" \
  -H "Content-Type: application/json" \
  -d "{\"query\": \"{ boards(ids: $BOARD_ID) { items_page(limit: 20) { items { id name } } } }\"}" | python3 -m json.tool
```

### Get Board Columns (Schema)
```bash
BOARD_ID="YOUR_MONDAY_BOARD_ID_2"
curl -s -X POST https://api.monday.com/v2 \
  -H "Authorization: $MONDAY_API_TOKEN" \
  -H "Content-Type: application/json" \
  -d "{\"query\": \"{ boards(ids: $BOARD_ID) { columns { id title type } } }\"}" | python3 -m json.tool
```

### Get Item Details
```bash
ITEM_ID="123456789"
curl -s -X POST https://api.monday.com/v2 \
  -H "Authorization: $MONDAY_API_TOKEN" \
  -H "Content-Type: application/json" \
  -d "{\"query\": \"{ items(ids: $ITEM_ID) { id name column_values { id text value } } }\"}" | python3 -m json.tool
```

### Create Item
```bash
BOARD_ID="YOUR_MONDAY_BOARD_ID_2"
ITEM_NAME="New Task"
curl -s -X POST https://api.monday.com/v2 \
  -H "Authorization: $MONDAY_API_TOKEN" \
  -H "Content-Type: application/json" \
  -d "{\"query\": \"mutation { create_item(board_id: $BOARD_ID, item_name: \\\"$ITEM_NAME\\\") { id } }\"}" | python3 -m json.tool
```

### Create Item with Column Values
```bash
BOARD_ID="YOUR_MONDAY_BOARD_ID_2"
ITEM_NAME="New Task"
# Column values as JSON - escape carefully
COLS='{"status": "Working on it", "text": "Description here"}'
curl -s -X POST https://api.monday.com/v2 \
  -H "Authorization: $MONDAY_API_TOKEN" \
  -H "Content-Type: application/json" \
  -d "{\"query\": \"mutation { create_item(board_id: $BOARD_ID, item_name: \\\"$ITEM_NAME\\\", column_values: \\\"$(echo $COLS | sed 's/"/\\\\"/g')\\\") { id } }\"}" | python3 -m json.tool
```

### Update Item Column
```bash
ITEM_ID="123456789"
BOARD_ID="YOUR_MONDAY_BOARD_ID_2"
COLUMN_ID="status"
VALUE='{"label": "Done"}'
curl -s -X POST https://api.monday.com/v2 \
  -H "Authorization: $MONDAY_API_TOKEN" \
  -H "Content-Type: application/json" \
  -d "{\"query\": \"mutation { change_column_value(item_id: $ITEM_ID, board_id: $BOARD_ID, column_id: \\\"$COLUMN_ID\\\", value: \\\"$(echo $VALUE | sed 's/"/\\\\"/g')\\\") { id } }\"}" | python3 -m json.tool
```

### Search Items
```bash
SEARCH="project name"
curl -s -X POST https://api.monday.com/v2 \
  -H "Authorization: $MONDAY_API_TOKEN" \
  -H "Content-Type: application/json" \
  -d "{\"query\": \"{ items_page_by_column_values(board_id: YOUR_MONDAY_BOARD_ID_2, columns: [{column_id: \\\"name\\\", column_values: [\\\"$SEARCH\\\"]}], limit: 10) { items { id name } } }\"}" | python3 -m json.tool
```

### Get My Info
```bash
curl -s -X POST https://api.monday.com/v2 \
  -H "Authorization: $MONDAY_API_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"query": "{ me { id name email } }"}' | python3 -m json.tool
```

## Known Boards

| Board ID | Name | Purpose |
|----------|------|---------|
| YOUR_MONDAY_BOARD_ID | Main Dashboard | Master overview of all directions |
| YOUR_MONDAY_BOARD_ID_2 | IT & Nmore | IT Projects |
| YOUR_MONDAY_BOARD_ID_3 | Cybersecurity | Security tasks |

## Column Types Reference

| Type | Value Format |
|------|--------------|
| status | `{"label": "Done"}` or `{"index": 1}` |
| text | `"plain text"` |
| date | `{"date": "2026-01-29"}` |
| people | `{"personsAndTeams": [{"id": 12345, "kind": "person"}]}` |
| timeline | `{"from": "2026-01-01", "to": "2026-01-31"}` |
| numbers | `"42"` |
| checkbox | `{"checked": "true"}` |

## Python Helper (if needed)

```python
import requests
import os
import json

def monday_query(query):
    """Execute Monday.com GraphQL query"""
    response = requests.post(
        'https://api.monday.com/v2',
        headers={
            'Authorization': os.environ['MONDAY_API_TOKEN'],
            'Content-Type': 'application/json'
        },
        json={'query': query}
    )
    return response.json()

# Example: List boards
result = monday_query('{ boards(limit: 5) { id name } }')
print(json.dumps(result, indent=2))
```

## Troubleshooting

### Token Issues
```bash
# Check token is set
[ -n "$MONDAY_API_TOKEN" ] && echo "Token set" || echo "Token missing"

# Test auth
curl -s -X POST https://api.monday.com/v2 \
  -H "Authorization: $MONDAY_API_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"query": "{ me { name } }"}' | python3 -m json.tool
```

### MCP Status
```
Monday MCP package (@mondaydotcomorg/monday-api-mcp) has known issues:
- Missing @modelcontextprotocol/sdk dependency
- isolated-vm fails on Node 25
- Use direct API instead (this skill)
```

## Quick Actions

### Daily Standup Check
```bash
# Get items assigned to me, updated recently
curl -s -X POST https://api.monday.com/v2 \
  -H "Authorization: $MONDAY_API_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"query": "{ boards(limit: 5) { name items_page(limit: 5, query_params: {order_by: [{column_id: \"__last_updated__\", direction: desc}]}) { items { id name updated_at } } } }"}' | python3 -m json.tool
```

## API Gotchas

### Status column labels are IMMUTABLE after creation
- `change_column_metadata` only accepts `title` and `description` as ColumnProperty
- `change_simple_column_value` rejects unknown label names — no auto-create
- **Fix:** Delete old column → create new one with `defaults` parameter:
```python
defaults = json.dumps({
    "labels": {"0": "Label A", "1": "Label B"},
    "done_colors": [1],
    "labels_colors": {
        "0": {"color": "#fdab3d", "border": "#e99729", "var_name": "orange"},
        "1": {"color": "#00c875", "border": "#00b461", "var_name": "green-shadow"}
    }
})
# create_column(board_id, title, column_type: status, defaults: defaults)
```

### New boards auto-create "Task 1" placeholder
- Delete it after board creation: `delete_item(item_id: <id>)`

### curl fails with $MONDAY_API_TOKEN
- Token contains characters that break shell quoting
- **Fix:** Use Python `requests` instead of curl

---
Last updated: 2026-02-06
Note: Using direct API because MCP package is broken
