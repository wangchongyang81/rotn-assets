#!/usr/bin/env bash
set -euo pipefail
N=rotn-render; V=39dhm3ia6u; KEY=$HOME/.ssh/id_ed25519
if { runpodctl pod list 2>/dev/null; runpodctl get pod 2>/dev/null; } | grep -q rotn-render; then echo already_exists; exit 1; fi
JID=$(bash tools/hf/judge-id.sh)
read -r JIP JSPORT <<<"$(runpodctl pod get "$JID" | python3 -c "import json,sys;s=json.load(sys.stdin)['ssh'];print(s['ip'],s['port'])")"
TOK=$(ssh -n -o BatchMode=yes -o StrictHostKeyChecking=no -i $KEY -p $JSPORT root@$JIP 'cat /workspace/.hf_token')
test -n "$TOK" || { echo no_token; exit 1; }
echo "creating $N on $V (reused, EU-RO-1)"
runpodctl pod create --name "$N" \
  --imageName runpod/pytorch:1.0.3-cu1281-torch291-ubuntu2404 \
  --gpuType 'NVIDIA A100-SXM4-80GB' --gpuCount 1 --communityCloud \
  --dataCenterId EU-RO-1 --networkVolumeId "$V" --volumePath /workspace \
  --containerDiskSize 60 --ports '8002/http,22/tcp' --startSSH \
  --env "HF_TOKEN=$TOK" -o json > /tmp/render-create.json
ID=$(python3 -c 'import json;print(json.load(open("/tmp/render-create.json"))["id"])')
echo "created $ID"
IP=""
for i in $(seq 40); do
  IP=$(runpodctl pod get "$ID" 2>/dev/null | python3 -c 'import json,sys;s=json.load(sys.stdin).get("ssh") or {};print(s.get("ip") or "")' || echo "")
  test -n "$IP" && { echo "ssh_up $IP"; break; }
  echo "wait_ssh $i"; sleep 6
done
test -n "$IP" || { echo no_ssh; exit 1; }
SPORT=$(runpodctl pod get "$ID" | python3 -c 'import json,sys;print(json.load(sys.stdin)["ssh"]["port"])')
S="ssh -n -o BatchMode=yes -o StrictHostKeyChecking=no -o ConnectTimeout=8 -o ServerAliveInterval=15 -o ServerAliveCountMax=3 -i $KEY -p $SPORT root@$IP"
$S 'mkdir -p /workspace/render-out /workspace/anchors /workspace/models/render /workspace/rotn-assets; ls /workspace | head -8'
$S "printf '%s' '$TOK' > /workspace/.hf_token; chmod 600 /workspace/.hf_token"
echo "render_created $ID $IP:$SPORT"
