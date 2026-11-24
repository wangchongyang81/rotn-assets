#!/usr/bin/env bash
set -euo pipefail
R=/workspace/rotn-assets; C=/workspace/ComfyUI; L=/workspace/render-run.log; KEY=$HOME/.ssh/id_ed25519
ID=${1:-$(bash tools/hf/judge-id.sh)}
read -r IP SPORT <<<"$(runpodctl pod get "$ID" | python3 -c "import json,sys;s=json.load(sys.stdin)['ssh'];print(s['ip'],s['port'])")"
S="ssh -o StrictHostKeyChecking=no -o ConnectTimeout=8 -o ServerAliveInterval=15 -o ServerAliveCountMax=3 -i $KEY -p $SPORT root@$IP"
say(){ echo "[$(date +%T)] $*"; }; say "setup-render $ID $IP:$SPORT"
$S 'nvidia-smi --query-gpu=name,memory.total,driver_version --format=csv,noheader'
$S 'test -s /workspace/.hf_token' || { echo no_token; exit 1; }
$S "mkdir -p $R/deploy/render /workspace/render-out /workspace/anchors /workspace/models/render"
set +o pipefail; tar -czf - deploy tools | $S "tar -xzf - --no-same-owner -C $R"; set -o pipefail
$S "chmod +x $R/deploy/render/*.sh $R/tools/hf/*.sh"
say comfyui
REF=$(cd $R && git show HEAD:deploy/render/pin.txt 2>/dev/null || echo master)
$S "test -d $C/.git || git clone -q https://github.com/comfyanonymous/ComfyUI $C"
$S "cd $C && git fetch -q --all && git checkout -q $REF"
$S "cd $C && git rev-parse --short HEAD"
$S "cd $C && python3 -m pip install -q -r requirements.txt --break-system-packages" || echo pip_warn
bash $R/deploy/render/verify-render.sh "$ID" || { echo flag_mismatch; exit 1; }
say nginx; $S 'command -v nginx >/dev/null || { apt-get update -qq && apt-get install -y -qq nginx; }'
$S 'test -f /etc/nginx/sites-enabled/render || cat > /etc/nginx/sites-enabled/render <<"NG"
server { listen 8002; location / { proxy_pass http://127.0.0.1:8188; proxy_http_version 1.1; proxy_set_header Upgrade $http_upgrade; proxy_set_header Connection upgrade; } }
NG'

$S 'nginx -t && nginx -s reload'
say weights
$S "cd $R && test -s /workspace/models/render/.done || bash tools/hf/pull-render.sh" || echo pull_missing
say stop_old
$S "pkill -f '[m]ain.py'; for i in $(seq 20); do pgrep -f '[m]ain.py' >/dev/null || break; sleep 2; done"
$S ": > $L"
say launch
$S "cd $C && setsid nohup bash $R/deploy/render/serve-render.sh > $L 2>&1 < /dev/null &"
$S "sleep 8; pgrep -f '[m]ain.py' >/dev/null || { echo launch_failed; tail -15 $L; exit 1; }"
say warm
for i in $(seq 20); do
  $S "curl -s --max-time 4 http://127.0.0.1:8188/queue | grep -q queue_remaining" && { echo "up $i"; break; }
  echo "tick $i"; sleep 9
done
$S 'curl -s --max-time 4 http://127.0.0.1:8188/queue | grep -q queue_remaining' || { echo not_up; $S "tail -15 $L"; exit 1; }
$S 'curl -s --max-time 4 http://127.0.0.1:8002/queue | grep -q queue_remaining' && echo proxy_ok || echo proxy_bad
echo "render_ready $ID"
