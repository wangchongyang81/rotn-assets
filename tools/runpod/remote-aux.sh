#!/usr/bin/env bash
set -uo pipefail
mkdir -p /opt/ComfyUI/custom_nodes
cd /opt/ComfyUI/custom_nodes
[ -d comfyui_controlnet_aux ] || git clone -q https://github.com/Fannovel16/comfyui_controlnet_aux.git
cd comfyui_controlnet_aux
echo "head $(git rev-parse --short HEAD)" > /workspace/aux.log
pip install -q -r requirements.txt >> /workspace/aux.log 2>&1
echo "req rc=$?" >> /workspace/aux.log
pip install -q --no-cache-dir --index-url https://download.pytorch.org/whl/cu128 --upgrade torch==2.8.0 torchvision torchaudio >> /workspace/aux.log 2>&1
python -c 'import torch;print("torch",torch.__version__)' >> /workspace/aux.log
pkill -f main.py || true
sleep 2
cd /opt/ComfyUI
nohup python main.py --listen 0.0.0.0 --port 8188 --fp16-unet > /workspace/comfy/comfy.log 2>&1 &
sleep 20
curl -s -o /dev/null -w "local %{http_code}\n" http://127.0.0.1:8188/
curl -s http://127.0.0.1:8188/object_info | python3 -c 'import json,sys;d=json.load(sys.stdin);print("pose",[k for k in d if "pose" in k.lower()][:5])'
