#!/usr/bin/env bash
set -euo pipefail
U=${1:?url}; O=${2:?outfile}
T=/workspace/.civitai
[[ -s $T ]] || { echo "no token at $T" >&2; exit 1; }
K=$(cat "$T")
D=/workspace/comfy/models/checkpoints
case "$U" in *\?*) S="&";; *) S="?";; esac
curl -L -f -sS --retry 3 --retry-delay 5 -C - \
  -A 'Mozilla/5.0' -H "Authorization: Bearer $K" \
  -o "$D/$O" "$U${S}token=$K"
echo "got $O"
ls -l "$D/$O"
