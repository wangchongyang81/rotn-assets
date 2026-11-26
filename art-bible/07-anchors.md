# 07 — Anchors

Base bodies. Generated before any costume, expression or CG. Every character
descends from one.

## Why anchors exist
Proportion, silhouette and stance must not be invented per illustration. An
anchor fixes all three once, and every later asset references it.

## The grid
Anchors are variant and sex. Ten variants. Companions are female only; the
player is male only.

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
Male only. One anchor. Class reads in cloth, accessory, light and FX — sage,
merchant, warrior, rogue. The body does not change with class.

## Companions
Female only, realms 1-33, one per realm. The body comes from the realm's own
variant; hair, face and palette come from the character's ref pack.

## Setting
No studio backdrop. Each anchor stands in the realm's own environment as its
prose and world lore describe it: its ground, weather and light.

## Pose
Each pose is the realm's own act — its labour, its element or its prop — performed
naked. A pose that could belong to any realm is a reject. One master per realm;
no alternate of it.
Poses are keyed `[pose.NN]` in the wild dat, one per realm, and the companion
performs her realm's pose. The view is whatever the pose needs. Front view is
not a rule.
Where a prop already sits in the character's body list, it moves here and leaves
the list.

**V1 plains**
- Dhara — kneeling, thighs wide, seed falling from a cupped hand, front low view.
- Kharva — bent double, palms flat on the ground, hips high, hair hanging.
- Mitali — kneeling upright, knees wide, one hand at the pouch, the other at the vulva.
- Chanda — lying back, knees drawn up and apart, moonlight down the belly.
- Diva — sitting back on the heels, thighs open, chin lifted to the sun.
- Chandini — on all fours, chest low, hips high, face to camera.
- Stolen Songs — sitting, one leg folded under, the other out, hand between the thighs.

**V2 plateau**
- Nila — on tiptoe at the rock edge, arms overhead, stretched long.
- Soma — kneeling, head back, nectar poured down the chest.
- Cut Nectar — bent over a stone, arms braced, hips pushed back.
- Pratyusha — crouched, knees apart, elbows on knees, low.
- Rahu's Maw — on all fours, head down, spine dipped, mouth open.
- The One Shadow — one arm raised against the light, hips forward, head turned.

**V3 high cold**
- Vayuni — standing, weight back, arms wide, drape and hair blown.
- Ushasvi — seated in snow, knees up, arms round them, face lifted.
- The Choking — kneeling, head down, hand at the throat, chest arched.
- The Wandering Star — mid-stride, one leg forward, hands at the hips.
- The Pledge of the Pole — standing tall, feet planted wide, chin up, arms at the sides.
- The Pledge of Wind — crouched against the wind, one shoulder forward, thighs apart.

**V4 wet lowland**
- Nishvana — standing in shallow water, feet apart, hands at the vulva.
- Anila — kneeling in the water, thighs apart, water at the hips.
- The Pledge of Earth — crouched, hands in the mud, hips raised.

**V5 forest**
- Roots and Rot — back against a trunk, one knee up, one leg out, hand between the thighs.
- Soma's feral groves — on all fours among the roots, head low, hips high.

**V6 kiln**
- Anala — standing close to the kiln mouth, hips forward, arms back.
- Kravya — sitting on the kiln ledge, legs spread, leaning back on the hands.
- Jvala — kneeling, back arched hard, head back, thighs apart.
- Cold Hearths — lying on the ash floor, one knee raised, forearm across the eyes.
- The Pledge of Flame — one hand on the kiln wall, weight on one hip, other hand at the vulva.

**V7 earth**
- The Pledge of Earth — standing, feet wide, arms low and open, the whole body presenting.

**V8 moon**
- The Pledge of the Moon — half-lit, one side to the light, one arm raised, the other at the thigh.

**V9 day**
- The Pledge of Day — square to the sun, arms slightly out, eyes narrowed, full exposure.

**V10 pole**
- Dhruva — dead still, feet planted, hands at the sides, unblinking.

A pose is a reject if it would suit another realm, if the prop is absent and
unimplied, or if it hides a hand or a foot. The cap is four tags; over four and
the body stops listening.
## Sequence
Nude first, always. The nude master is the body record: it renders and approves
before any cloth exists. Clothed portraits, sprites and CGs derive from it and
never substitute for it. A clothed render on an unapproved body is wasted work.

## First batch
Three anchors: the V1 and V2 companions, nude, plus the player, nude. V3 to V10
follow only after those approve, so a proportion error is caught on two
variants instead of ten.

## Technical
Nude, in the realm environment. Master 2048 wide. Face, hands and feet in frame.

## Approval
Approved on proportion, silhouette, hands and face, nude and unclothed by
costume. A rejected anchor is regenerated, never patched. Approved anchors go
to `master/anchors/` and get registry rows. Cloth is a separate pass on an
approved body.

## Derivation
Costume, expression sheets and CGs cite the anchor id. A CG whose body does
not match its anchor fails QC gate 2.

## Mobs
Realms 1-33 only. Haven (34) is fetch-only at tier D. The four class bodies are
never reused as mobs.

- One anchor per mob type, `mob-NN-XX`, realm then index.
- Built from the realm's own climate and labour variant (see Variants),
  then given its own proportion and silhouette so it reads as that realm.
- Neutral stance. One master, in the realm environment.
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
- One master in the realm environment, posed to state the realm's prop or
  element.
- Sprite master 1536 wide, atlas on export, separate page from mobs.
- A boss that could pass for its realm's mob is a reject.

## Limit
Anchors are bodies, not characters. Hair, face detail and palette come from the
character's ref pack and are applied after approval. A single anchor serves
many characters; that is the point. Mobs and bosses are the exception: one body
each, and never reused.
