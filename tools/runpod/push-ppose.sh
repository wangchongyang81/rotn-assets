#!/usr/bin/env bash
set -euo pipefail
# usage: push-ppose.sh <host> <port> <pose>...
H=${1:?host}; P=${2:?port}; shift 2
K=${KEY:-$HOME/.ssh/id_ed25519}
S="-i $K -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"
D=/workspace/comfy/input; T=/tmp/pp
skel(){ case $1 in tpose) echo skel-tpose.png;; *) echo skel-ppose-$1.png;; esac; }
mkdir -p "$T"
ssh $S -p "$P" root@"$H" "mkdir -p $D"
for p in "$@"; do
  F=art/prompts/wild/noobai/brown-on/$p.txt
  [ -s "$F" ] || { echo "NOPROMPT $p"; exit 1; }
  S1=$(skel "$p")
  [ -s "art/skeletons/$S1" ] || { echo "NOSKEL $p $S1"; exit 1; }
  sed -n 's/^P: //p' "$F" > "$T/prompt-$p.txt"
  sed -n 's/^N: //p' "$F" > "$T/neg-$p.txt"
  L=$(sha256sum "art/skeletons/$S1" | cut -d' ' -f1)
  R=$(ssh $S -p "$P" root@"$H" "sha256sum $D/$S1 2>/dev/null | cut -d' ' -f1" || true)
  if [ "$L" = "$R" ]; then st=same; else
    st=$([ -n "$R" ] && echo upd || echo new)
    scp $S -P "$P" "art/skeletons/$S1" root@"$H":"$D"/
  fi
  scp $S -P "$P" "$T/prompt-$p.txt" "$T/neg-$p.txt" root@"$H":"$D"/
  echo "ok $p skel=$st"
done
echo "pushed $#"
