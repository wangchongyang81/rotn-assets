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
skel-p1 full-bleed 831x1215 fill 99.8, not a normaliser. man7 render box 217x1040 fill 22.3 edge 8.2 mean 225.64. p3 edge 9.9. Edge rises as figure narrows: edge/fill pose-dependent, gate cannot be global.
seed7 across 9 poses: edge 4.9-15.2 (ppose 4.9 apose 5.9 p2 5.2 p8 7.2 p1 8.2 p3 9.9 p5 10.0 p4 11.9 p7 15.2). p2/p4/p8 CROP bot>=1200. p5 bot 461 legs missing. p1 fill 22.3 edge 8.2 vs p7 fill 22.5 edge 15.2: fill is not the normaliser. Seed7 NOT project-wide.
edge = FIND_EDGES inside bbox only (score.py L7), stable 15.2 twice; full-frame dilutes to 4.9. Skeleton ink 960-967k, 0.7% spread, dead normaliser. Within-pose fill is constant so per-pose scan is comparable without normalisation.
skelbox identical all 10 (top 0 bot 1215 fill 99.8): skeleton predicts nothing. gap table p4=1 jammed, p5=755 floating, others 14-79. Framing must come from the prompt.
framing tail only in tpose.txt, 9 others lack it: p4 gap 1 feet clipped, p5 gap 755 waist-up. Tail appended to all 9.
framing tail on all 9: p5 755->21, p4 1->18, p1 78->20, p7 77->19, all gaps 3-32. bot>=1200 proxy dead, replaced with bot band 1100-1216.
ft2 all 9 gaps 3-32 after tail. edge 4.4-10.9 pose-driven, seed7 not project-wide. apose mean 231.8, p3 fill 95.0 wrongly rejected: mean_max 235, fill_max 98, bot_max 1216.
s5 NOT a p5 test: loop reads B=/tmp/anc/base.txt L19, overwrites prompt-p5.txt L22. CFGPIN unset so cfg/smp vary a1-a4 5.0, a5-a7 6.5 euler, a8 7.5. Fills 23.7-99.8 chaotic.
CORRECTION: L9 base.txt is git show of $POSE.txt, rebuilt each run, byte-identical to p5.txt. s5 WAS a real p5 test with tail. Only cfg/smp confound stands.
s6 CFGPIN works: all cfg 5.0. s6-a1/a2 identical to s5-a1/a2, determinism holds under pin. THREE FAULTS: L16+L17 duplicate cfg pin, smp never pins (a5-a7 euler). V=() N=() empty, var is a label with no variation. a8 dark 96.9 mean 18.2, CROP checks bot only so near-black not caught there. p5 floor: seed8 12.2, seeds 8-11 12.2/7.9/8.9/5.4, 12-15 4.4/3.6/6.0/4.6.
grep [venice] matches BARE tags only; L14 [venice, claude] and L17 [claude, venice] never match. tags_total 7 = 6 P5 + spine L13. Print bound is P5-only so spine L13 is safe; a 7th working-copy line would be dropped.
Weekly default is split: HF-only deletes (proven, extra 0 missing 0), pod path stays dry until the volume section runs live once. prune-weekly.sh launches in background from up-connect.sh after SSH; there is no cron in a Codespace.

## L18 — edge gate sits above the distribution (o2, 4 seeds, fixed cfg 5.0 / euler)

Scores at identical settings, only seed varying: 4.8/15.8, 2.9/2.6, 4.0/3.6, 3.0/2.4.
edge mean 3.67 sd 0.90; gate GE=4.0 is ABOVE the mean, so a fresh seed passes ~1 in 4.
Local rescore matches the pod line for line: the scorer is deterministic, the spread is image noise.
Median-3 drop is uniform (34.1/31.2/33.8/33.7%) and relative sd is unchanged (24.5 -> 22.8%):
the filter is a constant tax, not a discriminator. Do not add it to ranking.
a1 is always SEED+(1-1)*SS = SEED, so stop-on-first-PASS always keeps seed 7. NOSTOP=1 for any
seed comparison; best-of-N already picks the best frame regardless of order.

## L19 — gate is weaker than seed variance; edge inflates on a collapsed box

Pooled o2+o3, 8 seeds, fixed cfg 5.0 / euler: mean 4.05, sd 1.44. GE 3.0 passes 6/8, GE 4.0 passes 5/8.
One set cannot set a gate; two sets disagree on level (3.67 vs 4.43) while agreeing on spread.
edge is a MEAN over the content box, so a CROP shrinks the denominator and inflates it: o3-a4 scored
edge 5.4 at bot 554 / fill 9.6 while being visibly broken. The bot gate is what catches it, not edge.
dark is bimodal: 4 seeds under 3.8, 4 over 15.8, none between. GD=1.5 clears every frame and
decides nothing; it must sit in the gap or be dropped.
Seed variance at 1.44 sd dominates gate choice. Best-of-N is the mechanism; the gate only trims.

## L20 — the keep line did not carry the gate

L40 tested only em>0, dk<=50, mn>=150 before comparing to best. It never saw bot, fil, mn<235, GE or GD,
so any frame that rendered was eligible for best. o4-a4 was promoted at fil 99.8 / bot 1215 while failing
the gate. The keep line now repeats the full gate condition, so only a PASSing frame can be best.

## L21 — gate computed once

The gate condition sat on three lines (ok/weak echo, keep, PASS). Any change had to hit all three.
It is now one `g=$(...)` with three short users, so the condition exists once.

## L22 — fill floor at 75, ceiling at 98 confirmed

fill is one-sided (ceiling only), so a tiny subject passed everything. Observed min 75.4 over 15.
Floor 75 sits 0.4 under it: fails 0/15 now, bites on a smaller subject. 76 fails 1/15 and would be
tuned to a 15-frame sample. High fill correlates with bot (mean 1212 vs 1148): fill >=98 is a bottom
crop, so the ceiling stays at 98 and the floor guards the other end.
