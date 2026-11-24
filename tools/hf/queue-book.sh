#!/usr/bin/env bash
set -uo pipefail
IMG=runpod/pytorch:1.0.3-cu1281-torch291-ubuntu2404
GPU="NVIDIA A100-SXM4-80GB"
TOK=$(cat ~/.cache/huggingface/token 2>/dev/null || true)
OUT=tools/hf/booked.txt; : > "$OUT"
END=$((SECONDS+600))
idof() { runpodctl pod list 2>/dev/null | python3 -c "import json,sys
for p in json.load(sys.stdin):
  if p.get('name')=='$1': print(p['id'])" 2>/dev/null | head -1; }
try() {
  local n=$1; shift
  local r id
  r=$(runpodctl pod create --name "$n" --image "$IMG" --gpu-id "$GPU" --gpu-count 1 \
      --cloud-type SECURE --data-center-ids EU-RO-1 --container-disk-in-gb 40 \
      --env "{\"HF_TOKEN\":\"$TOK\"}" "$@" 2>&1)
  id=$(printf '%s' "$r" | python3 -c "import json,sys;print(json.load(sys.stdin).get('id',''))" 2>/dev/null)
  [ -n "$id" ] && { printf '%s %s\n' "$n" "$id" | tee -a "$OUT"; return 0; }
  printf '%s %s miss: %s\n' "$(date +%T)" "$n" \
    "$(printf '%s' "$r" | sed -n 's/.*"error":"$$[^"]*$$".*/\1/p' | cut -c1-50)"
  return 1
}
adopt() { local i; i=$(idof "$1"); [ -n "$i" ] && { printf '%s %s adopted\n' "$1" "$i" | tee -a "$OUT"; return 0; }; return 1; }
R=0; J=0
adopt rotn-render && R=1
adopt rotn-judge && J=1
while [ "$SECONDS" -lt "$END" ]; do
  [ "$R" -eq 0 ] && { try rotn-render --network-volume-id 39dhm3ia6u --ports '8188/http,22/tcp' && R=1; }
  [ "$J" -eq 0 ] && { try rotn-judge --volume-in-gb 60 --ports '8001/http,22/tcp' && J=1; }
  [ "$R" -eq 1 ] && [ "$J" -eq 1 ] && break
  sleep $((7 + RANDOM % 9))
done
echo "render=$R judge=$J"; cat "$OUT"
