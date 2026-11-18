# 11 — Ref packs

One pack per named character, built from an approved anchor. The pack is what
keeps a character the same character across sprite, bust, CG and thumbnail.

## Gate
No pack starts until its anchor is approved (07). The pack cites the anchor id
and cannot be built from a different body.

## Required
- `anchor` — the approved anchor id, both poses.
- `face` — front, side, three-quarter. Fixed eye design, brow, nose, jaw.
- `hair` — mass, strand groups, highlight placement, colour ramp.
- `palette` — six swatches, named, with the grade locked.
- `body` — proportion sheet against the anchor, silhouette callouts.
- `costume` — full front and back, every layer, seams and closure detail.
- `accessory` — worn, held and laid out, one per item.
- `expression` — eight frames, `neutral` and `ahegao` among them.

## Rules
- Face is drawn before hair. Hair before costume.
- Every image is at master width for its class.
- A pack image carries the character id and part, nothing else.
- Rejected parts are replaced whole, never patched in place.
- The pack lives at `ref/<character-id>/`, flat, numbered by part.

## Variants
Ethnic variant comes from the anchor. A character crossing realms keeps its
original variant; only costume and palette change with the realm.

## Registry
Approval writes one row per part with `locked: true`. Any asset for the
character after that must cite a locked part or fail QC gate 2.
