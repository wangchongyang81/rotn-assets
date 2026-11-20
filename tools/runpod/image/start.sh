#!/usr/bin/env bash
set -euo pipefail
cd /opt/ComfyUI
exec python main.py --listen 0.0.0.0 --port 8188 --fp16-unet
