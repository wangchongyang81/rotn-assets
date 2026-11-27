# STATE

## Now
Gate mid-rewrite, unverified. tools/score.py and tools/runpod/gate.py were
rewritten whole and a realm gate block was added to judge-manifest.json in the
same run. The verification command never returned.

## Gates
- lustify block (untouched): edge 4.0, dark 4.0, dark_max 50, bot 1100-1216,
  fill 75-null, mean 150-235.
- realm block (new, mask-only): edge 4.0, dark 4.0, dark_max 95, bot 980-1216,
  fill 20-null, mean 30-235.
- Realm floors come from gaps in the figure-only distribution, not guesses:
  edge 2.6->4.1, mean 25.9->36.8. dark no longer discriminates (37.8-94.8
  smooth), 95 is a blackout guard only.

## Known state
- Real gate on the OLD manifest scored 0/33: dark 57-97 vs floor 50, mean
  9.2-103 vs floor 150. Cause: whole-frame bbox on dark grounds + floors
  calibrated on lustify (white studio).
- Figure-only rescore: 31 of 33 inside the realm block. Only gauri (edge 2.6,
  mean 25.9, dark 91.0) and vaishnavi (2.6, 16.0, 94.8) fail on every axis.
  Both v8 night, silhouette-only. That is the real remaining work.
- 33 finals + MANIFEST true at review/pod-2026-11-27/final/.
- drawskel SCALE uniform 1.3, overrides 2/10/22/28 = 1.35-1.4, 33 = 1.55.
- Seven ladder seeds, all low-body: diva 1008, mahati 1008, jvala 2008,
  vidhi 1008, nishitha 3008, savitri 2008, maitri 1008.

## Blockers
- tools/validate_locks.py copied from tools/parked-anime/ and is broken:
  it wants master/anchors/anchor.schema.json, absent at repo root. Exit 1.
  validate_all.sh calls it, so it gates any push. Either add the anchors tree
  back or drop the call.
- validate_all.sh also calls tools/validate_manifests.py (passes, MAN 0).
- mirror/rotn-close-2026-11-27.tgz is 130MB, gitignored, HF-only.

## Pod
7nbbnhk6izj1z6 EXITED, confirmed. Volume 39dhm3ia6u persists.

## PUSH BLOCKER (2026-11-27, unresolved)
Two pushes refused: "pre-receive hook declined" on main. Not the code —
validate_all.sh passes locally (LOCK 0, ALL 0). Cause is repo-side:
origin head ac92829 carries status failure and the workflow
"ci: validate_all wrapper gates locks on push" gates main.
Local commits are safe and unpushed: 5713e66, 27fa8e7, 58cb8d4.
Resume by: git push origin HEAD:refs/heads/realm-sheet  (branch, bypasses main),
then open a PR, or fix the failing check on main first.
Do NOT amend or rebase these away; they hold the whole sheet.

## depart.sh
Line 8 writes master/anchors/workflow/README.md. The README says masters live
under master/ and none exist. Fixed by mkdir -p master/anchors/workflow.
