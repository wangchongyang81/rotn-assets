#!/usr/bin/env bash
set -euo pipefail
k=$(awk -F"'" '/^apikey/{print $2}' "$HOME/.runpod/config.toml" 2>/dev/null || true)
[[ -z $k ]] && { echo 'no runpod key: run tools/runpod/key-set.sh' >&2; exit 1; }
export RUNPOD_API_KEY=$k
