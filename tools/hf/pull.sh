#!/usr/bin/env bash
set -euo pipefail
D=${1:?render|judge}; NS=${HF_NS:-wangchongyang81}
case "$D" in
  judge) R=${JUDGE_REPO:-$NS/rotn-judge-env}; T=/workspace/models/judge ;;
  render) R=${RENDER_REPO:-$NS/rotn-render-env}; T=/workspace/models/render ;;
esac
python3 -c "import huggingface_hub" 2>/dev/null \
  || python3 -m pip install -q -U --break-system-packages huggingface_hub
mkdir -p "$T"
python3 - "$R" "$T" <<'PY'
import sys
from huggingface_hub import snapshot_download
snapshot_download(sys.argv[1], local_dir=sys.argv[2], repo_type="model")
print("pulled", sys.argv[1])
PY
