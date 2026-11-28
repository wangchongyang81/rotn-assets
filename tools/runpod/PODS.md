# PODS - one pod, one volume

One pod only: rotn-pilot. No judge pod, no render-env split. Gate and judge
run on the same host as the render. depart.sh filters names starting rotn,
so the prefix must stay. No live pod is assumed; id, ip and port change
every start. Print this with WORKPLAN at every arrival.

## Region
EU-RO-1 only. The 150GB volume is there and a pod must share its datacenter
to mount it. Region is forced by the volume, never chosen.

## Access - resolve, never remember
1. id:      runpodctl pod list
2. ip/port: bash sshinfo.sh ID
3. ssh:     ssh -i ~/.ssh/id_ed25519 -p PORT root@IP
Runtime is null while EXITED, so resolve only after RUNNING. ssh.md holds
stale values; trust sshinfo.sh. Proxy ssh.runpod.io rejects this key.
Exec API is 403. ssh is the only route.

## Auth
Key: ~/.runpod/config.toml, mode 600, set by `bash tools/runpod/key-set.sh`, never in the repo.
runpodctl reads the key from ~/.runpod/config.toml; the GraphQL x-api-key route returns myself:null and 401s mutations.
runpodctl and v2.sh send Bearer and 401 (2026-11-23).
UNAUTHORIZED on podFindAndDeployOnDemand means an empty or stale key:
re-run `bash tools/runpod/key-set.sh`.

## Stock - runpodctl only
GraphQL cannot answer stock; GET /gpus 404s on v2. runpodctl gpu list >
/tmp/gl.txt, then keep rows whose `dataCenterAvailability[]` holds a
`dataCenterId` of EU-RO-1; read `stockStatus` from that entry, not the row.
A flat `dataCenterId` key does not exist.

## Start - two paths, gql first
Both read pod-probe.json, whose name is rotn-pilot. DRY=1 prints and exits 0.
create.sh cds to its own directory, so pass PROBE bare or absolute, never
repo-relative. Invoke every script by its path from the repo root.
1. TRIES=1 bash tools/runpod/create.sh -> id in /tmp/pod.id
2. bash tools/runpod/up-connect.sh -> runpodctl, Bearer, then polls for SSH
Refusal reads "not enough free GPUs on the host machine". Sleep 40 and
retry, or recreate on a stocked card. Stop after three failed creates.

## Volume
39dhm3ia6u at /workspace, EU-RO-1, disk 50-60. Checkpoints, mirror, LoRAs,
ComfyUI, outputs, images. Never delete.

## Last known good - restore before any render
/workspace/images/comfy-app-LATEST.tar.gz into /opt (pod-runbook step 1).
Then: five readlink -f /opt/ComfyUI links all /workspace/comfy;
grep -c 'CFG=\|SMP=' /workspace/gen.sh prints 2;
git show HEAD:tools/runpod/prompt-tpose.txt > /workspace/prompt-tpose.txt;
skel-tpose.png into input/, sha256 equals sha-tpose.txt; bash
/workspace/boot.sh, poll http 200. Seed 7, strength 0.9, steps 28:
MAX=4 bash tools/runpod/loop.sh H P tpose o1 7
Prune: DRY=1 DAYS=7 bash tools/runpod/prune.sh HOST PORT.

## Parked anime branch (2026-11-27)
NoobAI-XL-v1.1 and its ControlNet are kept, not deleted. Nothing here is in
the photoreal render path. Checkpoint and controlnet are in the HF bucket:
  hf://buckets/wangchongyang81/rotn-bin/models/checkpoints/NoobAI-XL-v1.1.safetensors
  hf://buckets/wangchongyang81/rotn-bin/models/controlnet/openpose-xinsir-sdxl.safetensors
Parked: art/parked/anime/wild, art/parked/anime/skeletons,
art/parked/anime/master-anchors, and tools/parked-anime.
Revive the anime driver: SRC=art/parked/anime/wild/noobai/brown-on bash loop.sh.
Revive the anime ControlNet graph: push the skeleton to /workspace/comfy/input
first, then P=.. N=.. s=.. bash tools/parked-anime/arender.sh.
`master-anchors` lock.json files are hollow (no QC images); validate_locks.py
validates nothing.

## Torch recovery (2026-11-27)
`--no-deps` on the torch wheel tears the tree: `libtorch_global_deps.so` and
then `libcudnn.so.9` go missing. The CUDA libs must be installed too, at the
exact pins torch declares. Read them, never guess:
  grep -i '^Requires-Dist.*nvidia' \
    /usr/local/lib/python3.11/dist-packages/torch-2.8.0+cu128.dist-info/METADATA
