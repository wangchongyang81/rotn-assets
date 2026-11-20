#!/usr/bin/env bash
set -uo pipefail
cd "$(dirname "$0")"
[[ -f pod-probe.json ]] || { echo 'missing pod-probe.json' >&2; exit 1; }
for i in $(seq 1 "${1:-40}"); do
  r=$(bash v2.sh POST /pods "$(cat pod-probe.json)")
  id=$(printf '%s' "$r" | python3 -c 'import json,sys;print(json.load(sys.stdin).get("id",""))' 2>/dev/null)
  if [[ -n $id ]]; then echo "POD $id"; exit 0; fi
  echo "try $i: $(printf '%s' "$r" | head -c 110)"
  sleep 30
done
echo 'no capacity after retries' >&2; exit 1
