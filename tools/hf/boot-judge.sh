#!/usr/bin/env bash
set -euo pipefail
V=/workspace/models/judge
R=/workspace/rotn-assets
: "${HF_TOKEN:?HF_TOKEN unset}"
[ -d "$R/tools/hf" ] || { echo "clone rotn-assets to $R"; exit 1; }
mkdir -p "$V"
if [ ! -s "$V/config.json" ] || [ "${FORCE_PULL:-0}" = 1 ]; then
  bash "$R/tools/hf/pull.sh" judge
fi
[ -s "$V/config.json" ] || { echo "no weights after pull"; exit 1; }
export MODEL="$V"
cd "$R"
exec bash tools/judge/serve-fp16.sh
