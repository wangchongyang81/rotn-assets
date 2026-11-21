# Manifest schema
One JSON object per line, one file per anchor: <realm>/<pose>.jsonl
Required: file, realm, pose, accepted, run, model, sampler, scheduler, steps, cfg, seed
Prompt fields: prompt_file, negative_file, prompt_sha256
Result fields: torso_rgb, leg_rgb, bg_frac, bytes, verdict
Accepted rows: exactly one per anchor. The accepted file is anchor-<pose>_00001_.png
Candidates keep accepted:false and the verdict that rejected them.
