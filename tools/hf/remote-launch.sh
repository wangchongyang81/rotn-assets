#!/usr/bin/env bash
set -euo pipefail
R=/workspace/rotn-assets
ID=$(bash tools/hf/judge-id.sh)
read -r IP SPORT <<<"$(runpodctl pod get "$ID" | python3 -c "import json,sys;s=json.load(sys.stdin)['ssh'];print(s['ip'],s['port'])")"
SSH="ssh -n -o BatchMode=yes -o StrictHostKeyChecking=no -o ConnectTimeout=8 -o ServerAliveInterval=15 -o ServerAliveCountMax=3 -i $HOME/.ssh/id_ed25519 -p $SPORT root@$IP"
say(){ echo "[$(date +%T)] $*"; }; say "launch $ID"
set +o pipefail; tar -czf - tools | $SSH "tar -xzf - --no-same-owner -C $R"; set -o pipefail
$SSH "chmod +x $R/tools/hf/*.sh; setsid nohup bash $R/tools/hf/remote-run.sh > /tmp/rr.log 2>&1 < /dev/null & echo fired"
for i in $(seq 120); do
  L=$(timeout 10 $SSH 'tail -1 /tmp/rr.log' || echo poll_timeout)
  case "$L" in *judge_ready*|*launch_failed*|*not_up*|*no_*) echo "final $L"; break;; esac
  say "wait $i"; sleep 5
done
timeout 12 $SSH 'grep -viE deprecat /tmp/rr.log | tail -12'
