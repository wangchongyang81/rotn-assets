#!/usr/bin/env bash
set -euo pipefail
C=/workspace/comfy/models/checkpoints/NoobAI-XL-v1.1.safetensors
[ -s $C ] || aria2c -x8 -s8 -q -d /workspace/comfy/models/checkpoints -o NoobAI-XL-v1.1.safetensors https://huggingface.co/Laxhar/noobai-XL-1.1/resolve/main/NoobAI-XL-v1.1.safetensors
echo ckpt_done >> /workspace/dl.log
