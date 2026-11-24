#!/usr/bin/env bash
set -euo pipefail
V=/workspace/models/judge
R=/workspace/rotn-assets
[ -n "${HF_TOKEN:-}" ] || HF_TOKEN=$(cat /workspace/.hf_token 2>/dev/null || true)
[ -n "${HF_TOKEN:-}" ] || { echo "HF_TOKEN unset"; exit 1; }
export HF_TOKEN
[ -d "$R/tools/hf" ] || { echo "clone rotn-assets to $R"; exit 1; }
mkdir -p "$V"
if [ ! -s "$V/config.json" ] || [ "${FORCE_PULL:-0}" = 1 ]; then
  bash "$R/tools/hf/pull.sh" judge
fi
[ -s "$V/config.json" ] || { echo "no weights after pull"; exit 1; }
export MODEL="$V"
cd "$R"
exec bash tools/judge/serve-fp16.sh
