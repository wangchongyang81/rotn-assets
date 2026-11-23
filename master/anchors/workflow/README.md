# Workflow

The API-format workflow, the artifact that transfers to fal unchanged.
`build-smoke.mjs` rebuilds the JSON from the prompt file; the JSON is the
committed truth.

Nodes: checkpoint, two encodes, LoadImage skeleton, ControlNetLoader,
ControlNetApplyAdvanced 0.8 full range, latent 832x1216, KSampler euler_ancestral
karras 24 cfg 6 seed 730000, VAEDecode, SaveImage.

## Local status
CPU, 2 cores, no GPU. Dies at model load with or without --fp16-unet.
`manual cast: torch.float32` means fp16 halves storage, not the working set.
OOM on 7.9 GB RAM. Untested output. Local abandoned for throughput.

## fal
Same JSON. Replace LoadImage and the two loader nodes with uploaded file URLs.
Confirm the endpoint accepts seed, negative and safety off before trusting it.

## Departure state 11-23
Render 16 best of run: face, eyes, small areola, straight level arms, level hips, no
belly smear, bust medium. Open: legs out of frame, no feet, lineart soft (edge 3.1
vs 1.5 plate). Plate hands fanned five with thumb; legs end 1055, feet 1078.
Strength 0.85. Prompt rewritten whole at render 13 after five string-miss patches.
Next: feet clearance (legs to 1030), edge back up (raise ink linework weight, drop
soft airbrush), re-smoke, then the ten other poses.

## Depart protocol
1. Re-smoke until y1, area and edge match the plate; do not depart on drift.
2. Append a Departure state note: best render, what is open, what is next.
3. git add -A; git commit -m "<anchor>: <state>"; confirm dirty=0 before any close.
4. bash tools/close_session.sh <pod-id> > /tmp/close.log 2>&1; echo rc=$?
5. rc must be 0 with "MIRROR VERIFIED - safe to terminate" in the tail.
   A stat error means the close_pod path is wrong, not that the mirror failed.
6. git push origin main.
7. runpodctl pod stop <pod-id>; poll pod get until runtimeStatus leaves running.
8. runpodctl pod list must count 0.
