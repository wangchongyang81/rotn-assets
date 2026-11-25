# PODS — two fleets, one volume

Print this with WORKPLAN and REPOS.md at every arrival. It is the tooling
inventory, not a suggestion. No live pod is assumed: id, ip and port change
every start.

## Region — EU-RO-1 only
The 150GB volume is there and a pod must share its datacenter to mount it.
US-MO-1 was mooted for stock and rejected. Do not re-moot it.
Stock sits per-datacenter under dataCenterAvailability on the gpu list.

## Fleet A — anchor lock pilot (4090)
Purpose: per-pose anchors, skeletons and sheets for the art lock.
Host: SECURE EU-RO-1, 4090, volume 39dhm3ia6u at /workspace, disk 50.
Order: create.sh -> up-connect.sh -> remote-boot.sh -> remote-prep.sh ->
remote-aux.sh -> remote-dl.sh -> remote-cn.sh -> remote-smoke.sh.
Then render: remote-tskel3.sh or remote-ppose.sh, remote-sheet.sh,
MAX=4 loop.sh H P pose out seed, then prune.sh, then pod-down.sh.
create.sh reads pod-probe.json and retries; EU-RO-1 4090 stock is Low.
Recipe and hard pins: RECIPE.md. Gates: NEXT.md. Resume point: RESUME.md.
Never skip remote-prep.sh: it re-pins torch and makes the five symlinks.

## Fleet B — judge and render (80GB+)
Purpose: VLM judging of renders, and ComfyUI rendering for CGs.
Host: EU-RO-1 only. Judge proven on A100-SXM4-80GB there.
Judge: boot-judge.sh, setup-judge.sh, push-judge.sh, judge-eval.py,
vision-smoke.py, judge-discrim.py. Manifest: judge-manifest.json.
Render: boot-render.sh, setup-render.sh, pull-render.sh. ComfyUI is master.
The render create script lives in rotn-src deploy/render/, not here.
Fleet B never writes anchors; it may attach the volume for models only.

## Command shapes — kebab, runpodctl
runpodctl pod create --name N --image I --gpu-id G --gpu-count 1 \
  --cloud-type COMMUNITY --data-center-ids DC --network-volume-id V \
  --volume-mount-path /workspace --container-disk-in-gb 60 \
  --ports '8002/http,22/tcp' --ssh --env '{"HF_TOKEN":"..."}' -o json
runpodctl pod list | pod get ID | pod stop ID | pod start ID | pod delete ID
runpodctl network-volume create --name N --size 150 --data-center-id DC
runpodctl network-volume list | get ID | delete ID
`create network-volume` is no verb. `pod create` is kebab; camelCase 400s.
The datacenter list has no available key and cannot answer stock at all.
Runtime ip and port: gql.sh with x-api-key. runpodctl and v2.sh send Bearer, 401.
Exec API is 403 with this key; ssh is the only route.

## HF mirrors — private
rotn-pilot (anchor), rotn-judge-env (judge), rotn-render-env (render).
Token via hf auth, expires 2026-12-19. Pod env HF_TOKEN at create time only.
mirror.sh, push.sh, push-judge.sh upload; pull.sh, pull-public.sh, pull-render.sh fetch.
pull-render.sh floors at 1GB so a stub pull fails loudly.
Never a token in a repo, image or prompt.

## Volume — one, never delete
39dhm3ia6u rotn-vol, 150GB, EU-RO-1, mount /workspace.
Holds NoobAI 7.1GB, xinsir ControlNet 2.5GB, LoRAs, outputs, ComfyUI tree.
Recreate only from checkpoint/RECORD.md.
Prune: DRY=1 DAYS=7 prune.sh HOST PORT; orphans are ids absent from attempts.jsonl.

## Rules
One fleet per pod, never both. pod-down.sh or pod stop before leaving.
A stopped pod still bills its disk; delete when a re-pull is cheaper.
