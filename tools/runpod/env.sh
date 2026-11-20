#!/usr/bin/env bash
set -uo pipefail
k=$(awk -F"'" '/^apikey *=/{if ($2!="") v=$2} END{print v}' "$HOME/.runpod/config.toml" 2>/dev/null || true)
[[ -z $k ]] && { echo 'no runpod key' >&2; return 0; }
export RUNPOD_API_KEY=$k
