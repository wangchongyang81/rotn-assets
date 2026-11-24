#!/usr/bin/env bash
set -euo pipefail
V=/workspace/models/render; M=/workspace/ComfyUI/models/checkpoints
R=/workspace/rotn-assets
: "${HF_TOKEN:?HF_TOKEN unset}"
[ -d "$R/tools/hf" ] || { echo "clone rotn-assets to $R"; exit 1; }
mkdir -p "$V" "$M"
if [ ! -s "$V/noobaiXL.safetensors" ] || [ "${FORCE_PULL:-0}" = 1 ]; then
  bash "$R/tools/hf/pull.sh" render
fi
[ -s "$V/noobaiXL.safetensors" ] || { echo "no checkpoint after pull"; exit 1; }
ln -sf "$V/noobaiXL.safetensors" "$M/noobaiXL.safetensors"
cd /workspace/ComfyUI
exec python main.py --listen 0.0.0.0 --port 8188 --fp16-unet
