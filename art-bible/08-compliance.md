# 08 — Compliance matrix

Measured 2026-11-18 against 00-07. Numbers, not impressions.

## Compliant
- Art bible exists as of this session (nine files, 00-07 plus README).
- WebP used throughout, 136 files, no stray formats.
- Gallery code path exists (P4 step 3, claude).

## Partial
- Nude coverage 33 of 37. The player's four classes (sage, merchant, warrior,
  rogue) share one nude anchor; class reads in cloth, accessory, light and FX.
- Renderer is a working hand-rolled canvas 2D loop. Functions, but has no
  camera, scene or atlas layer (Q10).

## Non-compliant
- CG width 1024-1248 across all 66. Bible demands 3840 master. Zero files at
  1920 or above.
- CG aspect 3:2 on every file. Bible sets 16:9 master with composed crops.
- Portrait width max 1248. Bible sets 2048 master.
- One size per asset. No 1280/1920/2560/3840 ladder, no 512/1024 ladder.

## Missing
- Masters. Every existing file is delivery-size; nothing exists to re-derive from.
- T-pose and P-pose anchors, all variants.
- Ethnic variant anchors.
- Expression sheets.
- Asset registry.
- Mob anchors: 33 realms, own body each, silhouette first.
- Boss anchors: 33 realms, separate order of threat from the mobs.
- Mob and boss sprites entirely.
- AVIF at all. No fallback chain.

## Risky
- Regenerating 136 assets without masters means the current art is the only
  copy. Archive before any replacement pass.
- 3:2 to 16:9 is a re-frame, not a resize. Every CG is recomposed, not cropped.

## Needs human input
- Which of the 33 nude portraits survive the rebuild.
- Realm 34 (Haven) has no CG at all. Its key prop is unwritten.
- Explicitness per realm is a lore call per realm, not one global setting.
