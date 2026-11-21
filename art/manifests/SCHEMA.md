# Manifest schema
One JSON object per line, one file per anchor: <realm>/<pose>.jsonl
Required: file, realm, pose, accepted, run, model, sampler, scheduler, steps, cfg, seed
Prompt fields: prompt_file, negative_file, prompt_sha256
Result fields: torso_rgb, leg_rgb, bg_frac, bytes, verdict
Accepted rows: exactly one per anchor. The accepted file is anchor-<pose>_00001_.png
Candidates keep accepted:false and the verdict that rejected them.
## Quality fields (added 2026-11-21)
edge_mean: FIND_EDGES mean on grayscale, 0-255. Anchor floor 18.
bg_frac: fraction of pixels within 12 of pure white. Anchor floor 0.55.
bg_clean: false if machinery, scenery or props are visible. Checked by eye.
An anchor passing rgb but failing edge_mean or bg_clean is NOT accepted.
