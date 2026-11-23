#!/usr/bin/env bash
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"
POD=${1:?usage: depart.sh <pod-id> [note]}
NOTE=${2:-}
[ -z "$(git status -s)" ] || { echo "DIRTY - commit first"; git status -s; exit 1; }
if [ -n "$NOTE" ]; then
  printf '\n## Departure state\n%s\n' "$NOTE" >> master/anchors/workflow/README.md
  git add -A; git commit -q -m "depart: $NOTE"
fi
bash tools/close_session.sh "$POD" > /tmp/close.log 2>&1 || { echo "CLOSE FAILED"; tail -20 /tmp/close.log; exit 1; }
grep -q 'MIRROR VERIFIED' /tmp/close.log || { echo "NO VERIFY LINE"; tail -20 /tmp/close.log; exit 1; }
git push -q origin main && echo pushed
runpodctl pod stop "$POD" >/tmp/stop.log 2>&1 || grep -q 'not valid for status' /tmp/stop.log || { cat /tmp/stop.log; exit 1; }
for i in 1 2 3 4 5 6; do
  s=$(runpodctl pod get "$POD" 2>&1 | grep -o '"runtimeStatus": "[a-z_]*"' || true)
  echo "t$i $s"
  case "$s" in *running*|*initializing*) sleep 12;; *) break;; esac
done
echo "pods=$(runpodctl pod list 2>&1 | grep -cE '"id"' || true)"
