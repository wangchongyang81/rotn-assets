#!/usr/bin/env bash
set -uo pipefail
cd "$(dirname "$0")"
API=https://api.runpod.io/v2
k=$(awk -F"'" '/^apikey *=/{if ($2!="") v=$2} END{print v}' "$HOME/.runpod/config.toml")
[[ -z $k ]] && { echo 'no runpod key' >&2; exit 1; }
get(){ curl -sS -m 40 -H "Authorization: Bearer $k" "$API$1"; }
[[ -n $(git -C ../.. status --porcelain) ]] && { echo 'tree dirty: commit first' >&2; exit 1; }
id=${1:-}
if [[ -z $id && -f /tmp/pod.env ]]; then id=$(awk 'NR==1{print $1}' /tmp/pod.env); fi
if [[ -z $id ]]; then
  id=$(get /pods | python -c "import json,sys;P=json.load(sys.stdin);P=P if isinstance(P,list) else P['pods'];print(next((x['id'] for x in P if x['name'].startswith('rotn') and x['desiredStatus']=='RUNNING'),''))" 2>/dev/null)
fi
if [[ -z $id ]]; then echo 'already down, no pod id'; exit 0; fi
echo "delete $id"
bash v2.sh DELETE "/pods/$id" | head -c 160; echo
for i in $(seq 1 30); do
  s=$(get "/pods/$id" | python -c "import json,sys;print(json.load(sys.stdin).get('desiredStatus',''))" 2>/dev/null)
  echo "$(date +%T) i=$i status=${s:-gone}"
  if [[ -z $s || $s == EXITED || $s == TERMINATED ]]; then break; fi
  sleep 6
done
left=$(get /pods | python -c "import json,sys;P=json.load(sys.stdin);P=P if isinstance(P,list) else P['pods'];print(sum(x['desiredStatus']=='RUNNING' for x in P))" 2>/dev/null)
echo "running_left=${left:-?}"
[[ ${left:-1} -eq 0 ]] && { echo 'PODS DOWN'; exit 0; }
echo 'PODS STILL RUNNING' >&2; exit 1
