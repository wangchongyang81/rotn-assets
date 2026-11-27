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
gql.sh sends it as x-api-key and that is the only working header.
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
