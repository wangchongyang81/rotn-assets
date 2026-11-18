# 07 — Anchors

Base bodies. Generated before any costume, expression or CG. Every character
descends from one.

## Why anchors exist
Proportion, silhouette and pose must not be invented per illustration. An
anchor fixes all three once, and every later asset references it.

## The grid
Anchors are variant x sex x pose. Ten variants, two poses, both sexes.

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
- V7 earth — The Pledge of Earth. The whole body read as the world from space:
  blue-grey undertone, pale cloud banding across shoulder and flank, heavy
  shoulder, broad stance.
- V8 moon — The Pledge of the Moon. Both faces at once: bleached pale skin on
  the lit side, hard terminator down the body, cold shadow past it, still face.
- V9 day — The Pledge of Day. Overexposed: sun-bleached, white-gold highlight
  on every upward plane, narrow eye, hard shadow cast at the feet.
- V10 pole — Dhruva. Unmoved: square-set, thick neck, planted feet, vertical
  stance, no sway in the hands.
Mitali is a crossroads; V1 and V4 both pass through it.

## Player
One anchor, both sexes, both poses. Class reads in cloth, accessory, light and
FX — sage, merchant, warrior, rogue. The body does not change with class.

## The set
Two poses per anchor: T-pose and P-pose.
- T-pose: arms level, legs neutral, palms forward. Costume and rig work.
- P-pose: arms at 20 degrees from the body, palms back, weight on one hip.
  Reads as alive; the default for portraits and CGs.

## First batch
V1 and V2 only, both sexes, both poses. Eight anchors. V3 to V10 follow
only after V1 and V2 are approved, so a proportion error is caught on
two variants instead of ten.

## Prompt skeleton
Fixed order, no variation: variant, sex, age band, build, pose, neutral grey
backdrop, full body, front. Then three-quarter, then side, then back.

## Technical
Neutral grey seamless backdrop, no floor shadow, even soft key at 45 degrees,
fill at 25 percent. Master 2048 wide. Face, hands and feet in frame.

## Lock
One model, one seed, one sampler per anchor, saved with it. Every later asset
for that character reuses them. A different seed is a different body.
The record lives in `master/anchors/<id>/lock.json` beside the prompts.

## Approval
Approved on proportion, silhouette, hands and face. A rejected anchor is
regenerated, never patched. Approved anchors go to `master/anchors/` and get
registry rows.

## Derivation
Costume, expression sheets and CGs cite the anchor id. A CG whose body does
not match its anchor fails QC gate 2.

## Mobs
Realms 1-33 only. Haven (34) is fetch-only at tier D. The four class bodies are
never reused as mobs.

- One anchor per mob type, `mob-NN-XX`, realm then index.
- Built from the realm's own climate and labour variant (see Variants),
  then given its own proportion and silhouette so it reads as that realm.
- Neutral stance for the sprite, T-pose for the rig. Two masters, same seed.
- Mobs carry silhouette first: shape, gait, mass. Face detail is secondary.
- A mob anchor serves one mob type only. Sharing across realms is a reject.
- Sprite masters at 1024 wide, atlas on export.

## Bosses
One boss per realm that has one — 33 realms, Haven excepted. Bosses never share
a body with mobs, the player or another realm's boss.

- Id is `boss-NN`, one only, so a second boss in a realm is a lore change.
- Built from the realm variant, then exaggerated away from it: mass, reach or
  height pushed until the silhouette reads as a different order of threat.
- Silhouette first. Face is a mask and may be non-human.
- Front, side and three-quarter masters, T-pose for rig, plus one action pose
  that states the realm's prop or element.
- Sprite master 1536 wide, atlas on export, separate page from mobs.
- A boss that could pass for its realm's mob is a reject.

## Limit
Anchors are bodies, not characters. Hair, face detail and palette come from the
character's ref pack and are applied after approval. A single anchor serves
many characters; that is the point. Mobs and bosses are the exception: one body
each, and never reused.
