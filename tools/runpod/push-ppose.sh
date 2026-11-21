#!/usr/bin/env bash
set -euo pipefail
# usage: push-ppose.sh <host> <port> <pose>...
H=${1:?host}; P=${2:?port}; shift 2
K=${KEY:-$HOME/.ssh/id_ed25519}
S="-i $K -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"
D=/workspace/comfy/input; T=/tmp/pp
mkdir -p "$T"
ssh $S -p "$P" root@"$H" "mkdir -p $D"
for p in "$@"; do
  F=art/prompts/wild/illus/brown-on/$p.txt
  [ -s "$F" ] || { echo "NOPROMPT $p"; exit 1; }
  sed -n 's/^P: //p' "$F" > "$T/prompt-$p.txt"
  sed -n 's/^N: //p' "$F" > "$T/neg-$p.txt"
  scp $S -P "$P" art/skeletons/skel-ppose-$p.png "$T/prompt-$p.txt" "$T/neg-$p.txt" root@"$H":"$D"/
  echo "ok $p"
done
echo "pushed $#"
