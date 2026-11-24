#!/usr/bin/env bash
set -euo pipefail
V=/workspace/rotn-assets/deploy/render/serve-render.sh
ID=${1:-$(bash tools/hf/judge-id.sh)}
read -r IP SPORT <<<"$(runpodctl pod get "$ID" | python3 -c "import json,sys;s=json.load(sys.stdin)['ssh'];print(s['ip'],s['port'])")"
S="ssh -o StrictHostKeyChecking=no -o ConnectTimeout=8 -o ServerAliveInterval=15 -o ServerAliveCountMax=3 -i $HOME/.ssh/id_ed25519 -p $SPORT root@$IP"
test -s "$V" || { echo no_serve_file; exit 1; }
for f in listen port disable-auto-launch output-directory input-directory preview-method; do
  grep -q -- "--$f" "$V" && echo "OK $f" || { echo "MISSING $f"; exit 1; }
done
$S 'test -s /workspace/ComfyUI/main.py' || { echo no_comfyui; exit 1; }
$S 'cd /workspace/ComfyUI && python3 main.py --help 2>&1' > /tmp/render-help.txt
for f in listen port disable-auto-launch output-directory input-directory preview-method; do
  grep -q -- "--$f" /tmp/render-help.txt || { echo "UNSUPPORTED $f"; exit 1; }
done
$S 'grep -c "proxy_pass http://127.0.0.1:8188" /etc/nginx/sites-enabled/* 2>/dev/null' || echo nginx_unchecked
echo flags_ok
