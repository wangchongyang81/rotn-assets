#!/usr/bin/env bash
set -euo pipefail
H=${1:?host}; P=${2:?port}; shift 2
S="-i $HOME/.ssh/id_ed25519 -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=ERROR"
D=/workspace/comfy/input; T=$(mktemp -d)
trap 'rm -rf "$T"' EXIT
for p in "$@"; do
  F=art/prompts/anchors/$p.txt
  awk '/^positive:/{f=1;next}/^negative:/{f=0;next}f' "$F" > "$T/prompt-$p.txt"
  awk '/^negative:/{f=1;next}f' "$F" > "$T/neg-$p.txt"
  wc -c "$T/prompt-$p.txt" "$T/neg-$p.txt"
  scp -q $S -P "$P" "$T/prompt-$p.txt" "$T/neg-$p.txt" root@"$H":"$D"/
done
ssh $S -p "$P" root@"$H" "ls -l $D/prompt-*.txt $D/neg-*.txt | tail -4"
