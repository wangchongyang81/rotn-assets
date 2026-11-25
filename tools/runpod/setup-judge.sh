#!/usr/bin/env bash
set -euo pipefail
J=/workspace/judge
M=$(python -c 'import json;print(json.load(open("/workspace/judge/manifest.json"))["model"])')
pip install -q --break-system-packages -U transformers accelerate huggingface_hub qwen-vl-utils pillow
[ -s "$J/manifest.json" ] || { echo NOMANIFEST >&2; exit 1; }
python - "$M" <<'PY'
import sys
from huggingface_hub import snapshot_download
print("MODEL", snapshot_download(sys.argv[1], local_dir="/workspace/judge/model"))
PY
echo SETUP_OK
