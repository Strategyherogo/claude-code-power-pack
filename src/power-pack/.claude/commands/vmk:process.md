# Skill: vmk:process
Transform images into natural-looking marketing assets.

## Auto-Trigger
**When:** "marketing image", "process image", "naturalize image"

## Pipeline

```
SOURCE → ANALYZE → ENHANCE → BRAND → EXPORT
```

## Quick Usage

```bash
# Process with preset
/vmk:process image.png --preset social

# App Store screenshots
/vmk:process screenshot.png --preset app-store

# Custom processing
/vmk:process image.png --grain 10 --lut portra --brand
```

## Presets

### `app-store`
- Device frames (iPhone 15 Pro Max, iPad Pro)
- Gradient backgrounds
- Text overlays
- All required sizes

### `social`
- LinkedIn: 1200x628
- Twitter: 1200x675
- Instagram: 1080x1080, 1080x1920
- Brand overlay

### `blog`
- Hero: 1920x1080
- Featured: 1200x630
- Thumbnail: 400x300
- WebP compression

### `landing`
- High-res hero: 2560x1440
- Retina versions
- Optimized for web

## Anti-AI Techniques

Apply automatically when source is AI-generated:

| Technique | Effect | Default |
|-----------|--------|---------|
| Film grain | Natural texture | 10% |
| Chromatic aberration | Lens imperfection | 1.5px |
| Analog LUT | Film color (Portra 400) | 70% |
| Texture overlay | Dust/scratches | 3% |
| Depth blur | Focus falloff | Auto |

## Processing Steps

### 1. Analyze Source
```python
# Using Google Cloud Vision
from google.cloud import vision
client = vision.ImageAnnotatorClient()
# Detect: labels, colors, faces, objects
# Determine: AI-generated vs photo vs stock
# Note: Imagen 4 images have invisible SynthID watermark
```

### 2. Generate/Acquire (if needed)
```python
# Using Google Imagen 4 (recommended)
import google.generativeai as genai

genai.configure(api_key=os.environ["GOOGLE_AI_API_KEY"])
model = genai.ImageGenerationModel("imagen-4.0-generate-001")

response = model.generate_images(
    prompt="{{PROMPT}}, photorealistic, 35mm film",
    aspect_ratio="16:9"
)
```

### 3. Apply Enhancements
```python
# Upscale if needed (Replicate)
import replicate
replicate.run("nightmareai/real-esrgan:latest", input={"image": img})

# Apply film LUT and grain via PIL/OpenCV
# See /vmk:enhance for techniques
```

### 3. Add Brand Elements
- Color overlay (brand primary, 20% opacity)
- Logo placement (if specified)
- Typography (brand fonts)

### 4. Export Formats
Generate all sizes for selected preset.

## Quality Checklist

```
□ Anti-AI score > 75 (if AI source)
□ Natural histogram distribution
□ No over-sharpening halos
□ Brand colors integrated naturally
□ All format sizes generated
□ File sizes optimized
```

## Related Skills

- `/vmk:source` - Acquire images
- `/vmk:enhance` - Anti-AI techniques
- `/vmk:screenshot` - Device mockups
- `/vmk:brand` - Apply branding
- `/vmk:batch` - Bulk processing

---
Last updated: 2026-01-27
