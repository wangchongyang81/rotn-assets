# 07 — Anchors

Base bodies. Generated before any costume, expression or CG. Every character
descends from one.

## Why anchors exist
Proportion, silhouette and pose must not be invented per illustration. An
anchor fixes all three once, and every later asset references it.

## The grid
Anchors are variant x sex x pose. Six variants, two poses, both sexes.

## Variants
Derived from realm climate and labour, not invented. Each names the realms it
serves.
- V1 plains — Dhara, Kharva, Mitali, Chanda, Diva, Chandini, Stolen Songs.
  Warm-neutral, medium build, heavy work posture.
- V2 plateau — Nila, Soma, Cut Nectar, Pratyusha, Rahu's Maw, The One Shadow.
  Lean, long limb, dry skin.
- V3 high cold — Vayuni, Ushasvi, The Choking, The Wandering Star,
  The Pledge of the Pole, The Pledge of Wind. Short limb, deep chest, weathered
  face, chapped lip.
- V4 wet lowland — Nishvana, Anila, The Pledge of Earth. Softer, heavier,
  strong calf.
- V5 forest — Roots and Rot, Soma's feral groves. Compact, broad, thick forearm.
- V6 kiln — Anala, Kravya, Jvala, Cold Hearths, The Pledge of Flame. Sinewy,
  ash-grey undertone, scarred hand.
Mitali is a crossroads; V1 and V4 both pass through it. Dhruva, The Pledge of
the Moon and The Pledge of Day draw from V1 or V2 by neighbourhood.

## Player
One anchor, both sexes, both poses. Class reads in cloth, accessory, light and
FX — sage, merchant, warrior, rogue. The body does not change with class.

## The set
Two poses per anchor: T-pose and P-pose.
- T-pose: arms level, legs neutral, palms forward. Costume and rig work.
- P-pose: arms at 20 degrees from the body, palms back, weight on one hip.
  Reads as alive; the default for portraits and CGs.

## First batch
V1 and V2 only, both sexes, both poses. Eight anchors. V3 to V6 follow only
after V1 and V2 are approved, so a proportion error is caught on two variants
instead of six.

## Prompt skeleton
Fixed order, no variation: variant, sex, age band, build, pose, neutral grey
backdrop, full body, front. Then three-quarter, then side, then back.

## Technical
Neutral grey seamless backdrop, no floor shadow, even soft key at 45 degrees,
fill at 25 percent. Master 2048 wide. Face, hands and feet in frame.

## Lock
One model, one seed, one sampler per anchor, saved with it. Every later asset
for that character reuses them. A different seed is a different body.

## Approval
Approved on proportion, silhouette, hands and face. A rejected anchor is
regenerated, never patched. Approved anchors go to `master/anchors/` and get
registry rows.

## Derivation
Costume, expression sheets and CGs cite the anchor id. A CG whose body does
not match its anchor fails QC gate 2.

## Limit
Anchors are bodies, not characters. Hair, face detail and palette come from the
character's ref pack and are applied after approval. A single anchor serves many
characters; that is the point.
