#!/usr/bin/env bash
set -uo pipefail
V=/workspace/comfy
pkill -f "[m]ain.py" || true
sleep 3
cd /opt/ComfyUI
setsid nohup python main.py --listen 0.0.0.0 --port 8188 --fp16-unet > $V/comfy.log 2>&1 < /dev/null &
echo started
