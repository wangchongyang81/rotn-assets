#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
DEST=${DEST:-}
if [[ -z $DEST ]]; then
  H=${1:?host}; P=${2:?port}; K=${KEY:-$HOME/.ssh/id_ed25519}
  S="-i $K -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"
  D=/workspace/judge
else
  D=$DEST
fi
[ -s judge-manifest.json ] || { echo NOMANIFEST >&2; exit 1; }
R=$(git rev-parse --show-toplevel)
L=$(git -C "$R" ls-files 'art/realms/01/anchor-t/*.png' | grep -vE '/(candidates|legacy)/|/sheet\.png$' | head -6 | sed "s|^|$R/|")
[ -n "$L" ] || { echo NOIMAGES >&2; exit 1; }
mkdir -p "$D/in"
[[ -n $DEST ]] || ssh $S -p "$P" root@"$H" "mkdir -p $D/in"
put(){ [[ -n $DEST ]] && cp "$1" "$2" || scp $S -P "$P" "$1" root@"$H":"$2"; }
put judge-manifest.json "$D/manifest.json"
for f in $L; do put "$f" "$D/in/"; done
echo "pushed $(printf '%s\n' "$L" | wc -l)"
