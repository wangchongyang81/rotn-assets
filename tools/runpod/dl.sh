#!/usr/bin/env bash
set -euo pipefail
U=${1:?url}; O=${2:?outfile}
T=/workspace/.civitai
[[ -s $T ]] || { echo "no token at $T" >&2; exit 1; }
D=/workspace/comfy/models/checkpoints
wget --header="Authorization: Bearer $(cat "$T")" -O "$D/$O" "$U"
ls -l "$D/$O"
