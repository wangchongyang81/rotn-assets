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

## Fleet B — render, then judge
One fleet, two pods. Never both roles on one pod.
Sequential on one volume: judge follows render, never beside it.
Render runs the master anchor lock automation first: skeletons, anchors, sheets.
CG runs only after every master anchor lock is generated.
Judge follows the render to score it; judge needs A100-SXM4-80GB.
Render: 4090, SECURE EU-RO-1, volume 39dhm3ia6u at /workspace, disk 50, ports 8188/http and 22/tcp.
Order: PROBE=render.json create.sh -> up-connect.sh -> remote-boot.sh ->
remote-prep.sh -> remote-aux.sh -> remote-dl.sh -> remote-cn.sh -> remote-smoke.sh.
Then remote-tskel3.sh or remote-ppose.sh, remote-sheet.sh, MAX=4 loop.sh H P pose out seed,
prune.sh, pod-down.sh.
Judge tooling committed 8ad199d; model Qwen2.5-VL-7B-Instruct (Apache-2.0).
Judge probe: judge.json, A100-SXM4-80GB, PROBE=judge.json create.sh.
Judge pod goes up only after the render pod is down; anchors never wait on it.
Neither role writes the other's outputs.
Models: remote-dl.sh checkpoint, remote-cn.sh ControlNet; aux pin c2655d2 is real HEAD.
No LoRA downloader exists; the anchor smoke needs none. Open.

## Command shapes — kebab, runpodctl
runpodctl pod create --name N --image I --gpu-id G --gpu-count 1 \
  --cloud-type SECURE --data-center-ids DC --network-volume-id V \
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
