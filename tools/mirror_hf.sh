#!/usr/bin/env bash
set -euo pipefail
R=wangchongyang81/rotn-pilot
B=hf://buckets/wangchongyang81/rotn-bin
M=${1:-text}
case "$M" in
  text)
    python - "$R" <<'PYX'
import sys,pathlib
from huggingface_hub import HfApi,CommitOperationAdd
ops=[]
for d in ('art','docs','tools/runpod'):
    for f in pathlib.Path(d).rglob('*'):
        if f.is_file(): ops.append(CommitOperationAdd(f.as_posix().removeprefix('art/'),f.as_posix()))
print('ops',len(ops))
if ops: print(HfApi().create_commit(sys.argv[1],ops,repo_type='model',commit_message='mirror text').commit_id[:9])
PYX
    echo "mirrored text"
    ;;
  models)
    hf buckets sync /workspace/comfy/models "$B/models" --include '*.safetensors' --plan /root/models.plan
    echo "planned models - apply: hf buckets sync --apply /root/models.plan"
    ;;
  snapshots)
    hf buckets sync /workspace/images "$B/snapshots" --include '*.tar.gz' --plan /root/snaps.plan
    echo "planned snapshots - apply: hf buckets sync --apply /root/snaps.plan"
    ;;
  *) echo "usage: $0 text|models|snapshots"; exit 1;;
esac
