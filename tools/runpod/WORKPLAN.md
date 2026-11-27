# Workplan - rotn-pilot photoreal render

Goal: photorealistic anchors for rotn-pilot on one in-DC card. Human role is
veto, not generation. Single pod; no judge pod and no render/judge pairing.
gate.py scores on the same host straight after the render.

Removed 2026-11-27 as obsolete: the unattended anchor pipeline (P0-P9 spine,
scorer v1, registry, queue/supervisor, 7B VLM judge, prompt-lock phase) and
NoobAI-XL-v1.1. The checkpoint is photoreal.

## Rules
- Scorer quality is the ceiling. No batch before it is calibrated.
- Hash every artefact. A prompt edit invalidates only what it should.
- Hard gate. No batch starts until the prior gate passes.

## Pins
`CFGPIN` and `SMPIN` default to 0 and pin on separate lines: loop.sh L13 sets
cfg, L14 sets smp. Not a duplicate; both reach the remote gen.sh as env.
Read back from the PNG prompt chunk, not the log: gen.sh swallows its JSON
into `J=$(...)` so the sampler never reaches stdout.
Retry seed is `SEED+1000+i`, clear of the primary `SEED+(i-1)*SS` stride.

## Current
Own: home / venice. Photoreal render, protocol-only. Resumable cold, zero chat.
Pod down, tree clean. Arrive `scripts/continuity/arrive.sh home`; the session
gate departs with `scripts/continuity/depart.sh home`. `tools/runpod/depart.sh`
is the separate job that deletes the pod.
Records: `art-bible/07-anchors.md`, `docs/continuity/plans/anchor-lock-identity.md`.
Probe names 4090 (rotn-pilot); 6000 deferred, not cancelled. 11 skeletons valid.
`gen.sh` reads `skel-{pose}.png`; repo holds `skel-ppose-{pose}.png`, push renames.
All 10 poses end `, feet in frame, full figure, wide shot`; gaps 3-32; tpose hash 0ff68e2afef569c9.
Gate: edge>=4.0, dark>=1.5, bot 1100-1216, fill<98, mean 150-235, dark<=50. CROP checks bot only.
Seed 7 is not project-wide; edge spans 4.4-10.9. Per-pose scan, seeds 7-15,
floor from own distribution. Locked: tpose seed 7 only.
Open: V=()/N=() empty. Near-black escapes CROP. p5 floor unset (12.2 seed 8, 4.4-6.0 behind).
Prune `DRY=1 DAYS=7 bash tools/runpod/prune.sh HOST PORT`; orphans = ids absent from attempts.jsonl.
Hold: commercial use of the photoreal checkpoint not cleared absent a separate grant.
Snapshot 2026-11-22, assets 0c2cb39.

## Steps
1. Anchor specification recorded; gate calibrated on real frames, not fixtures. [venice]
2. Framing tail on all 10 poses; p5 gap 755->21, p4 1->18. [venice]
3. Per-pose scan seeds 7-15; only tpose locked. [venice]
4. Open faults: empty V/N arrays, dark term in CROP, p5 floor. [venice]
5. Prune scripted, DRY default; dry run pending next bring-up. [venice]
