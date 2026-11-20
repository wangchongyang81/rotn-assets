#!/usr/bin/env bash
set -uo pipefail
pkill -f main.py || true
pip install -q --no-cache-dir --index-url https://download.pytorch.org/whl/cu128 --upgrade torch==2.8.0 torchvision torchaudio > /workspace/torch28.log 2>&1
echo "rc=$?" >> /workspace/torch28.log
python -c 'import torch;print(torch.__version__)' >> /workspace/torch28.log
cd /opt/ComfyUI
nohup python main.py --listen 0.0.0.0 --port 8188 --fp16-unet > /workspace/comfy/comfy.log 2>&1 &
sleep 18
curl -s -o /dev/null -w "local %{http_code}\n" http://127.0.0.1:8188/
tail -4 /workspace/comfy/comfy.log
