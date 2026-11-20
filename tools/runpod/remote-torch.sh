#!/usr/bin/env bash
set -euo pipefail
pkill -f main.py || true
pip install -q --no-cache-dir --index-url https://download.pytorch.org/whl/cu124 --upgrade torch torchvision torchaudio > /workspace/torch.log 2>&1
python -c 'import torch;print(torch.__version__)' >> /workspace/torch.log
cd /opt/ComfyUI
nohup python main.py --listen 0.0.0.0 --port 8188 --fp16-unet > /workspace/comfy/comfy.log 2>&1 &
echo restarted >> /workspace/torch.log
