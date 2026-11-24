#!/usr/bin/env bash
set -euo pipefail
export HF_TOKEN=$(cat /workspace/.hf_token)
R=wangchongyang81/rotn-judge-env
python3 - <<'PY'
from huggingface_hub import HfApi
R="wangchongyang81/rotn-judge-env"; a=HfApi()
a.upload_folder(folder_path="/workspace/models/judge", repo_id=R,
  repo_type="model", commit_message="weights: qwen2.5-vl-7b fp16")
print("weights_done")
a.upload_folder(folder_path="/workspace/rotn-assets/deploy", path_in_repo="deploy",
  repo_id=R, repo_type="model", commit_message="deploy: frozen judge config")
print("pushed")
PY
