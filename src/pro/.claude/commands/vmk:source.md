# Skill: vmk:source
Acquire images from AI generation and stock photo services.

## Auto-Trigger
**When:** "stock photo", "generate image", "ai image", "find photo"

## Quick Usage

```bash
# Generate AI image
/vmk:source "modern office workspace" --style photorealistic

# Search stock photos
/vmk:source "team collaboration" --stock unsplash

# Get multiple options
/vmk:source "tech startup" --count 5
```

## Source Selection

| Need | Source | Cost |
|------|--------|------|
| Best quality | Google Imagen 4 | $0.04/image |
| Fast/volume | Google Imagen 4 Fast | $0.02/image |
| 2K resolution | Google Imagen 4 Ultra | $0.08/image |
| Fallback | Stability AI (SDXL) | ~$0.01/image |
| People/faces | Unsplash | Free |
| Backgrounds | Pexels | Free |

## API Integration

### Google Imagen 4 (Recommended)

```python
import google.generativeai as genai

genai.configure(api_key=os.environ["GOOGLE_AI_API_KEY"])

# Standard quality
model = genai.ImageGenerationModel("imagen-4.0-generate-001")
response = model.generate_images(
    prompt="{{PROMPT}}, photorealistic, professional photography, 35mm film",
    number_of_images=1,
    aspect_ratio="16:9",  # or "1:1", "9:16", "4:3", "3:4"
    safety_filter_level="block_only_high"
)

# Save image
response.images[0].save("output.png")
```

**Model Options:**
- `imagen-4.0-fast-generate-001` - Quick, high-volume ($0.02)
- `imagen-4.0-generate-001` - Best quality ($0.04)
- `imagen-4.0-ultra-generate-001` - 2K resolution ($0.08)

### Stability AI (via Replicate) - Fallback

```python
import replicate

output = replicate.run(
    "stability-ai/sdxl:latest",
    input={
        "prompt": "{{PROMPT}}, photorealistic, professional photography",
        "negative_prompt": "artificial, cgi, render, plastic, oversaturated, airbrushed",
        "num_outputs": 1,
        "guidance_scale": 7.5,
        "scheduler": "DDIM"
    }
)
```

### Unsplash API

```bash
curl "https://api.unsplash.com/search/photos?query={{QUERY}}&per_page=10" \
  -H "Authorization: Client-ID $UNSPLASH_ACCESS_KEY"
```

### Pexels API

```bash
curl "https://api.pexels.com/v1/search?query={{QUERY}}&per_page=10" \
  -H "Authorization: $PEXELS_API_KEY"
```

## Natural-Looking Prompt Modifiers

Add to any AI image prompt:

```
Suffix modifiers (pick 2-3):
, shot on 35mm film
, natural lighting
, slight motion blur
, shallow depth of field
, film grain
, candid moment
, environmental portrait
, golden hour
, overcast lighting
```

## Prompt Templates

### App Screenshot Background
```
modern minimalist workspace desk setup,
warm natural lighting from window,
slight depth of field, clean background,
professional photography, 35mm
```

### Blog Hero (Tech)
```
developer working at computer in modern office,
natural window light, candid moment,
environmental portrait, film grain, 85mm lens
```

### Social Media (Business)
```
professional team collaboration meeting,
authentic interaction, natural expressions,
soft lighting, documentary style
```

### Landing Page Hero
```
{{PRODUCT}} in use by happy customer,
lifestyle photography, natural setting,
brand colors visible, premium feel
```

## Output

- Downloaded image(s)
- Source metadata (license, attribution)
- Suggested anti-AI techniques
- Ready for `/vmk:process` pipeline

## Environment Variables

```bash
# Primary - Google Imagen (recommended)
GOOGLE_AI_API_KEY=xxx

# Fallback - Stability AI
REPLICATE_API_TOKEN=r8_xxx

# Stock photos
UNSPLASH_ACCESS_KEY=xxx
PEXELS_API_KEY=xxx
```

## Provider Comparison

| Feature | Google Imagen 4 | Stability SDXL |
|---------|-----------------|----------------|
| Quality | Excellent | Very Good |
| Text rendering | Best-in-class | Good |
| Speed | Fast | Medium |
| Max resolution | 2K (Ultra) | 1024x1024 |
| Watermark | SynthID (invisible) | None |
| Commercial use | Yes | Yes |

**Recommendation:** Use Google Imagen 4 as primary, Stability AI as fallback.

## License Notes

- **Google Imagen**: Commercial use allowed, SynthID watermark
- **Unsplash**: Free, attribution appreciated
- **Pexels**: Free, no attribution required
- **Stability AI**: Commercial use allowed
- **Always check**: Specific image licenses

---
Last updated: 2026-01-27
