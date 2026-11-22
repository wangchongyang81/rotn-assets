# Resume point — paused for dinner

Pod hu71k90wajsl8o stopped. On return: runpodctl pod start, then boot.sh, then poll 200.
boot.sh is idempotent; the volume holds the app copy, both models and every output.

## Open task
`em` is a MEAN over the content box, so a CROP shrinks the denominator and inflates edge.
o3-a4 scored edge 5.4 at bot 554 / fill 9.6 while broken. Fix: divide by the box area, or
normalise em against fill. Nothing else in the scorer is outstanding.

## Where the gates stand
GE 3.0 (pooled 12: 9/12), GD 3.0 (9/12), fill ceiling 98 / floor 75, bot 1100-1216, mn 150-235.
All one `g=` on line 39. GD and the dark bimodality claim were both wrong once o4/o5 landed:
dark is continuous with a low tail, L19 needs amending.

## What is proven
SMPIN reaches KSampler (sampler_name in the PNG prompt chunk). Scorer is deterministic, local
rescore matches the pod line for line. Keep line carries the gate. Prune keys on git, not the log.
163 frames safe in git and on the remote.

## Do not
Do not set a gate on one set. o2 mean 3.67 vs o3 4.43 at the same settings.
Do not trust a1 in a stop-on-first-PASS run: a1 is always SEED, so use NOSTOP=1 to compare.
