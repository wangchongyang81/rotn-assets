#!/usr/bin/env bash
set -euo pipefail
mkdir -p /workspace/comfy/models/checkpoints /workspace/comfy/models/controlnet /workspace/comfy/models/loras /workspace/comfy/output /workspace/comfy/input
cd /opt
[ -d ComfyUI ] || git clone -q https://github.com/comfyanonymous/ComfyUI.git
cd ComfyUI
git checkout -q 8f40b43e0204d5b9780f3e9618e140e929e80594
pip install -q -r requirements.txt
python -c "import torch,torchaudio,sys;sys.exit(0 if torch.__version__.startswith('2.8') else 1)" 2>/dev/null || pip install -q --index-url https://download.pytorch.org/whl/cu128 torch==2.8.0 torchvision==0.23.0 torchaudio==2.8.0
ln -sfn /workspace/comfy/models/checkpoints models/checkpoints
ln -sfn /workspace/comfy/models/controlnet models/controlnet
ln -sfn /workspace/comfy/models/loras models/loras
ln -sfn /workspace/comfy/output output
ln -sfn /workspace/comfy/input input
nohup python main.py --listen 0.0.0.0 --port 8188 --fp16-unet > /workspace/comfy/comfy.log 2>&1 &
echo started
