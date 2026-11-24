#!/usr/bin/env bash
set -euo pipefail
# pull render weights from the private mirror; ~1GB floor guards a stub pull
D=/workspace/models/render; R=${R:-wangchongyang81/rotn-render-env}
mkdir -p "$D"
python3 - <<PY
from huggingface_hub import snapshot_download
p=snapshot_download(repo_id="$R", repo_type="model", local_dir="$D",
  token=open("/workspace/.hf_token").read().strip(),
  allow_patterns=["*.safetensors","*.ckpt","*.pt","*.yaml","*.json"])
print("pulled", p)
PY
du -sh "$D"
python3 - <<PY
import glob,os,sys
b=sum(os.path.getsize(f) for f in glob.glob("$D/**/*",recursive=True) if os.path.isfile(f))
print("bytes",b); sys.exit(0 if b>1000000000 else 1)
PY
date -u +%FT%TZ > "$D/.done"
echo pull_render_ok
