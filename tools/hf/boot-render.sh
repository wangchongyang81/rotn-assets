#!/usr/bin/env bash
set -euo pipefail
V=/workspace/models/render; M=/workspace/ComfyUI/models/checkpoints
R=/workspace/rotn-assets
[ -n "${HF_TOKEN:-}" ] || HF_TOKEN=$(cat /workspace/.hf_token 2>/dev/null || true)
[ -n "${HF_TOKEN:-}" ] || { echo "HF_TOKEN unset"; exit 1; }
export HF_TOKEN
[ -d "$R/tools/hf" ] || { echo "clone rotn-assets to $R"; exit 1; }
mkdir -p "$V" "$M"
if [ ! -s "$V/noobaiXL.safetensors" ] || [ "${FORCE_PULL:-0}" = 1 ]; then
  bash "$R/tools/hf/pull.sh" render
fi
[ -s "$V/noobaiXL.safetensors" ] || { echo "no checkpoint after pull"; exit 1; }
ln -sf "$V/noobaiXL.safetensors" "$M/noobaiXL.safetensors"
cd /workspace/ComfyUI
exec python main.py --listen 0.0.0.0 --port 8188 --fp16-unet
