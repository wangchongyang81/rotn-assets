#!/usr/bin/env bash
set -uo pipefail
cd "$(dirname "$0")"
[[ -n ${1:-} ]] || { echo 'usage: pod-down.sh POD_ID' >&2; exit 1; }
bash v2.sh DELETE "/pods/$1" | head -c 200; echo
