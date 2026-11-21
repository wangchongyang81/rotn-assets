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
