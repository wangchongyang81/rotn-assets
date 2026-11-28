# STATE

## Now
Sheet re-rendered on the corrected skel table; 33 of 33 pass, MANIFEST true
at review/pod-2026-11-28/final/. Night pair gauri s3008 (edge 4.2, mean 50.4)
and vaishnavi s4008 (edge 5.2, mean 45.2). Short-stick pair nila s8 and vidhi
s1008 needed XS 1.5, not a scale change. All 33 skels pinned at
review/pod-2026-11-28/skels/ and md5-verified on the pod. Gate passing is NOT
confirmation: feet clipping, identity drift and pose read still need eyes.

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
- 33 finals, MANIFEST true, review/pod-2026-11-28/final/ (supersedes 11-27).
- drawskel SCALE is an explicit per-realm table computed from raw geometry:
  horizontals up (6/12/15/24 = 1.58-1.87), stands pulled down to fit the frame
  (0.99-1.26), XS 1.5 on 2/10 for the short-stick fill class. Regenerate with
  the margin script in PODS.md, never by hand.
- Nine ladder seeds, all low-body: diva/mahati/maitri 1008, jvala/savitri 2008,
  nishitha/gauri 3008, vaishnavi 4008.

## Resolved
- Push refused twice on GH001: mirror/rotn-close-2026-11-27.tgz, 124.66 MB,
  over the 100 MB limit and inside the unpushed range. Squashed to origin,
  mirror/ and *.tgz gitignored. Tarballs stay HF-only.
- validate_locks.py repointed to art/parked/anime/master-anchors. LOCK 0.
- depart.sh line 8 dir master/anchors/workflow created.

## Pod
7nbbnhk6izj1z6 EXITED. Volume 39dhm3ia6u persists.