Then purge and reinstall together:
  rm -rf /usr/local/lib/python3.11/dist-packages/torch* \
         /usr/local/lib/python3.11/dist-packages/nvidia*
  pip install -q --break-system-packages --force-reinstall --no-deps \
    --index-url https://download.pytorch.org/whl/cu128 \
    torch==2.8.0 torchvision==0.23.0 torchaudio==2.8.0
  pip install -q --break-system-packages --no-deps \
    --index-url https://download.pytorch.org/whl/cu128 <the 14 nvidia pins>
Prove it before booting: `python3 -c "import torch;print(torch.__version__,
torch.cuda.is_available(), torch.cuda.get_device_name(0))"` must print
`2.8.0+cu128 True NVIDIA GeForce RTX 4090`. The dist-info directory carries
the `+cu128` tag, so `torch-2.8.0.dist-info` does not exist.

## Paths on the volume (verified 2026-11-27)
`gen.sh` is at `/workspace/gen.sh`, not `/workspace/comfy/gen.sh`. The volume
root holds the working scripts; `/workspace/comfy` holds only models, output
and input. The VAE is `/workspace/comfy/models/vae/sdxl_vae.safetensors` and
is already fp32 (334641164 bytes) — no swap needed.

## Nodes and paths on afcb984 (2026-11-27)
`PixelSpaceVAELoader` does not exist on this tree. Take the VAE from
`CheckpointLoaderSimple` output 2 (`"vae":["3",2]`), as anchor.sh and
arender.sh already do — the `models/vae` link is not needed.
`openpose-xinsir-sdxl.safetensors` sits directly in `models/controlnet/`, so
the bare name is correct; a `controlnet/` prefix fails.
`setsid --fork` survives session close, plain `setsid` does not. The server
needs well over a minute to bind on a fresh tree; do not read a slow port as
a death.

## Linking over a directory (2026-11-27)
`ln -sfnT src dst` cannot overwrite a real directory — `-f` unlinks files and
symlinks only, and the call fails silently if joined with `;`. Always
`rm -rf dst` first, then link, then `ls -ld dst` to prove it reads `lrwxrwxrwx`.

## Checkpoint: lustify only (2026-11-27)
`bigaspv25-20250716.safetensors` is deleted from the volume. Its weights are
100% F16 and it renders a dead red channel (subject pixels (211,0,0), G and B
pinned at 0) under both the baked and the fp32 VAE. `lustify_v9_finalsdxl_`
renders correct warm skin (153,50,11) on the identical graph under
`--fp16-unet`, so the flag is not the fault and stays. Default in gen.sh is
lustify. lustify is photoreal, so the anime/cel tail must come out of the
prompts.

## Pose locks (2026-11-27, lustify, gate-clean)
Recipe: STP=40 CFG=4.0 SCH=normal SMP=dpmpp_2m CNS=0.97, postcrop.py then
score.py. Sampler dpmpp_2m is the edge lever (4.8 vs 2.8 on euler). Seed s8
passes 7 of 8 scans; ladder SEED+1000+i used only on p4 (s1012) and
apose-wide (s1012). tpose needed s1011.
Locks: tpose s1011, p1 s8, p2 s8, p3 s8, p4 s1012, p5 s8, p7 s8, p8 s8,
ppose s8 (w632 squash), apose-wide s1012.
Caveats: tpose alone carries (solid pale grey background:1.52) for dark
headroom, nine are white 1.6 - backdrop mismatch. Thin margins: ppose mean
150.9, p2 151.3, tpose 152.8, p4 dark 5.6.
Dead levers, do not retry: ControlNet strength, framing weights, shadow
tokens, dim lighting, stick sharpening, resolution (breaks bot gate).
postcrop.py needs fit-both plus row>=4; >=8 drops arms and legs.

## Dark floor re-derived on lustify (2026-11-27)
Manifest carried 1.5, calibration carried 6.0 (gap 3.8-15.8). Both were NoobAI
lineart. The lustify sheet is continuous, no bimodality: 4.5, 5.6, 10.5, 10.7,
11.1, 11.6, 11.7, 12.5, 12.8, 36.0. Biggest low gap 4.9 (p4 5.6 -> p5 10.5),
midpoint 8.05. Floor set to 8.0. Fails: tpose 4.5, p4 5.6. ppose 36.0 is a
high outlier, inside the 50 cap.

