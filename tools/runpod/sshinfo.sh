#!/usr/bin/env bash
set -uo pipefail
cd "$(dirname "$0")"
id=${1:?pod id}
for i in $(seq 1 40); do
  bash v2.sh GET "/pods/$id" > /tmp/pod.json
  out=$(python3 -c 'import json;p=json.load(open("/tmp/pod.json"));e=[x for x in (p.get("runtime") or {}).get("ports",[]) if x.get("private")==22];print(e[0]["ip"]+" "+str(e[0]["public"]) if e else "")')
  if [[ -n $out ]]; then echo "$out"; exit 0; fi
  echo "wait $i" >&2; sleep 10
done
exit 1
