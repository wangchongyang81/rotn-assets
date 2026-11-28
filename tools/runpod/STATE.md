# STATE

## Now
realm sheet closed; push green at 00f294a. 33 of 33 pass, including the two
v8 night frames: gauri s3008 (edge 4.2, mean 48.7), vaishnavi s4008 (edge 4.4,
mean 50.2). No render work remains. The night fix and the anchor-path finding
are in PODS.md "Night realms 13 and 30".

## Gates
- lustify, unmasked: edge 4.0, dark 4.0, dark_max 50, bot 1100-1216,
  fill 75-null, mean 150-235.
- realm, mask-only: edge 4.0, dark 4.0, dark_max 95, bot 980-1216,
  fill 20-null, mean 30-235.
- Realm floors from distribution gaps, not guesses: edge 2.6->4.1, mean
  25.9->36.8. dark no longer discriminates; 95 is a blackout guard only.

## Known state
- Whole-frame bbox on dark ground is degenerate (fill 99.8, bot 1215; it
  measures ground, not figure). MASK required for realm scoring.
- Old manifest scored 0/33 (dark 57-97 vs 50, mean 9.2-103 vs 150). Floors
  were calibrated on lustify white studio. The realm block fixes the gate,
  not the sheet.
- 33 finals, MANIFEST true, review/pod-2026-11-27/final/.
- drawskel SCALE 1.3; overrides 2/10/22/28 = 1.35-1.4, 33 = 1.55.
- Seven ladder seeds, all low-body: diva/mahati/vidhi/maitri 1008,
  jvala/savitri 2008, nishitha 3008.

## Resolved
- Push refused twice on GH001: mirror/rotn-close-2026-11-27.tgz, 124.66 MB,
  over the 100 MB limit and inside the unpushed range. Squashed to origin,
  mirror/ and *.tgz gitignored. Tarballs stay HF-only.
- validate_locks.py repointed to art/parked/anime/master-anchors. LOCK 0.
- depart.sh line 8 dir master/anchors/workflow created.

## Pod
7nbbnhk6izj1z6 EXITED. Volume 39dhm3ia6u persists.
