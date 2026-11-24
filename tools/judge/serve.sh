#!/usr/bin/env bash
set -euo pipefail
exec vllm serve "${MODEL:-Qwen/Qwen2.5-VL-7B-Instruct-AWQ}" \
  --served-model-name judge \
  --quantization awq \
  --max-model-len 8192 \
  --limit-mm-per-prompt '{"image": 2}' \
  --gpu-memory-utilization 0.85 \
  --guided-decoding-backend xgrammar \
  --enforce-eager \
  --host 0.0.0.0 --port 8001
