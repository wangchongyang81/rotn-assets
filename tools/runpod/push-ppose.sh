#!/usr/bin/env bash
set -euo pipefail
# usage: push-ppose.sh <host> <port> <env>...
H=${1:?host}; P=${2:?port}; shift 2
K=${KEY:-$HOME/.ssh/id_ed25519}
S="-i $K -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"
D=/workspace/comfy/input; T=/tmp/pp
mkdir -p "$T"
ssh $S -p "$P" root@"$H" "mkdir -p $D"
for p in "$@"; do
  F=art/prompts/wild/noobai/brown-on/$p.txt
  [ -s "$F" ] || { echo "NOPROMPT $p"; exit 1; }
  sed -n 's/^P: //p' "$F" > "$T/prompt-$p.txt"
  sed -n 's/^N: //p' "$F" > "$T/neg-$p.txt"
  sha256sum "$F" | cut -d' ' -f1 > "$T/sha-$p.txt"
  scp $S -P "$P" "$T/prompt-$p.txt" "$T/neg-$p.txt" "$T/sha-$p.txt" root@"$H":"$D"/
  echo "ok $p"
done
echo "pushed $#"
