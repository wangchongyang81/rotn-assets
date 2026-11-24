#!/usr/bin/env bash
set -euo pipefail
ID=${1:?pod id}; ROLE=${2:?render|judge}
case "$ROLE" in
  render) PORT=8188; HEALTH=/system_stats; BOOT=tools/hf/boot-render.sh ;;
  judge)  PORT=8001; HEALTH=/v1/models;    BOOT=tools/hf/boot-judge.sh ;;
  *) echo "role must be render or judge"; exit 1 ;;
esac
J=$(runpodctl pod get "$ID")
read -r IP SPORT <<<"$(printf '%s' "$J" | python3 -c "import json,sys;d=json.load(sys.stdin)['ssh'];print(d['ip'],d['port'])")"
echo "pod $ID ssh $IP:$SPORT role $ROLE"
SSH="ssh -o StrictHostKeyChecking=no -o ConnectTimeout=10 -p $SPORT root@$IP"
$SSH 'mkdir -p /workspace/rotn-assets'
tar -czf - --exclude=.git --exclude=node_modules . | $SSH 'tar -xzf - -C /workspace/rotn-assets'
$SSH 'chmod +x /workspace/rotn-assets/tools/hf/*.sh'
$SSH "cd /workspace/rotn-assets && nohup bash $BOOT > /workspace/boot.log 2>&1 &"
echo "boot started, polling $PORT$HEALTH"
for i in $(seq 40); do
  if $SSH "curl -sf --max-time 4 http://127.0.0.1:$PORT$HEALTH >/dev/null"; then
    echo "healthy after $i"; exit 0
  fi
  sleep 10
done
echo "unhealthy, boot.log tail:"; $SSH 'tail -20 /workspace/boot.log'; exit 1
