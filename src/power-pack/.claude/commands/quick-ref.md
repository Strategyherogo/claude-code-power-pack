---
name: quick-ref
description: "Quick reference for deployment and VMK commands. Use when asking 'how do I deploy' or 'vmk commands' or 'quick reference'."
---

# Quick Reference

## Deploy Apps

```bash
deploy email-converter --testflight    # Beta
deploy email-converter --production    # App Store
deploy email-exporter --production     # Chrome Store
deploy --list                          # See all apps
```

## VMK (Visual Marketing Kit)

```bash
/vmk:source "workspace photo"          # Get stock/AI image
/vmk:enhance image.png                 # Make it look natural
/vmk:screenshot --app email-converter  # App Store screenshots
/vmk:process image.png --preset social # Full pipeline
```

## Presets

| Preset | Output |
|--------|--------|
| `social` | LinkedIn, Twitter, Instagram sizes |
| `app-store` | All iPhone/iPad sizes with frames |
| `blog` | Hero, featured, thumbnail (webp) |

## Anti-AI Quick

```bash
/vmk:enhance image.png --grain 10 --lut portra
```

Adds: film grain + Kodak Portra colors = looks real.

---

*Last updated: 2026-02-07*
