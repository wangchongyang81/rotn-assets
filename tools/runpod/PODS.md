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
Key: ~/.runpod/config.toml, mode 600, set by key-set.sh, never in the repo.
runpodctl reads the key from ~/.runpod/config.toml; the GraphQL x-api-key route returns myself:null and 401s mutations.
runpodctl and v2.sh send Bearer and 401 (2026-11-23).
UNAUTHORIZED on podFindAndDeployOnDemand means an empty or stale key:
re-run bash key-set.sh.

## Stock - runpodctl only
GraphQL cannot answer stock; GET /gpus 404s on v2. runpodctl gpu list >
/tmp/gl.txt, then keep EU-RO-1 rows only (gpuId, memoryInGb, stockStatus).

## Start - two paths, gql first
Both read pod-probe.json, whose name is rotn-pilot. DRY=1 prints and exits 0.
1. TRIES=1 bash create.sh -> id in /tmp/pod.id (x-api-key)
2. bash up-connect.sh -> runpodctl, Bearer, then polls for SSH
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
