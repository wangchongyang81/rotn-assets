# PODS - one fleet, one volume

No live pod is assumed. id, ip and port change every start.
Print this with WORKPLAN at every arrival.

## Region
EU-RO-1 only. The 150GB volume is there and a pod must share its
datacenter to mount it. Region is forced by the volume, never chosen.

## Access - resolve, never remember
1. id:      runpodctl pod list
2. ip/port: bash sshinfo.sh ID
3. ssh:     ssh -i ~/.ssh/id_ed25519 -p PORT root@IP

sshinfo.sh reads runtime.ports for private 22 and prints "IP PUBLIC".
Runtime is null while EXITED, so resolve only after RUNNING.
ssh.md holds a stale port; trust sshinfo.sh alone.
Proxy ssh.runpod.io rejects this key. Exec API is 403.
ssh is the only route.

## Stock - runpodctl only
GraphQL cannot answer stock and GET /gpus 404s on v2.
runpodctl gpu list > /tmp/gl.txt
Rows carry gpuId, memoryInGb, securePricePerHr and
dataCenterAvailability[].dataCenterId plus stockStatus.
Parse EU-RO-1 only:

python3 - <<'PY'
import json
for g in json.load(open('/tmp/gl.txt')):
    for s in (g.get('dataCenterAvailability') or []):
        if s.get('dataCenterId')=='EU-RO-1':
            print(g.get('gpuId'),g.get('memoryInGb'),s.get('stockStatus'))
PY

## Start - capacity refuses often
runpodctl pod start ID
Refusal reads "not enough free GPUs on the host machine".
Retry with sleep 40, or recreate on a stocked card:
GPU="NVIDIA GeForce RTX 4090" NAME=rotn-render bash create.sh
NAME matters: depart.sh filters names starting rotn.

## Known 404s on v2.sh
GET /gpus
POST /pods/ID/start  (use runpodctl pod start)

## Volume
39dhm3ia6u at /workspace, EU-RO-1, disk 50-60.
Keeps checkpoints, mirror, LoRAs, ComfyUI, outputs. Never delete.
