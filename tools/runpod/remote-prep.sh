#!/usr/bin/env bash
set -uo pipefail
V=/workspace/comfy
[ -d /opt/ComfyUI ] || { echo NOCOMFY >&2; exit 1; }
pkill -f "[m]ain.py" || true
mkdir -p "$V/output" "$V/input"
pip install -q --break-system-packages --no-cache-dir \
  --index-url https://download.pytorch.org/whl/cu128 --upgrade torch==2.8.0 torchvision torchaudio > "$V/torch.log" 2>&1
python -c 'import torch;print(torch.__version__)' >> "$V/torch.log"
cd /opt/ComfyUI
for d in output input; do rm -rf "$d"; done
ln -sfnT "$V/output" output
ln -sfnT "$V/input" input
readlink -f output input
setsid nohup python main.py --listen 0.0.0.0 --port 8188 --fp16-unet > "$V/comfy.log" 2>&1 < /dev/null &
for i in $(seq 1 20); do
  c=$(curl -s -o /dev/null -w '%{http_code}' http://127.0.0.1:8188/ || true)
  [ "$c" = "200" ] && { echo "PREP OK $c"; exit 0; }
  sleep 3
done
echo "PREP FAIL $(tail -3 "$V/comfy.log" | cut -c1-80)" >&2; exit 1
