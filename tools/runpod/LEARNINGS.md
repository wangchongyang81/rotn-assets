# Pod run learnings — 2026-11-22
## Hard faults, fixes now in repo
- `ln -sfn` into an existing dir nests the link inside it. Use `rm -rf`
  then `ln -sfnT`, and assert `readlink -f` returns the volume path.
  Cause of renders landing on ephemeral disk all session.
- `pkill -f "[m]ain.py"` in the same ssh call kills the shell before
  `start` runs. Use pod-side restart.sh whose argv is not main.py.
- SaveImage rejects an absolute prefix. Normalise OUT to a bare name.
- Skeleton naming split tpose vs ppose. One `name()` fn, hash STALE gate.
- Local edits never re-shipped (the CFG/SMP patch). Ship, then grep the
  pod copy to prove it before rendering.
## Loop faults
- Fabricated DRY scores (+1.5/iter) hid a real 2.5-3.9 band. No inflation.
- Keeper was edge-only and kept a foot-cropped frame (bot 1215, fill 99.8).
  Reject bot>=1200 and fill>=95 in both keeper and pass test.
- Pulls must run inside the loop; its own `rm -f $TAG-a*` deleted them.
## Measurement
- FIND_EDGES every 4th px under-reads 2px lines. Full res over the crop.
- Centre-column body_bottom runs between the legs. Use the full bbox.
## Prompt — the actual blocker
- Base says `flat colour, flat shading, cel shading` AND `crisp lineart`.
  Cel shading removes ink, so appended `lineart` cannot win.
- cfg 5->7.5 and euler->dpmpp moved edge only 2.5->3.9. Sampler is not
  the lever; the base prompt is.
- Next run: rewrite the base to drop cel/flat shading, hold lineart, then
  sweep cfg. Only then trust any anchor lock.
## Pod hygiene
- Volume is /workspace/comfy. Everything persistent lives there.
- Never tail a buffered pipe and call it stuck; poll the file count.
- Untested levers are worse than no levers: dry-run every branch first.

## Departure checklist
- HF mirror backup every departure (agreed).
- Restore base from git HEAD, never a .bak.
- runpodctl pod stop; never terminate.
reference: art/prompts/wild/noobai/brown-on/_ref/tpose.txt is the frozen base; loop reads git HEAD
mirror: tools/hf/mirror.sh, hf CLI uses `repos` not `repo` (v2.4.0). Private repo pages 404 to anonymous scrape by design. 1TB private quota.
hf CLI v2.4.0: no `repos info`; use `hf repos list` or HfApi().repo_info().
departure 2026-11-22: pod hu71k90wajsl8o stopped, mirror exact (extra .gitattributes only), tree clean at f1d8c08.
## GPU decision 2026-11-22
- Pick: RTX PRO 6000 96GB, $1.69 com, EU-RO-1 **High**.
  Same DC as volume => no re-upload, checkpoint and outputs stay.
- Over A100 80GB $1.19: +42% cost, +16GB, fp8, High vs Low stock.
- Over B200 $5.98: 3.5x cheaper, capacity SDXL never fills.
- Dead: 6000 Ada (US-WA-1 only), L40S (no EU-RO-1), WK (2 DCs, Low).
- Half-measure: PRO 4500 32GB secure $0.72, MIG 48GB $1.39 secure.
- Tooling: torch 2.8.0+cu128 already pinned = sm120 capable. Base image
  cuda12.4 is fine, wheels bundle runtime. Risks: xformers/flash-attn lag,
  fall back to SDPA; SageAttention needs source build. Probe before commit.
- 96GB does NOT fix the gate. Switch when the VLM judge lands.
gen.sh: CFG and SMP share one line, so grep -c yields 1 not 2. probe: driver 595, torch 2.8.0+cu128, 97GB, sm120 ok.
probe PRO 6000: render 87s vs 4090 60-90s. secure $2.69 vs $0.89 => ~3-4x cost/image. Card is for judge VRAM, not speed. cfg 5.0 pin defaults correctly.
probe verdict: p6000a edge 5.4 > t1-best 3.9, bot 1.00 vs t1-a8 0.04. Sharp, uncropped, prompt 418B positive only. sm120 quality pass, 85.76s exec.
sweep cfg5.0 x4: edge 2.6-2.9 flat, fill 74-80%, a3 CROP at 99.8. kept a1 2.7. Loop edge scale matches ImageStat; probe 5.4 was base-only.
framing tail fixes bot 0.06->0.96-1.00, edge 5.3-5.5 both samplers. Pin dpmpp_2m. Warm render ~7s vs 86s cold.
score thr 235->120: idp1 99.8->81.8 bot 1215->1156. seed 11 blank twice mean 251 sd 0.3. WASH retries once at SEED+i+50.
gate fixed: thr 120, idp1/b7 both PASS. dark rose to 3.1-3.6. seeds 8-11 sweep exercises WASH retry on 11.
sweep o4: PASS a1 first try but edge 4.1, floor 4, refs 5.2-5.6. Thin pass, broke before other seeds.
gate calibrated: GE 4.8 rejects o4a1 4.1, ceiling 226 rejects 228.9, 7/8 refs pass. ieu on boundary 4.8, b21 fill 91.6 near cap.
NOSTOP ok, retry ok. But 3/4 seeds edge 4.1-4.4, fill fell 99.8->84: framing tail suspected, floor 4.8 calibrated pre-framing.
A/B seed7: framed 5.4, unframed 5.3, b7 5.2. Framing innocent. euler 3.1 vs dpmpp 5.3 same seed. Seed dominates: 7->5.4, 8-10->4.1-4.4, 11 blank. Floor 4.0, seeds x17.
s2 SS=1 but case block confounded cfg/smp: a1-a4 cfg5 dpm, a5-a7 cfg6.5 euler, a8-a9 cfg7.5. Seed7 5.4 third time, byte-identical to f7. a9 dark 95.3 mean 18.4 near-black, passes GD min-only.
seed7 determinism PROVEN: 3 renders, pixel hash 2992a154314d identical, metrics identical. File hashes differ (PNG metadata only). Lock justified.
