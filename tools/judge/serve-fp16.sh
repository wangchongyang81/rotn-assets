#!/usr/bin/env bash
set -euo pipefail
exec vllm serve "${MODEL:-Qwen/Qwen2.5-VL-7B-Instruct}" \
  --served-model-name judge \
  --dtype float16 \
  --max-model-len 8192 \
  --limit-mm-per-prompt '{"image": 2}' \
  --gpu-memory-utilization 0.85 \
  --guided-decoding-backend xgrammar \
  --host 0.0.0.0 --port 8000
