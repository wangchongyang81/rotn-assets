#!/usr/bin/env bash
set -uo pipefail
S=${1:?script}; cd "$(dirname "$0")"
c=$(curl -s -o /dev/null -w '%{http_code}' http://127.0.0.1:8188/ || true)
[ "$c" = 200 ] || { echo "NOCORE $c"; exit 1; }
bash "remote-$S.sh"; rc=$?
[ "$rc" = 0 ] || { echo "RUNFAIL $rc $S"; exit 1; }
f=$(ls -t /workspace/comfy/output/anchor-*_00001_.png 2>/dev/null | head -1)
[ -n "$f" ] || { echo NOOUT; exit 1; }
echo "out $(basename "$f")"
python tools/score.py "$f"
if python tools/runpod/gate.py "$f"; then echo "R1 PASS $S"; else echo "R1 FAIL $S"; exit 1; fi
