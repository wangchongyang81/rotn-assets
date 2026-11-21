#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/../.."
R=wangchongyang81/rotn-pilot
hf repos create "$R" --repo-type model --private --exist-ok >/dev/null
hf upload "$R" . --repo-type model --exclude '.git/*' --exclude '**/__pycache__/*' 2>&1 | tail -2
python - "$R" <<'PY'
import subprocess,sys
from huggingface_hub import HfApi
loc=set(subprocess.run(['git','ls-files'],capture_output=True,text=True).stdout.split())
rem=set(HfApi().list_repo_files(sys.argv[1],repo_type='model'))
print('local',len(loc),'remote',len(rem),'extra',len(rem-loc),'missing',len(loc-rem))
PY
