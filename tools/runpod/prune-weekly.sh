#!/usr/bin/env bash
set -uo pipefail
cd "$(dirname "$0")/../.."
ST=/tmp/prune.stamp; NOW=$(date +%s)
if [ -f "$ST" ]; then
  last=$(cat "$ST"); [ $(( (NOW-last)/86400 )) -lt 7 ] && { echo "prune: $(( (NOW-last)/86400 ))d old, skip"; exit 0; }
fi
H=$(awk 'NR==1{print $2}' /tmp/pod.env 2>/dev/null); P=$(awk 'NR==1{print $3}' /tmp/pod.env 2>/dev/null)
if [ -n "${H:-}" ] && [ -n "${P:-}" ]; then DRY=${DRY:-1} DAYS=7 bash tools/runpod/prune.sh "$H" "$P"
else echo 'prune: no pod, hf only'; DRY=${DRY:-0} DAYS=7 bash tools/runpod/prune.sh "" ""; fi
echo "$NOW" > "$ST"
