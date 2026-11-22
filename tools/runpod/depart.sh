#!/usr/bin/env bash
set -uo pipefail
cd "$(dirname "$0")"
API=https://api.runpod.io/v2
k=$(awk -F"'" '/^apikey *=/{if ($2!="") v=$2} END{print v}' "$HOME/.runpod/config.toml")
[[ -z $k ]] && { echo 'no runpod key' >&2; exit 1; }
get(){ curl -sS -m 40 -H "Authorization: Bearer $k" "$API$1"; }
running(){ get /pods | python -c "import json,sys;P=json.load(sys.stdin);P=P if isinstance(P,list) else P['pods'];print(' '.join(x['id'] for x in P if x['name'].startswith('rotn') and x['desiredStatus']=='RUNNING'))" 2>/dev/null; }
[[ -n $(git -C ../.. status --porcelain) ]] && { echo 'tree dirty: commit first' >&2; exit 1; }
ids=${1:-}
[[ -z $ids && -f /tmp/pod.env ]] && ids=$(awk 'NR==1{print $1}' /tmp/pod.env)
[[ -z $ids ]] && ids=$(running)
[[ -z $ids ]] && { echo 'already down, no pod id'; exit 0; }
for id in $ids; do
  echo "delete $id"
  r=$(bash v2.sh DELETE "/pods/$id")
  echo "$r" | head -c 140; echo
  if grep -q 'not found' <<<"$r"; then
    alt=$(running)
    if [[ -n $alt && $alt != "$ids" ]]; then
      echo "retry via api: $alt"
      for a in $alt; do bash v2.sh DELETE "/pods/$a" | head -c 120; echo; done
    fi
  fi
done
for i in $(seq 1 30); do
  s=$(running)
  echo "$(date +%T) i=$i running=${s:-none}"
  [[ -z $s ]] && break; sleep 6
done
if [[ -z ${s:-} ]]; then : > /tmp/pod.env; echo 'PODS DOWN'; exit 0; fi
echo 'PODS STILL RUNNING' >&2; exit 1
