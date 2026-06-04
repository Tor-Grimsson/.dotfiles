---
name: glif-art
description: Generate AI images via the GLIF platform (uses the glif MCP), with style references from the KOL art-print CDN. Use for AI image generation, glif runs, or styled image creation.
---

# GLIF Image Generation Skill

Generate AI images using the GLIF platform, with style references from the KOL art print CDN.

## Prerequisites

- GLIF API token configured in `~/.claude.json` under `mcpServers.glif.env.GLIF_API_TOKEN`
- Credits available at [glif.app/settings](https://glif.app/settings)

## Important: MCP Server Bug

The `@glifxyz/glif-mcp-server` has a validation bug — `glif_info` and `run_glif` tools fail with `deletionReason` schema errors. **Use curl directly instead.**

Working MCP tools: `search_glifs`, `list_featured_glifs`, `my_glifs`
Broken MCP tools: `glif_info`, `run_glif`

## API Call Pattern

```bash
curl -s \
  -H "Authorization: Bearer $GLIF_API_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"id": "<GLIF_ID>", "inputs": [...]}' \
  'https://simple-api.glif.app'
```

Read the token from `~/.claude.json` → `mcpServers.glif.env.GLIF_API_TOKEN`.

## Recommended Glifs

### Nano Banana Pro — Style References (best for KOL prints)
- **ID:** `cmi7zv3zf0000kz04qjv58j3t`
- **Cost:** ~16.6 credits/run
- **Use case:** Generate new artwork from 1-4 style reference images + text prompt
- **Inputs (ordered array):**
  1. Text prompt describing desired output
  2. Style reference URLs — comma-separated for multiple images
  3. Aspect ratio — `"2:3"`, `"3:2"`, `"1:1"`, `"16:9"`, `"9:16"`
  4. Resolution — `"1K"` or `"2K"`
- **Example:**
```bash
curl -s -H "Authorization: Bearer $TOKEN" -H "Content-Type: application/json" -d '{
  "id": "cmi7zv3zf0000kz04qjv58j3t",
  "inputs": [
    "Dark abstract geometric art print, brutalist composition",
    "https://cdn-url/image1.jpg, https://cdn-url/image2.jpg, https://cdn-url/image3.jpg",
    "2:3",
    "2K"
  ]
}' 'https://simple-api.glif.app'
```

### Nano Banana Pro Edit — Image-to-Image
- **ID:** `cmi7nb3vd0000l804jfykbdrd`
- **Cost:** ~16.5 credits/run
- **Use case:** Restyle an existing image while preserving composition
- **Inputs (ordered array):**
  1. Source image URL
  2. Edit prompt describing desired style change
- **Example:**
```bash
curl -s -H "Authorization: Bearer $TOKEN" -H "Content-Type: application/json" -d '{
  "id": "cmi7nb3vd0000l804jfykbdrd",
  "inputs": [
    "https://cdn-url/source-image.jpg",
    "Restyle as a risograph print with halftone texture"
  ]
}' 'https://simple-api.glif.app'
```

### Z-Image Turbo — Cheap Text-to-Image
- **ID:** `cmincelxf0000l104qgpz7iaa`
- **Cost:** ~0.58 credits/run
- **Use case:** Quick text-to-image, no style references, 1024x1024
- **Inputs:** Single text prompt

## KOL Art Print CDN URLs

Source images for style references. Available at 2840px and 1700px.

**Pattern:** `https://f005.backblazeb2.com/file/kolkrabbi/website/art-prints/print-{slug}/artwork/{slug}-artwork-{size}.jpg`

**Sizes:** `2840` (high-res), `1700` (standard)

**Available prints:** blokk, skovia, midnight, midday, fvv, weissensee, tangents, faust, timi-01, timi-02, timi-03, timi-04, mytar, borg, traum, uburoi, skinnalon, hornhimna, himnuhorn, himbrak, trolla, myrkvi, frank, launrad

**Example:** `https://f005.backblazeb2.com/file/kolkrabbi/website/art-prints/print-faust/artwork/faust-artwork-2840.jpg`

## Glifs to Avoid

- **Flux Pro 1.1 Ultra remix** (`cm7mth5ox000ekwm8bhezg6rq`) — costs ~5.9 credits, uses "describe then generate" pipeline, does NOT visually reference source image
- **bad xerox flux** (`clzr3srjn000u9tc2doce7xp9`) — same problem, uses LLM text description, output has no visual resemblance to input

## Output Handling

Response JSON contains `output` (image URL) and `outputFull` (with width/height). Download with:

```bash
curl -sL -o output-file.png "<output_url>"
```

Save outputs to `apps/video/output/`.

## Tips

- Use 1700px CDN images as style refs (faster processing, sufficient quality)
- For portrait art prints use `"2:3"` aspect ratio
- `"5:7"` aspect ratio is NOT supported — gets overridden to `"3:2"`
- Multiple style refs are comma-separated in a single string, not separate inputs
- 2K resolution roughly doubles dimensions vs 1K
- Budget ~17 credits per Nano Banana run
