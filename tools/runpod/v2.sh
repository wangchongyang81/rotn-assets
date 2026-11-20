#!/usr/bin/env bash
set -uo pipefail
k=$(awk -F"'" '/^apikey *=/{if ($2!="") v=$2} END{print v}' "$HOME/.runpod/config.toml")
[[ -z $k ]] && { echo 'no runpod key' >&2; exit 1; }
m=${1:?method}; p=${2:?path}; b=${3:-}
a=(); [[ -n $b ]] && a=(--data "$b")
exec curl -sS -m 40 -X "$m" "https://api.runpod.io/v2$p" \
  -H 'content-type: application/json' -H "Authorization: Bearer $k" "${a[@]}"
