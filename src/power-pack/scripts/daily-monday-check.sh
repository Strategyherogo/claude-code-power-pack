#!/bin/bash
# Daily Monday.com Check
# Shows boards with stuck items

# Validate token
if [ -z "$MONDAY_API_TOKEN" ]; then
    echo "❌ MONDAY_API_TOKEN not set"
    echo "   Add to ~/.zshrc: export MONDAY_API_TOKEN='your-token'"
    exit 1
fi

python3 << 'PYEOF'
import urllib.request
import json
import os

token = os.environ.get('MONDAY_API_TOKEN', '')
if not token:
    print("MONDAY_API_TOKEN not set")
    exit(1)

data = json.dumps({'query': '''{
    boards(ids: [5075669294, 5090410974, 5090410362]) {
        name
        items_page(limit: 30) {
            items { name column_values { text } }
        }
    }
}'''}).encode('utf-8')

req = urllib.request.Request(
    'https://api.monday.com/v2',
    data=data,
    headers={'Authorization': token, 'Content-Type': 'application/json'}
)

try:
    with urllib.request.urlopen(req) as response:
        result = json.loads(response.read().decode('utf-8'))

        print("📋 Monday Daily Check\n")

        for board in result['data']['boards']:
            stuck = []
            working = []

            for item in board['items_page']['items']:
                for cv in item['column_values']:
                    if cv['text'] == 'Stuck':
                        stuck.append(item['name'])
                    elif cv['text'] == 'Working on it':
                        working.append(item['name'])

            if stuck or working:
                print(f"## {board['name']}")
                if stuck:
                    print(f"  🔴 Stuck: {len(stuck)}")
                    for item in stuck[:3]:
                        print(f"     - {item[:50]}")
                if working:
                    print(f"  🔄 In Progress: {len(working)}")
                print()

except Exception as e:
    print(f"Error: {e}")
PYEOF
