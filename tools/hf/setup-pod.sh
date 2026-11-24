#!/usr/bin/env bash
set -euo pipefail
ID=${1:?pod id}; ROLE=${2:?render|judge}; KEY=${3:-$HOME/.ssh/id_ed25519}
case "$ROLE" in
  render) PORT=8188; HEALTH=/system_stats; MATCH=system; BOOT=tools/hf/boot-render.sh ;;
  judge)  PORT=8001; HEALTH=/v1/models;    MATCH=judge; BOOT=tools/hf/boot-judge.sh ;;
  *) echo "role must be render or judge"; exit 1 ;;
esac
J=$(runpodctl pod get "$ID")
read -r IP SPORT <<<"$(printf '%s' "$J" | python3 -c "
import json,sys
s=json.load(sys.stdin).get('ssh') or {}
print(s.get('ip') or '', s.get('port') or 22)")"
[ -n "$IP" ] || { echo "no ssh endpoint"; exit 1; }
SSH="ssh -o StrictHostKeyChecking=no -o ConnectTimeout=10 -i $KEY -p $SPORT root@$IP"
echo "pod $ID $ROLE $IP:$SPORT key $KEY"
$SSH 'mkdir -p /workspace/rotn-assets'
set +o pipefail
tar -czf - --exclude=.git --exclude=node_modules --exclude=archive . \
  | $SSH 'tar -xzf - --no-same-owner -C /workspace/rotn-assets'
RC=${PIPESTATUS[0]}
set -o pipefail
[ "$RC" -le 2 ] || { echo "tar failed rc=$RC"; exit 1; }
$SSH 'test -f /workspace/rotn-assets/tools/hf/boot-judge.sh' || { echo "tree missing"; exit 1; }
$SSH 'chmod +x /workspace/rotn-assets/tools/hf/*.sh'
if ! $SSH 'test -s /workspace/.hf_token || test -n "${HF_TOKEN:-}"'; then
  T=$(cat ~/.cache/huggingface/token 2>/dev/null || true)
  [ -n "$T" ] || { echo "no token local"; exit 1; }
  printf '%s' "$T" | $SSH 'cat > /workspace/.hf_token'; echo "token written"
fi
$SSH "cd /workspace/rotn-assets && nohup bash $BOOT > /workspace/boot.log 2>&1 &"
echo "boot started, polling $PORT$HEALTH"
for i in $(seq 40); do
  $SSH "curl -s --max-time 4 http://127.0.0.1:$PORT$HEALTH | grep -q '$MATCH'" && { echo "healthy $i"; exit 0; }
  sleep 10
done
echo unhealthy; $SSH 'tail -20 /workspace/boot.log'; exit 1
