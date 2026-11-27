#!/usr/bin/env bash
set -euo pipefail
# usage: push-ppose.sh <host> <port> <pose>...
# prompts keep the old noobai dir name; the checkpoint is photoreal
H=${1:?host}; P=${2:?port}; shift 2
K=${KEY:-$HOME/.ssh/id_ed25519}
R=$(cd "$(dirname "$0")/../.." && pwd)
SRC=$R/art/prompts/wild/noobai/brown-on
S="-i $K -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=ERROR"
D=/workspace/comfy/input; T=$(mktemp -d)
trap 'rm -rf "$T"' EXIT
ssh $S -p "$P" root@"$H" "mkdir -p $D"
for p in "$@"; do
  F=$SRC/$p.txt
  [ -s "$F" ] || { echo "NOPROMPT $p"; exit 1; }
  sed -n 's/^P: //p' "$F" > "$T/prompt-$p.txt"
  sed -n 's/^N: //p' "$F" > "$T/neg-$p.txt"
  [ -s "$T/prompt-$p.txt" ] || { echo "EMPTY $p"; exit 1; }
  sha256sum "$F" | cut -d' ' -f1 > "$T/sha-$p.txt"
  scp -q $S -P "$P" "$T/prompt-$p.txt" "$T/neg-$p.txt" "$T/sha-$p.txt" root@"$H":"$D"/
  echo "ok $p"
done
echo "pushed $#"