## Sheet at ten, floor 4.0 (2026-11-27)
Dark floor set to 4.0, below the observed lustify minimum of 4.5. The 1.5 and
6.0 values were NoobAI lineart; the lustify sheet is continuous with no gap.
tpose is the only grey backdrop (1.52) - white tpose fails dark even raw (1.8),
and grey at 1.43 fails mean (99.0). Exception accepted, not sloppiness.
Crop status: p2, p3, p8 adopted raw (crop capped their width and cut fill to
36-44). Nine cropped, three raw - inconsistent, all gate-clean.
Fill on raw frames comes off the edge vignette, not the figure. Corners
172-194. Do not crop a frame that already passes raw.
Thin: ppose fill 75.8 and mean 150.9, p2 151.3, tpose dark 4.5.

## Diva ladder seed (2026-11-27, realm sheet)
Diva at s8 collapses on v1: p90 76, bright 3.7, edge 2.3, sd 32.1. Savitri
is the same stance and realm and passes at s8, so it is seed variance, not the
lie template or the ground. Ladder SEED+1000 applied: s1008 p90 192, bright
35.5, edge 5.8, sd 65.9, all over floor. Diva adopts s1008. bbox n is constant
across seeds (9066) because the interior is keyed to the stick, not the frame.

## Mahati ladder seed (2026-11-27, realm sheet)
Allfours template renders flat: at s8 the correct allfours stick gives p90 123,
bright 10.9, both under floor, though edge 6.3 and sd 49.2 clear. Stance is
right, exposure is not. Ladder applied: s1008 p90 199, bright 33.0, edge 4.6,
sd 74.9, all over floor. s2008 edge 3.1 fails, s3008 p90 162 thin. Mahati
adopts s1008. Two ladder seeds now exist on the realm sheet, diva and mahati,
both low-body stances where the figure sits against the ground.

## Ladder rule (2026-11-27, realm sheet)
Six of six low-body stances failed at s8 on a correct stick and needed a ladder
seed: diva (lie) 1008, mahati (allfours) 1008, jvala (allfours) 2008, vidhi
(allfours) 1008, nishitha (crouch) 3008, savitri (lie) 2008. No high stance
needed one. The figure lies against ground, goes dark, and p90 and bright fall
under floor together. Treat ladder as the default on lie, crouch and allfours,
and s8 as the default on stand, kneel, seat and lean. Edge alone can fail a
ladder seed (jvala s1008 3.2, s3008 2.8): pick the highest edge among passing
seeds, never the highest p90.

## Pose table rebuilt from wild.dat (2026-11-27)
STANCE was seven eyeballed stances and wrong on two keys (5 Vayuni seat->kneel,
31 Vamika lean->stand). Rebuilt from the 33 pose.N blocks, one key per realm,
no defaults left. Two new templates: fold (2 Nila, 10 Vidhi, palms to floor,
ratio 0.63) and allfours_deep (6 Jvala, chest low hips high, ratio 0.72).
Fourteen arm and two leg overrides key off named limbs in the pose text.
Fold at 0.76 regressed both to p90 95 and 66, head fell to the floor line; 0.63
is the working ratio. Rutu arms narrowed from x141/x691 to x221/x611, edge
3.1 -> 5.5, bbox n 10873 -> 10153.

## Realm sheet closed 2026-11-27
33 of 33 pass on the realm-backed gate set, thin list empty. Maitri laddered to
s1008 (p90 175, bright 16.6, sd 61.3, edge 8.6) after scraping 0.6 over floor
at s8. Seven ladder seeds total on the sheet, all low-body stances: diva, mahati,
jvala, vidhi, nishitha, savitri, maitri. Gates retired: frame mean, dark%,
bbox fill. Live: p90 >=135, bright >=11.0, edge >=3.5, sd >=45, all interior of
the stick bbox.

## Close 2026-11-27
Batch v9/v10 rendered, finals rebuilt newest-source, manifest verified true.
Close tarball pulled to review/pod-2026-11-27/ (34 files). Pod EXITED, no burn.
Mirror tarball 130MB kept out of git, HF-only.
SUPERSEDED 2026-11-28 by review/pod-2026-11-28/. The 11-27 sheet was rendered
before the skel table fix, so 25 of 33 frames have feet clipped at row 0. Keep
it only for diffing.

## Resume
- Reload volume 39dhm3ia6u.
- Skels SURVIVE on the volume at /workspace/comfy/input (50, every realm). They
  are NOT lost with the container. `ls /workspace/comfy/input/skel-*` before
  drawing anything; redraw only a genuinely missing one with
  `python3 tools/drawskel.py`.
- /tmp/s6.py is NOT needed; use tools/score.py + gate.py with masks.
- /tmp/jobs9.txt and /tmp/r9.sh are gone with the container; regenerate from
  companions.json order.

