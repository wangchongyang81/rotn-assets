#!/usr/bin/env bash
set -euo pipefail
C=/workspace/comfy/models/controlnet/openpose-xinsir-sdxl.safetensors
[ -s $C ] || aria2c -x8 -s8 -q -d /workspace/comfy/models/controlnet -o openpose-xinsir-sdxl.safetensors https://huggingface.co/xinsir/controlnet-openpose-sdxl-1.0/resolve/main/diffusion_pytorch_model.safetensors
echo cn_done >> /workspace/dl.log
