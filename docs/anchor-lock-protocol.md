# Anchor lock protocol — master record
Resumable with zero chat. Lane: venice. Repo: rotn-assets.
## Preconditions
Pod down, tree clean. `bash tools/runpod/up-connect.sh` (probe names 4090, rotn-pilot-2).
Arrival: `bash scripts/continuity/arrive.sh venice`. Departure: `bash tools/runpod/depart.sh`.
## Skeleton rule
`gen.sh` reads `skel-{pose}.png`. Repo holds `skel-ppose-{pose}.png`; push renames.
All 11 skeletons must open under PIL before any run. tpose is fixed at 6845 bytes.
## Framing rule
Every pose file must end `, feet in frame, full figure, wide shot`.
Without it p5 floats at gap 755 and p4 jams at gap 1. With it, gaps land 3-32.
tpose.txt is the only file carrying it historically; hash 0ff68e2afef569c9 is the lock.
## Gate terms
PASS needs: edge>=4.0, dark>=1.5, bot 1100-1216, fill<98, mean 150-235, dark<=50.
CROP fires on bot outside the band only. Near-black escapes there and is a known gap.
## Scan rule
Seed 7 is NOT project-wide. Edge spans 4.4-10.9 across poses on identical params.
Per-pose scan only, seeds 7-15, floor taken from that pose's own distribution.
Pin cfg and smp or seeds confound. Determinism holds under a pin (pixel hash identical x3).
## Lock rule
A pose locks when 3 consecutive seeds pass. Record via `log.sh attempt` with TAG.
Locked: tpose seed 7, hash 0ff68e2afef569c9. Nothing else is locked.
## Depart
Commit, push, `bash tools/runpod/depart.sh`. Clears /tmp/pod.env, exits 0 if already down.
## Prune
`DRY=1 DAYS=7 bash tools/runpod/prune.sh HOST PORT`. Orphans = output ids absent from attempts.jsonl.
HF orphans = remote files absent from git. Review dry output before DRY=0.
## Traps
sed RHS `\1` fails on this build — use python. `2>&1 | tail` buffers, watch pod file count.
Loop L16/L17 duplicate cfg pin; smp never pins. V=() and N=() empty, var is a label.
## Open
smp pin. dark term in CROP. p5 floor unset (12.2 at seed 8, 4.4-6.0 behind). V/N empty.
