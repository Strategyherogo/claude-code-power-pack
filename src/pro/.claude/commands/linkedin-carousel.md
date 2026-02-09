# Skill: LinkedIn Carousel Creator

Create professional LinkedIn carousel PDFs from lesson/content slides.

## Trigger
- "create carousel"
- "linkedin carousel"
- "make slides"

## Process

### 1. Content Structure
Create 6-8 slides following this pattern:
- **Slide 1:** Hook/Title (grab attention)
- **Slides 2-7:** Lessons/Content (one idea per slide)
- **Slide 8:** CTA (call to action)

### 2. Create Individual HTML Slides

Each slide uses this template:

```html
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <style>
    @import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;700;900&family=JetBrains+Mono:wght@500&display=swap');
    * { margin: 0; padding: 0; box-sizing: border-box; }
    body {
      width: 1080px;
      height: 1350px;
      font-family: 'Inter', -apple-system, sans-serif;
      background: linear-gradient(160deg, #1a1a2e 0%, #16213e 50%, #0f0f23 100%);
      color: #fff;
      display: flex;
      flex-direction: column;
      justify-content: center;
      align-items: center;
      text-align: center;
      padding: 80px;
    }
    .lesson {
      font-size: 20px;
      color: #818cf8;
      letter-spacing: 4px;
      margin-bottom: 50px;
      text-transform: uppercase;
      font-weight: 700;
    }
    h1 {
      font-size: 64px;
      font-weight: 900;
      line-height: 1.2;
      margin-bottom: 60px;
    }
    p {
      font-size: 30px;
      color: #94a3b8;
      line-height: 1.6;
    }
    .code {
      background: #0d1117;
      border: 2px solid #30363d;
      border-radius: 16px;
      padding: 35px 50px;
      margin: 30px 0;
      font-family: 'JetBrains Mono', monospace;
      font-size: 28px;
      color: #7ee787;
    }
    .stat-box {
      background: rgba(129, 140, 248, 0.15);
      border: 2px solid rgba(129, 140, 248, 0.3);
      border-radius: 16px;
      padding: 25px 45px;
    }
    .stat-num {
      font-size: 48px;
      font-weight: 900;
      color: #818cf8;
    }
    .cta {
      background: linear-gradient(135deg, #6366f1 0%, #8b5cf6 100%);
      padding: 40px 60px;
      border-radius: 20px;
      margin-top: 50px;
    }
  </style>
</head>
<body>
  <!-- SLIDE CONTENT HERE -->
</body>
</html>
```

### 3. Screenshot Each Slide

```bash
# Create slides directory
mkdir -p marketing/slides

# Screenshot each slide (1080x1350 = LinkedIn 4:5 ratio)
for i in 1 2 3 4 5 6 7 8; do
  "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" \
    --headless \
    --disable-gpu \
    --screenshot="slide${i}.png" \
    --window-size=1080,1350 \
    --hide-scrollbars \
    "file://$(pwd)/slide${i}.html"
done
```

### 4. Combine into PDF

```python
from PIL import Image
import os

images = []
for i in range(1, 9):
    img = Image.open(f"slide{i}.png").convert('RGB')
    images.append(img)

images[0].save("linkedin-carousel.pdf", save_all=True, append_images=images[1:])
```

### 5. Upload to LinkedIn
1. Create new post
2. Click document/carousel icon
3. Upload the PDF
4. Each page becomes a swipeable slide

## Design Guidelines

### Dimensions
- **Size:** 1080 x 1350px (4:5 ratio)
- **Safe area:** 80px padding on all sides

### Colors (Dark Theme)
- Background: `#1a1a2e` → `#0f0f23` gradient
- Text: `#ffffff`
- Muted text: `#94a3b8`
- Accent: `#818cf8` (purple)
- Code: `#7ee787` (green)
- Error: `#f85149` (red)

### Typography
- Headlines: Inter, 64-72px, weight 900
- Body: Inter, 28-32px, weight 400
- Code: JetBrains Mono, 24-28px, weight 500
- Tags: 20px, uppercase, letter-spacing 4px

### Content Rules
- One idea per slide
- Max 3-4 lines of text
- Code blocks should be short (2-4 lines)
- Use stats/numbers when possible
- End with question to drive engagement

## Example Output

```
marketing/
├── slides/
│   ├── slide1.html
│   ├── slide1.png
│   ├── slide2.html
│   ├── slide2.png
│   └── ... (8 slides)
├── linkedin-carousel.pdf
└── LINKEDIN_CAROUSEL.md (companion post text)
```

## Why This Works

1. **Chrome headless screenshot** preserves exact dimensions (unlike print-to-pdf)
2. **Individual HTML files** allow easy editing of single slides
3. **Pillow PDF creation** maintains image quality and correct page order
4. **4:5 ratio** is optimal for LinkedIn mobile viewing

## Dependencies

- Google Chrome (for headless screenshots)
- Python 3 with Pillow: `pip3 install Pillow`

## Troubleshooting

| Problem | Solution |
|---------|----------|
| Fonts not loading | Add 2-second delay or use system fonts |
| Wrong dimensions | Use screenshot, not print-to-pdf |
| Blurry text | Ensure 1080x1350 window size |
| PDF pages out of order | Sort files numerically before combining |

---

*Last updated: 2026-02-07*
