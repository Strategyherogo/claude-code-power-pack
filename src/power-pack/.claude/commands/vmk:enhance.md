# Skill: vmk:enhance
Apply anti-AI detection and naturalization techniques to images.

## Auto-Trigger
**When:** "enhance image", "naturalize", "anti-ai", "make natural"

## Quick Usage

```bash
# Auto-detect and apply
/vmk:enhance image.png

# Specific techniques
/vmk:enhance image.png --grain 12 --lut portra --aberration

# Heavy processing for obvious AI
/vmk:enhance image.png --aggressive
```

## Anti-AI Technique Library

### Layer 1: Surface Imperfections

#### Film Grain
```yaml
technique: film_grain
intensity: 8-12%
size: fine | medium | coarse
distribution: gaussian
```
Effect: Adds natural texture that AI images lack.

#### Chromatic Aberration
```yaml
technique: chromatic_aberration
red_offset: [-2, 0] pixels
blue_offset: [2, 0] pixels
edge_only: true
```
Effect: Simulates lens color fringing.

#### Micro-texture Overlay
```yaml
overlays:
  - paper_texture: 5% opacity
  - subtle_dust: 3% opacity
  - lens_scratch: 2% opacity
  - sensor_noise: 4% opacity
```

### Layer 2: Optical Simulation

#### Depth of Field
```yaml
technique: depth_blur
focal_point: auto_detect
aperture: f/2.8
falloff: natural
```

#### Lens Distortion
```yaml
barrel: 2%
vignette: 15%
softness_edges: true
```

#### Light Leaks
```yaml
presets:
  - golden_edge
  - vintage_warm
  - subtle_flare
opacity: 10-25%
blend_mode: screen
```

### Layer 3: Color Grading

#### Analog Film LUTs
| LUT | Look | Best For |
|-----|------|----------|
| Kodak Portra 400 | Warm, natural skin | People, portraits |
| Fuji Pro 400H | Cool, clean | Products, tech |
| Kodak Ektar 100 | Vibrant, saturated | Landscapes |
| CineStill 800T | Cinematic, tungsten | Night, moody |
| Ilford HP5 | B&W, contrasty | Editorial |

```yaml
lut_application:
  intensity: 60-80%
  preserve_skin: true
```

#### Color Shifts
```yaml
lift_shadows: warm (+5 orange)
gamma_midtones: neutral
gain_highlights: cool (+3 blue)
saturation: -5%
contrast: +3%
```

### Layer 4: Final Touches

#### Sharpening
```yaml
amount: 20-30%
radius: 0.8
threshold: 3
```

#### Export Artifacts
```yaml
format: jpeg
quality: 92  # Slight compression artifacts
```

## Processing Order

```
1. Analyze source (GCV) → determine base adjustments
2. Apply optical simulation (lens effects)
3. Apply color grading (LUT/curves)
4. Add surface imperfections (grain, dust)
5. Final sharpening (gentle)
6. Export with compression
```

## Replicate API Models

| Task | Model | Use |
|------|-------|-----|
| Upscale | `nightmareai/real-esrgan` | 4x resolution |
| Style Transfer | `stability-ai/sdxl` (img2img) | Artistic styles |
| Background Remove | `cjwbw/rembg` | Transparent BG |
| Face Restore | `tencentarc/gfpgan` | Fix AI face artifacts |

## Quality Validation

```
□ No visible AI artifacts (smooth skin, weird hands)
□ Natural color distribution (histogram check)
□ Appropriate noise level
□ No over-sharpening halos
□ Authentic imperfections present
```

## Anti-AI Score

Target: > 75/100

Factors:
- Texture variance (+15)
- Color histogram distribution (+20)
- Edge naturalization (+15)
- Grain presence (+10)
- Chromatic aberration (+10)
- Depth variation (+10)
- Compression artifacts (+5)
- Micro-imperfections (+15)

---
Last updated: 2026-01-27
