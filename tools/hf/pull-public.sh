#!/usr/bin/env bash
set -euo pipefail
D=${1:?render|judge}
case "$D" in
  judge) R=Qwen/Qwen2.5-VL-7B-Instruct; T=/workspace/models/judge ;;
  render) R=Laxhar/noobai-XL-1.1; T=/workspace/models/render ;;
esac
python3 -c "import huggingface_hub" 2>/dev/null \
  || python3 -m pip install -q -U --break-system-packages huggingface_hub
mkdir -p "$T"
python3 - "$R" "$T" <<'PY'
import sys
from huggingface_hub import snapshot_download
snapshot_download(sys.argv[1], local_dir=sys.argv[2], repo_type="model")
print("pulled public", sys.argv[1])
PY
