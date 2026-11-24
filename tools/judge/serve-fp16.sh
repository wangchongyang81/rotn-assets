#!/usr/bin/env bash
set -euo pipefail
# PROVEN 2026-11-24 on A100-SXM4-80GB, EU-RO-1, driver 595.112.07
# image runpod/pytorch:1.0.3-cu1281-torch291-ubuntu2404
# pip install vllm==0.34.0 --break-system-packages (torch 2.9.1+cu128 -> 2.14.0+cu130)
# nginx owns public 8001 and proxies to 8000; vllm must bind 8000
# no --guided-decoding-backend in 0.34; structured output via config below
MODEL=${MODEL:-Qwen/Qwen2.5-VL-7B-Instruct}
exec vllm serve "$MODEL" \
  --served-model-name judge \
  --dtype float16 \
  --max-model-len 8192 \
  --gpu-memory-utilization 0.85 \
  --structured-outputs-config '{"backend":"xgrammar"}' \
  --host 0.0.0.0 \
  --port 8000
