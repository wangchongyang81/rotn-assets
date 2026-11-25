#!/usr/bin/env bash
set -euo pipefail
H=${1:?host}; P=${2:?port}; K=${KEY:-$HOME/.ssh/id_ed25519}
S="-i $K -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"
D=/workspace/judge
[ -s tools/runpod/judge-manifest.json ] || { echo NOMANIFEST >&2; exit 1; }
L=$(git ls-files 'art/realms/01/anchor-t/*.png' | grep -vE '/(candidates|legacy)/' | head -6)
[ -n "$L" ] || { echo NOIMAGES >&2; exit 1; }
ssh $S -p "$P" root@"$H" "mkdir -p $D/in"
scp $S -P "$P" tools/runpod/judge-manifest.json root@"$H":"$D"/manifest.json
for f in $L; do scp $S -P "$P" "$f" root@"$H":"$D"/in/; done
echo "pushed $(printf '%s\n' "$L" | wc -l)"
