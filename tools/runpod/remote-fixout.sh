#!/usr/bin/env bash
set -uo pipefail
ls -l /opt/ComfyUI/output/smoke_00001_.png
mkdir -p /workspace/comfy/output
mv /opt/ComfyUI/output/*.png /workspace/comfy/output/ 2>/dev/null || true
rm -rf /opt/ComfyUI/output
ln -sfn /workspace/comfy/output /opt/ComfyUI/output
readlink -f /opt/ComfyUI/output
ls -l /workspace/comfy/output | tail -3
pkill -f main.py || true
sleep 2
cd /opt/ComfyUI
nohup python main.py --listen 0.0.0.0 --port 8188 --fp16-unet > /workspace/comfy/comfy.log 2>&1 &
sleep 14
curl -s -o /dev/null -w "local %{http_code}\n" http://127.0.0.1:8188/
