# 01 — Gameplay HD-2D

Renderer rules. `terrain.ts` and `sprites.ts` are the surfaces these govern.

## Layer order
Back to front, fixed: sky → far parallax → mid parallax → ground → ground props
→ actors → foreground framing → weather → UI overlay. Foreground frames the
bottom edge and never crosses the actor's head line.

## Parallax
Three bands maximum. Far moves at 0.15, mid at 0.4, ground at 1.0. Horizontal
drift only; no vertical parallax on flat ground. Bands repeat on a seamless tile
whose edge is not visible in a 16:9 frame.

## Lighting
One key light per region, direction fixed at authoring time and stored in region
data. Holy: high sun, 60 degrees, warm. Dark: low fog-glow, 20 degrees, cold.
Ambient fill never exceeds 35 percent of key. Bloom only on emissive surfaces.

## Atmosphere
Fog, dust, motes and rain draw between actors and foreground. Density caps at
0.45 opacity or ground read suffers. Weather is per-region, not random.

## Scale and perspective
Top-down three-quarter, 2:1 tile ratio, actor height 1.6 tiles. Sprite source at
2x tile then downsampled. No actor scales with depth; ground props may.

## Palette
Per region, from the realm key prop. Six ramp steps, one accent. Holy ramps run
warm-neutral, Dark cold-neutral. Accent never covers more than 8 percent of
frame.

## Readability floor
Actor silhouette must hold against its own region's busiest tile at 1:1. If it
does not, the tile loses contrast, not the actor. Effects never draw over the
health bar or the interact prompt.

## Budget
Draw calls under 220 per frame at 1080p. Atlas pages under 8 per region. No
per-frame allocation in the draw path. Emitters pooled, cap 400 particles.
