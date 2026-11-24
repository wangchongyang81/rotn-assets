#!/usr/bin/env bash
set -euo pipefail
exec vllm serve "${MODEL:-Qwen/Qwen2.5-VL-7B-Instruct}" \ \ \ \ \ \ \
