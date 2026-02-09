# Chrome Extension Debugging
Troubleshoot and test Chrome extensions.

## Auto-Trigger
**When:** Working on 23-chrome-email-exporter or any Chrome extension

## Quick Debug Steps

### 1. Load Unpacked Extension
1. Open `chrome://extensions/`
2. Enable "Developer mode" (top right)
3. Click "Load unpacked"
4. Select your extension folder

### 2. View Console Logs

**Background Script (Service Worker):**
1. `chrome://extensions/`
2. Find your extension
3. Click "Service Worker" link
4. DevTools opens → Console tab

**Content Script:**
1. Open the webpage where content script runs
2. Right-click → Inspect
3. Console tab (logs from content script appear here)

**Popup:**
1. Click extension icon to open popup
2. Right-click popup → Inspect
3. DevTools for popup opens

### 3. Common Issues

#### "Service worker registration failed"
```javascript
// Check manifest.json
{
  "background": {
    "service_worker": "background.js",
    "type": "module"  // Add if using ES modules
  }
}
```

#### "Cannot read property of undefined"
```javascript
// Content script accessing DOM too early
// Fix: Wait for DOM
document.addEventListener('DOMContentLoaded', () => {
  // Your code here
});
```

#### "Permissions denied"
```json
// manifest.json - add required permissions
{
  "permissions": ["activeTab", "storage", "tabs"],
  "host_permissions": ["https://*.gmail.com/*"]
}
```

### 4. Hot Reload
```bash
# Install extension reloader
npm install -g chrome-extension-reloader

# Or add to manifest.json for dev
"background": {
  "scripts": ["hot-reload.js", "background.js"]
}
```

### 5. Testing
```bash
# Run Playwright tests
npx playwright test --project=chromium

# Manual testing checklist
- [ ] Install fresh (no previous data)
- [ ] Upgrade from previous version
- [ ] Test all permissions flows
- [ ] Test offline behavior
```

## Your Chrome Projects
- **23-chrome-email-exporter** - Export emails from Gmail

## Packaging for Store
```bash
# Create zip for Chrome Web Store
zip -r extension.zip . -x "*.git*" -x "node_modules/*" -x "*.map"
```

---
Last updated: 2026-01-27
