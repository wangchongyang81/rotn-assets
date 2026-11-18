# 07 — Anchors

Base bodies. Generated before any costume, expression or CG. Every character
descends from one.

## Why anchors exist
Proportion, silhouette and pose must not be invented per illustration. An
anchor fixes all three once, and every later asset references it.

## The set
Two poses per ethnic variant: T-pose and P-pose.
- T-pose: arms level, legs neutral, palms forward. Costume and rig work.
- P-pose: arms at 20 degrees from the body, palms back, weight on one hip.
  Reads as alive; the default for portraits and CGs.

Variants are the ethnic floor, not a garnish. Each realm's people draw from
the variants its lore names, and no variant is a stand-in for another.

## Prompt skeleton
Fixed, in this order: variant, sex, age band, build, pose, neutral grey
backdrop, full body, front. Then three-quarter, then side, then back.

## Technical
Neutral grey seamless backdrop, no shadow on the floor, even soft key at 45
degrees, fill at 25 percent. Master 2048 wide. Face, hands and feet in frame.

## Lock
One model, one seed, one sampler per anchor. Saved with the anchor. Any asset
for that character reuses them.

## Approval
An anchor is approved on proportion, silhouette, hands and face. A rejected
anchor is regenerated, never patched. Approved anchors go to `rotn-assets`
`master/anchors/` and get registry rows.

## Derivation
Costume variants, expression sheets and CGs cite the anchor id. A CG whose
body does not match its anchor is rejected at QC gate 2.

## Limit
Anchors are bodies, not characters. Hair, face detail and palette come from
the character's ref pack and are applied after the anchor is approved.
