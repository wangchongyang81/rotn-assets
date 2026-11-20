#!/usr/bin/env bash
set -euo pipefail
mkdir -p /workspace/comfy/models/checkpoints /workspace/comfy/models/controlnet /workspace/comfy/models/loras /workspace/comfy/output
cd /opt
[ -d ComfyUI ] || git clone -q https://github.com/comfyanonymous/ComfyUI.git
cd ComfyUI
git checkout -q 8f40b43e0204d5b9780f3e9618e140e929e80594
pip install -q -r requirements.txt
ln -sfn /workspace/comfy/models/checkpoints models/checkpoints
ln -sfn /workspace/comfy/models/controlnet models/controlnet
ln -sfn /workspace/comfy/models/loras models/loras
ln -sfn /workspace/comfy/output output
nohup python main.py --listen 0.0.0.0 --port 8188 --fp16-unet > /workspace/comfy/comfy.log 2>&1 &
echo started
