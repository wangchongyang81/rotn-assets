#!/usr/bin/env bash
set -uo pipefail
k=$(awk -F"'" '/^apikey *=/{if ($2!="") v=$2} END{print v}' "$HOME/.runpod/config.toml")
[[ -z $k ]] && { echo 'no runpod key: tools/runpod/key-set.sh' >&2; exit 1; }
exec curl -sS -m 40 -X POST https://api.runpod.io/graphql \
  -H 'content-type: application/json' -H "x-api-key: $k" --data "${1:?query required}"
