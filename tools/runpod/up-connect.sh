#!/usr/bin/env bash
set -uo pipefail
cd "$(dirname "$0")"
for i in $(seq 1 30); do
  r=$(bash v2.sh POST /pods "$(cat pod-probe.json)")
  id=$(printf '%s' "$r" | python3 -c 'import json,sys;print(json.load(sys.stdin).get("id",""))' 2>/dev/null)
  [[ -n $id ]] && { echo "POD $id"; break; }
  echo "try $i: $(printf '%s' "$r" | head -c 90)"; sleep 20
done
[[ -n ${id:-} ]] || { echo 'no capacity' >&2; exit 1; }
echo "$id" > /tmp/pod.id
for i in $(seq 1 40); do
  bash v2.sh GET "/pods/$id" > /tmp/pod.json
  read -r ip pt < <(python3 -c 'import json;p=json.load(open("/tmp/pod.json"));e=[x for x in (p.get("runtime") or {}).get("ports",[]) if x.get("private")==22];print((e[0]["ip"],e[0]["public"]) if e else ("",""))')
  [[ -n ${ip:-} ]] && { echo "SSH $ip $pt"; exit 0; }
  sleep 10
done
echo 'no ssh mapping' >&2; exit 1