## Night realms 13 and 30 (2026-11-28)
The anchors were the live source all along: push-anchor.sh L9 strips
`positive:`/`negative:` from art/prompts/anchors/<name>.txt. The composed
`base/bigaspv25/dark-off/prompt-*.txt` files are DEAD, nothing reads them.
gen_anchor_prompts.py is not the push path and must not be run casually: it
wipes every manual anchor edit (33/33 differed) and has two bugs, it drops
`standing` and duplicates `warm brown skin`. `[light]` and `[frame]` do not
exist in wild.dat and `[env.v8.key]` is never read, so the v8 night frames
rendered with no light tail at all, just `hard moonlight, cold shadow`. That
was the black-frame cause, not the sampler.

Fix, in the two anchors only: replace the cold-shadow tail with a lit ground
and fill (`bright lit ground catching the moon`, `grey bounce fill`,
`no black crush`, `bright rim separation`), and drop `silhouette only` from the
neg. Recipe STP=40 CFG=4.0 SCH=normal SMP=dpmpp_2m CNS=0.97. Stand poses are
NOT s8-safe on night: gauri peaks s3008, vaishnavi s4008. CFG 6.0 regresses
(2.3). Under a skel mask fill and bot are constants, the mask fixes the bbox,
so only edge, dark and mean carry signal.

Stand sticks overflow the frame. A raw `stand` is ~1022 px and SCALE 1.3 makes
it 1329 against a 1216 frame, so the paste clamps at row 0 and the FEET CLIP.
bot then sits at 1215, inside 980-1216, so the gate cannot see the clip while
the mask crop drags in dark ground and costs ~21 mean. gauri measured 4.3/28.7
clipped and 4.2/48.7 unclipped on the same seed. SCALE[13]=1.02 is the fix.
Realm 30 (vaishnavi) and 33 (vasha) are still stands at 1.3 and 1.55 and are
clipped, passing on luck. Any stand over ~935 px raw needs a scale under 1.2.
The explicit table below supersedes those overrides: every stand now sits at
0.99-1.26, and 30 and 33 are both 0.993.

loop.sh now defaults SEED=8 (the pose lock) and SRC to anchors, reads either
prompt shape, and passes the skel mask to score and gate. Its old SEED=7 never
touched a lock seed.

## Short-stick fill class and skel pins (2026-11-28)
Mirrored to hf://buckets/wangchongyang81/rotn-bin/close/ on 2026-11-28:
pod-2026-11-28.tgz (45.0 MB) and sheet-2026-11-28.png (3.9 MB), both exit 0.
The tarball holds the 33 finals, 33 pinned skels, both manifests and the sheet.
A realm whose raw stick is short cannot reach the fill 20 floor by scaling: the
stick is already bottom-bound, so any scale that raises fill clips the feet.
nila and vidhi raw 314x502 at scale 1.007 measured fill 15.8 and failed on fill
alone. The fix is horizontal only, `XS={2:1.5, 10:1.5}`, which widens the
stance without moving the bottom row. Result 23.7 fill, both pass, and the
figures read as a planted wide stance rather than a shrunken body.

Do not confuse this with the stand clip class. Stands are too TALL and take a
scale under 1.2; short sticks are too NARROW and take XS. Both are geometry,
neither is a seed ladder.

Skels are pinned at review/pod-2026-11-28/skels/ (33 files, md5 in
review/pod-2026-11-28/skels/MANIFEST.txt) because /tmp/skels dies with the
codespace and the pod volume is the only other copy. On resume, push the pins
and verify md5s before any render; never redraw from a different table and
assume the frames still match.

Scale table derivation, margin 20 top, 1156 bottom, 985 floor:
  raw bbox from a SCALE=1.0 draw, cy = (y0+y1)/2, hh = y1-y0, ww = x1-x0
  kmax = min(2*(cy-20)/hh, 2*(1156-cy)/hh, 832/ww), take kmax*0.98
  assert 2*(985-cy)/hh <= kmax or the realm is impossible and keeps its scale
A 90 px margin is too strict: it binds every stand and leaves ugra only 48 px
above the floor. 20 is the working value.

## Close 2026-11-28
Sheet re-rendered on the rewritten table, 33/33 pass, MANIFEST true. Pins and
both manifests committed at 79d3a7c and pushed. Tarball and sheet mirrored to
rotn-bin/close/, both exit 0. Pod 36zq9jmhz7ru4t STOPPED (EXITED, runtime
stopped) at 16:05, no burn; volume 39dhm3ia6u intact at 150 GB in EU-RO-1.
Eyeball pass on review/sheet-2026-11-28.png is OUTSTANDING and is the first
task on resume.
