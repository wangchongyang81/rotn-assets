#!/usr/bin/env bash
set -euo pipefail
MODEL=${MODEL:-Qwen/Qwen2.5-VL-7B-Instruct}
exec vllm serve "$MODEL" \
  --served-model-name judge \
  --dtype float16 \
  --max-model-len 8192 \
  --gpu-memory-utilization 0.85 \
  --host 0.0.0.0 \
  --port 8000
