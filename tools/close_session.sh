#!/usr/bin/env bash
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"
POD=${1:?usage: close_session.sh <pod-id>}
python tools/validate_manifests.py
python tools/parity.py
bash tools/mirror_hf.sh text
runpodctl pod get "$POD" > /tmp/cs.json 2>&1
H=$(python -c "import json;print((json.load(open('/tmp/cs.json')).get('ssh') or {}).get('ip',''))")
P=$(python -c "import json;print((json.load(open('/tmp/cs.json')).get('ssh') or {}).get('port',''))")
[ -n "$H" ] || { echo "no ssh ip on $POD"; exit 1; }
O="-o StrictHostKeyChecking=no -o ConnectTimeout=25 -i $HOME/.ssh/id_ed25519 -p $P"
T=$(hf auth token --format quiet)
ssh -n $O root@"$H" "umask 077; printf '%s' '$T' > /root/.hf_tok && hf auth login --token \"\$(cat /root/.hf_tok)\" --force >/dev/null"
scp -q -o StrictHostKeyChecking=no -i $HOME/.ssh/id_ed25519 -P "$P" tools/close_pod.sh root@"$H":/root/close_pod.sh
ssh -n $O root@"$H" 'bash /root/close_pod.sh'
echo "CLOSED $POD - terminate when ready"
