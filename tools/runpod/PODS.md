# PODS — two fleets, one volume

Print this with WORKPLAN and REPOS.md at every arrival. It is the tooling
inventory, not a suggestion. No live pod is assumed: id, ip and port change
every start.

## Region — EU-RO-1 only
The 150GB volume is there and a pod must share its datacenter to mount it.
US-MO-1 was mooted for stock and rejected. Do not re-moot it.
Region is forced by the volume and never chosen.

## Stock — runpodctl only, proven 2026-11-25
GraphQL cannot answer stock: `dataCenterAvailability` is not a GpuType field
and Apollo introspection is disabled. Use the CLI JSON, never a GraphQL probe.
Per GPU: `runpodctl gpu list`, keep rows whose `dataCenterAvailability[].dataCenterId`
is `EU-RO-1`; `stockStatus` answers, `securePricePerHr` is the cost.
Per datacenter: `runpodctl datacenter list`, read `gpuAvailability[].stockStatus`
on the `EU-RO-1` object. The datacenter list does answer stock.
Proven live: 4090 $0.89/hr, A100-SXM4-80GB $2.19/hr, B200 $7.99/hr,
RTX PRO 6000 $2.69/hr. All Low, all EU-RO-1. Low is orderable; a create can
still lose the race and retry.

## Fleet A — anchor lock pilot (4090)
Purpose: per-pose anchors, skeletons and sheets for the art lock. First fleet.
Host: SECURE EU-RO-1, 4090, volume 39dhm3ia6u at /workspace, disk 50.
Ports 8188/http and 22/tcp.
Order: create.sh -> up-connect.sh -> remote-boot.sh -> remote-prep.sh ->
remote-aux.sh -> remote-dl.sh -> remote-cn.sh -> remote-smoke.sh.
Then render: remote-tskel3.sh or remote-ppose.sh, remote-sheet.sh,
MAX=4 loop.sh H P pose out seed, then prune.sh, then pod-down.sh.
create.sh builds the mutation inline; it reads GPU, DC, CLOUD, VOLUME, TRIES
from the environment. The default GPU is still `NVIDIA A100 PCIe`, so pass
`GPU='NVIDIA GeForce RTX 4090'`. It does not read pod-probe.json yet.
`DRY=1` prints the mutation then exits 1 "no capacity" — read the print, not the code.
remote-boot.sh makes the five symlinks (ln -sfnT into /workspace/comfy).
remote-prep.sh re-pins torch only. Skip neither.
Recipe and pins: RECIPE.md. Gates: NEXT.md. Resume: RESUME.md.
Volume record: master/anchors/checkpoint/RECORD.md — file, sha256, licence.

## Fleet B — judge now, render deferred
Judge first after the anchors: A100-SXM4-80GB at $2.19/hr, proven there.
Render waits for the master anchor locks; no CG job runs before them.
Judge: boot-judge.sh, setup-judge.sh, push-judge.sh, judge-eval.py,
vision-smoke.py, judge-discrim.py. Manifest: judge-manifest.json.
Render: boot-render.sh, setup-render.sh, pull-render.sh. ComfyUI is master; create in rotn-src deploy/render/.
Fleet B never writes anchors; it may attach the volume for models only.

## Command shapes — kebab, runpodctl
runpodctl pod create --name N --image I --gpu-id G --gpu-count 1 \
  --cloud-type COMMUNITY --data-center-ids DC --network-volume-id V \
  --volume-mount-path /workspace --container-disk-in-gb 60 \
  --ports '8188/http,22/tcp' --ssh --env '{"HF_TOKEN":"..."}' -o json
runpodctl pod list | pod get ID | pod stop ID | pod start ID | pod delete ID
runpodctl network-volume create --name N --size 150 --data-center-id DC
runpodctl network-volume list | get ID | delete ID
`pod create` is kebab; camelCase 400s. Unverified: the `network-volume`
subverb and the `pod create` flag set — check `--help` before first use.
Runtime ip and port: gql.sh with x-api-key. runpodctl and v2.sh send Bearer, 401.
Exec API is 403 with this key; ssh is the only route.

## HF mirrors — private
rotn-pilot (anchor), rotn-judge-env (judge), rotn-render-env (render, deferred).
Token via hf auth, expires 2026-12-19; pod env HF_TOKEN at create only.
Never a token in a repo, image or prompt.
mirror.sh, push.sh, push-judge.sh upload; pull.sh, pull-public.sh, pull-render.sh fetch.
pull-render.sh floors at 1GB so a stub pull fails loudly.

## Volume — one, never delete
39dhm3ia6u rotn-vol, 150GB, EU-RO-1, mount /workspace.
Holds NoobAI 7.1GB, xinsir ControlNet 2.5GB, LoRAs, outputs, ComfyUI tree.
Recreate only from master/anchors/checkpoint/RECORD.md and licence/RECORD.md.
Prune: DRY=1 DAYS=7 prune.sh HOST PORT; orphans are ids absent from attempts.jsonl.

## Rules
One fleet per pod, never both. pod-down.sh or pod stop before leaving.
A stopped pod still bills its disk; delete when a re-pull is cheaper.
