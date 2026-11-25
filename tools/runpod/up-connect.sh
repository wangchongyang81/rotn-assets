#!/usr/bin/env bash
set -uo pipefail
cd "$(dirname "$0")"
mapfile -t C < <(python3 probe2cli.py)
[[ ${#C[@]} -gt 8 ]] || { echo NOFLAGS >&2; exit 1; }
if [[ ${DRY:-0} == 1 ]]; then printf '%q ' runpodctl pod create "${C[@]}"; echo; exit 0; fi
r=$(runpodctl pod create "${C[@]}" -o json 2>&1)
id=$(printf '%s' "$r" | python3 -c 'import json,sys
try: print(json.load(sys.stdin).get("id",""))
except Exception: pass' 2>/dev/null)
[[ -n $id ]] || { echo "create failed: $(printf '%s' "$r" | head -c 220)" >&2; exit 1; }
echo "POD $id"; echo "$id" > /tmp/pod.id
for i in $(seq 1 40); do
  bash v2.sh GET "/pods/$id" > /tmp/pod.json
  m=$(python3 - <<'PY'
import json
p=json.load(open("/tmp/pod.json"))
e=[x for x in (p.get("runtime") or {}).get("ports",[]) if x.get("private")==22]
if e: print(e[0]["ip"], e[0]["public"])
PY
  )
  [[ -n $m ]] && { echo "$id $m" > /tmp/pod.env; echo "SSH $m"; nohup bash prune-weekly.sh > /tmp/prune.log 2>&1 & echo "prune bg"; exit 0; }
  sleep 10
done
echo 'no ssh mapping' >&2; exit 1
