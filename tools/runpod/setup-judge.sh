#!/usr/bin/env bash
set -euo pipefail
M=$(python -c 'import json;print(json.load(open("/workspace/judge/manifest.json"))["model"])')
pip install -q --break-system-packages -U transformers accelerate qwen-vl-utils pillow
hf download "$M" --local-dir /workspace/judge/model
echo SETUP_OK
