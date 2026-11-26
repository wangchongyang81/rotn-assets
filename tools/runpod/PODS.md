# PODS — one fleet, one volume

Print with WORKPLAN and REPOS.md at every arrival. No live pod is assumed;
id, ip and port change every start.

## Region — EU-RO-1 only
The 150GB volume is there and a pod must share its datacenter to mount it.
Region is forced by the volume and never chosen; US-MO-1 was rejected for stock.

## Stock — runpodctl only, proven 2026-11-25
GraphQL cannot answer stock; `dataCenterAvailability` is not a GpuType field
and Apollo introspection is disabled. Never a GraphQL probe.
`runpodctl gpu list` rows carry `dataCenterAvailability[].dataCenterId` and
`securePricePerHr`; keep EU-RO-1 rows and read `stockStatus`.
Proven live, all Low: 4090 $0.89/hr, A100 $2.19/hr, RTX PRO 6000 $2.69/hr.

## Fleet — rotn-render
One fleet, one pod, one role. 4090, SECURE EU-RO-1, volume 39dhm3ia6u at
/workspace, disk 50, ports 8188/http and 22/tcp.
`bash create.sh` (reads pod-probe.json) -> up-connect.sh -> boot-render.sh.
Fleet B and the judge pod are retired; judge tooling is gone. Art and CG
direction is being replanned, so no render sequence is fixed beyond the boot.
The volume keeps NoobAI, ControlNet, LoRAs, outputs and ComfyUI. Never delete it.

## Command shapes — kebab, runpodctl
create.sh builds `pod create`; it is kebab, camelCase 400s, and the
`network-volume` subverb and flag set are unverified — check `--help` first.
runpodctl pod list | pod get ID | pod stop ID | pod start ID | pod delete ID
Runtime ip and port: gql.sh with x-api-key; runpodctl and v2.sh send Bearer, 401.
The Exec API is 403 with this key, so ssh is the only route.

## HF mirrors — private
rotn-pilot only; rotn-judge-env and rotn-render-env are deleted.
Token via hf auth, expires 2026-12-19; pod env HF_TOKEN at create only, never a repo.
mirror.sh and push.sh upload; pull.sh and pull-public.sh fetch.

## Rules
pod-down.sh or pod stop before leaving; a stopped pod still bills its disk.
Prune: DRY=1 DAYS=7 prune.sh HOST PORT; orphans are ids absent from attempts.jsonl.
