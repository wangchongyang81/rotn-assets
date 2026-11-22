# Workplan — automated anchor pipeline
Goal: unattended, self-diagnosing anchor locks, portraits, mobs, CGs across 33 realms.
CLI only. One in-DC card. Human role = veto, not generation.
## Rules
- Scorer quality is the ceiling. No batch before it is calibrated.
- Hash every artefact. A prompt edit invalidates only what it should.
- Hard gates. No phase starts until the prior gate passes.
## P0 Probe — 0.5d, ~$2
Recreate as RTX PRO 6000 in EU-RO-1, volume attached.
Gate: one render completes, SDPA fallback works, no node crash. Fail => stay on 4090.
## P1 Scorer v1 — 2-3d, no GPU
DWPose output vs skeleton => PCK + joint angle error. Bbox/fill/edge secondary.
Gate: >=90% agreement with 30-50 human labels.
## P2 Registry — 1-2d, no GPU
Hash(prompt+skel+model+settings+seed) => name + registry.json. Freeze slugs.
Gate: a prompt edit re-renders exactly the affected set and nothing else.
## P3 Image, supervisor, queue — 2-3d
ComfyUI+nodes+models+symlinks baked. Health endpoint, auto-restart, SQLite queue.
Gate: kill mid-batch, recovers with no duplicate work.
## P4 Judge — 2-3d, GPU
Quantised 7B VLM beside the generator. Fingers, limbs, face, nudity, style. Veto only.
Gate: >=90% agreement with the P1 labels.
## P5 Prompt lock — per realm
Template + character overlay. 3/3 seeds pass P1+P4 with no crop before any batch.
## P6-P9
Anchors 33 realms -> CGs/mobs/NPCs -> LoRA mains only -> steady state.
Each gated by a signed review sheet.
## Cost
$0.028/attempt => ~$140 over 500 locks; $30 on 4090. Ceiling set by you.
## Critical path
P1 -> P4. All else waits on scorer quality.
