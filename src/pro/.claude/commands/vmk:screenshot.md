# Skill: vmk:screenshot
Generate device mockups and App Store screenshots.

## Auto-Trigger
**When:** "app store screenshot", "device mockup", "phone frame", "ipad mockup"

## Quick Usage

```bash
# Generate full set
/vmk:screenshot --app email-converter --all-devices

# Single device
/vmk:screenshot screenshot.png --device "iPhone 15 Pro Max"

# With text overlay
/vmk:screenshot screenshot.png --headline "Convert emails instantly"
```

## Device Specifications

### Apple Devices (App Store Required)

| Device | Size | Safe Area |
|--------|------|-----------|
| iPhone 15 Pro Max | 1290x2796 | 1179x2556 |
| iPhone 15 Pro | 1179x2556 | 1125x2436 |
| iPhone 8 Plus | 1242x2208 | 1125x2001 |
| iPad Pro 12.9" | 2048x2732 | 2048x2688 |
| iPad Pro 11" | 1668x2388 | 1668x2340 |

### Chrome Web Store

| Type | Size |
|------|------|
| Small tile | 440x280 |
| Marquee | 1400x560 |
| Screenshot | 1280x800 or 640x400 |

## Screenshot Set Template

### App Store (5 Screenshots)

```yaml
screenshots:
  1_hero:
    text: "{{APP_TAGLINE}}"
    focus: main_feature
    background: brand_gradient

  2_feature_a:
    text: "{{FEATURE_1}}"
    focus: feature_1_screen
    background: complementary

  3_feature_b:
    text: "{{FEATURE_2}}"
    focus: feature_2_screen
    background: accent

  4_feature_c:
    text: "{{FEATURE_3}}"
    focus: feature_3_screen
    background: neutral

  5_cta:
    text: "Get Started Today"
    focus: onboarding
    background: primary
```

## Background Options

### Gradients
```yaml
gradients:
  brand_primary:
    colors: ["#667eea", "#764ba2"]
    angle: 135
  sunset:
    colors: ["#f093fb", "#f5576c"]
    angle: 45
  ocean:
    colors: ["#4facfe", "#00f2fe"]
    angle: 90
```

### Solid Colors
```yaml
solid:
  light: "#f5f5f7"
  dark: "#1d1d1f"
  brand: "{{BRAND_PRIMARY}}"
```

### Patterns
```yaml
patterns:
  dots: { size: 4, spacing: 20, opacity: 0.1 }
  grid: { size: 40, color: "rgba(0,0,0,0.05)" }
  waves: { amplitude: 20, frequency: 0.02 }
```

## Text Overlay

```yaml
headline:
  font: "SF Pro Display Bold"
  size: 72px
  color: "#ffffff"
  position: top_center
  margin: 100px

subheadline:
  font: "SF Pro Text Regular"
  size: 32px
  color: "rgba(255,255,255,0.8)"
  margin_top: 20px
```

## Capture with Playwright

```javascript
// Capture app screenshots
await page.goto('http://localhost:3000');
await page.setViewportSize({ width: 390, height: 844 });

// Capture each feature
await page.screenshot({
  path: 'screenshots/feature-1.png',
  fullPage: false
});
```

## Device Frame Colors

### iPhone 15 Pro
- Natural Titanium
- Black Titanium
- White Titanium
- Blue Titanium

### iPad Pro
- Space Gray
- Silver

## Workflow

1. **Capture** raw screenshots (Playwright or manual)
2. **Frame** with device mockup
3. **Background** gradient or solid
4. **Text** headline and subheadline
5. **Export** all required sizes
6. **Optimize** file sizes

## Output Structure

```
screenshots/
├── en-US/
│   ├── iPhone_15_Pro_Max/
│   │   ├── 01_hero.png
│   │   ├── 02_feature_a.png
│   │   └── ...
│   ├── iPad_Pro_12.9/
│   │   └── ...
│   └── metadata.json
└── sets/
    └── complete_set_v1.0.zip
```

## Quality Checklist

```
□ Text readable at 50% zoom
□ Important content in safe area
□ Device frame aligned correctly
□ Background complements UI
□ All required sizes generated
□ Under 500KB per image (store limit)

---
Last updated: 2026-01-27
```
