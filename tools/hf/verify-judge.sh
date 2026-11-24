#!/usr/bin/env bash
set -euo pipefail
KEY=$HOME/.ssh/id_ed25519; ID=${1:?pod id}
read -r IP SPORT <<<"$(runpodctl pod get "$ID" | python3 -c "import json,sys;s=json.load(sys.stdin)['ssh'];print(s['ip'],s['port'])")"
S="ssh -o StrictHostKeyChecking=no -o ConnectTimeout=8 -i $KEY -p $SPORT root@$IP"
$S 'vllm serve --help=all' > /tmp/all.txt 2>&1
grep -oE '\-\-[a-z0-9-]+' /tmp/all.txt | sort -u > /tmp/names.txt
BAD=0
for f in served-model-name dtype max-model-len gpu-memory-utilization host port; do
  grep -qx -- "--$f" /tmp/names.txt && echo "OK $f" || { echo "BAD $f"; BAD=1; }
done
[ "$BAD" -eq 0 ] && echo flags_ok || { echo flags_bad; exit 1; }
