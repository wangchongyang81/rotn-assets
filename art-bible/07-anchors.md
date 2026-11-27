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
- V1 plains — Mitali, Chandini, Diva, Vrata, Dhata, Arya, Maitri, Varuni, Bhagya, Pushpa, Savitri.
- V2 plateau — Nila, Ushasvi, Prabha.
- V3 high cold — Vayuni.
- V4 wet lowland — Nishitha, Vama.
- V5 forest — Rutu, Bhavani, Vamika.
- V6 kiln — Jvala, Raudri, Ugra, Takshi, Vasha.
- V7 earth — Vidhi, Mahati, Prakriti.
- V8 moon — Gauri, Vaishnavi.
- V9 day — Sachi, Varchas.
- V10 pole — Kalyani.
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
- Mitali — kneeling, thighs wide, seed falling from a cupped hand, front low view.
- Chandini — kneeling upright, knees wide, one hand at the pouch, other hand at the vulva.
- Diva — lying back, knees drawn up and apart, moonlight down the belly.
- Vrata — crouched against the wind, one shoulder forward, thighs apart.
- Dhata — standing in shallow water, feet apart, hands at the vulva.
- Arya — kneeling in the water, thighs apart, water at the hips.
- Maitri — crouched, hands in the mud, hips raised.
- Varuni — back against a trunk, one knee up, one leg out, hand between the thighs.
- Bhagya — standing close to the kiln mouth, hips forward, arms back.
- Pushpa — kneeling, back arched hard, head back, thighs apart.
- Savitri — lying on the ash floor, one knee raised, forearm across the eyes.

**V2 plateau**
- Nila — bent double, palms flat on the ground, hips high, hair hanging.
- Ushasvi — sitting, one leg folded under, other leg out, hand between the thighs.
- Prabha — on tiptoe at the rock edge, arms overhead, stretched long.

**V3 high cold**
- Vayuni — sitting back on the heels, thighs open, chin lifted.

**V4 wet lowland**
- Nishitha — crouched, knees apart, elbows on knees, low angle.
- Vama — standing tall, feet planted wide, chin up, arms at the sides.

**V5 forest**
- Rutu — standing, weight back, arms wide, hair blown.
- Bhavani — kneeling, head down, hand at the throat, chest arched.
- Vamika — half-lit, one side to the light, one arm raised, other hand at the thigh.

**V6 kiln**
- Jvala — on all fours, chest low, hips high, face to camera.
- Raudri — kneeling, head back, nectar poured down the chest.
- Ugra — seated in snow, knees up, arms round them, face lifted.
- Takshi — one hand on the kiln wall, weight on one hip, other hand at the vulva.
- Vasha — dead still, feet planted, hands at the sides, unblinking.

**V7 earth**
- Vidhi — bent over a stone, arms braced, hips pushed back.
- Mahati — on all fours, head down, spine dipped, mouth open.
- Prakriti — square to the sun, arms slightly out, eyes narrowed.

**V8 moon**
- Gauri — one arm raised against the light, hips forward, head turned.
- Vaishnavi — standing, feet wide, arms low and open, presenting.

**V9 day**
- Sachi — on all fours among the roots, head low, hips high.
- Varchas — sitting on the kiln ledge, legs spread, leaning back on the hands.

**V10 pole**
- Kalyani — mid-stride, one leg forward, hands at the hips.

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
