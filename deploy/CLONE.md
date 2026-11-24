# rebuild a judge pod from this repo

Prereq: A100-SXM4-80GB (81920 MiB), driver >= 580, `/workspace/.hf_token`
present with read+write on this repo.

1. note the pod id, then from the assets repo:
   bash tools/hf/setup-judge.sh <pod-id>
   It installs vllm 0.34.0, verifies flags, pulls weights, boots, smokes.
2. manual path, if setup is unavailable:
   python3 -c 'from huggingface_hub import snapshot_download as d; d("wangchongyang81/rotn-judge-env", local_dir="/workspace/models/judge", ignore_patterns=["deploy/*"])'
   cd /workspace/rotn-assets
   MODEL=/workspace/models/judge setsid nohup bash deploy/serve-fp16.sh > /workspace/serve-run.log 2>&1 < /dev/null &
3. health: GET 8000/v1/models must contain `judge`; 8001 proxies it.

Settings and pins: deploy/judge-manifest.json
Never add --guided-decoding-backend (gone in 0.34).
