#!/usr/bin/env bash
set -uo pipefail
# Book A100 SXM at EU-RO-1, both roles, 10 min. 4090 is ABSENT at EU-RO-1.
IMG=runpod/pytorch:1.0.3-cu1281-torch291-ubuntu2404
GPU="NVIDIA A100-SXM4-80GB"
TOK=$(cat ~/.cache/huggingface/token 2>/dev/null || true)
OUT=tools/hf/booked.txt; : > "$OUT"
END=$((SECONDS+600))
try() {
  local n=$1; shift
  local r id
  r=$(runpodctl pod create --name "$n" --image "$IMG" --gpu-id "$GPU" --gpu-count 1 \
      --cloud-type SECURE --data-center-ids EU-RO-1 --container-disk-in-gb 40 \
      --env "{\"HF_TOKEN\":\"$TOK\"}" "$@" 2>&1)
  id=$(printf '%s' "$r" | sed -n 's/.*"id": *"$$[a-z0-9]*$$".*/\1/p' | head -1)
  if [ -n "$id" ]; then printf '%s %s\n' "$n" "$id" | tee -a "$OUT"; return 0; fi
  printf '%s %s miss: %s\n' "$(date +%T)" "$n" \
    "$(printf '%s' "$r" | sed -n 's/.*"error":"$$[^"]*$$".*/\1/p' | cut -c1-50)"
  return 1
}
R=0; J=0
while [ "$SECONDS" -lt "$END" ]; do
  [ "$R" -eq 0 ] && { try rotn-render --network-volume-id 39dhm3ia6u --ports '8188/http,22/tcp' && R=1; }
  [ "$J" -eq 0 ] && { try rotn-judge --volume-in-gb 60 --ports '8001/http,22/tcp' && J=1; }
  [ "$R" -eq 1 ] && [ "$J" -eq 1 ] && break
  sleep $((7 + RANDOM % 9))
done
echo "render=$R judge=$J"; cat "$OUT"
