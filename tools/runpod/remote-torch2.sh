#!/usr/bin/env bash
set -uo pipefail
pkill -f main.py || true
pip install -q --no-cache-dir --index-url https://download.pytorch.org/whl/cu128 --upgrade torch torchvision torchaudio > /workspace/torch2.log 2>&1
echo "rc=$?" >> /workspace/torch2.log
python -c 'import torch;print(torch.__version__)' >> /workspace/torch2.log
cd /opt/ComfyUI
nohup python main.py --listen 0.0.0.0 --port 8188 --fp16-unet > /workspace/comfy/comfy.log 2>&1 &
echo restarted >> /workspace/torch2.log
