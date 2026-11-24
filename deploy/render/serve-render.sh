#!/usr/bin/env bash
set -euo pipefail
# SCAFFOLD -- never booted. No line below is proven.
# image runpod/pytorch:1.0.3-cu1281-torch291-ubuntu2404
# nginx owns public 8002 and proxies to 8188; ComfyUI must bind 8188
# REF must be pinned to a commit before this counts as proven
COMFY=${COMFY:-/workspace/ComfyUI}
REF=${REF:-unpinned}
CKPT=${CKPT:-NoobAI-XL}
export COMFY REF CKPT
cd "$COMFY"
exec python3 main.py \
  --listen 0.0.0.0 \
  --port 8188 \
  --disable-auto-launch \
  --preview-method none \
  --output-directory /workspace/render-out \
  --input-directory /workspace/anchors
