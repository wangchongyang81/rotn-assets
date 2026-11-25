#!/usr/bin/env bash
set -euo pipefail
J=${J:-/workspace/judge}
[ -s "$J/manifest.json" ] || { echo NOMANIFEST >&2; exit 1; }
M=$(python3 -c 'import json,sys;print(json.load(open(sys.argv[1]))["model"])' "$J/manifest.json")
if [[ ${DRY:-0} == 1 ]]; then echo "J=$J MODEL=$M"; exit 0; fi
pip install -q --break-system-packages -U transformers accelerate huggingface_hub qwen-vl-utils pillow
python3 - "$M" "$J" <<'PY'
import sys
from huggingface_hub import snapshot_download
print("MODEL", snapshot_download(sys.argv[1], local_dir=sys.argv[2] + "/model"))
PY
echo SETUP_OK
