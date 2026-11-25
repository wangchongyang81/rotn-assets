#!/usr/bin/env bash
set -uo pipefail
J=/workspace/judge
F=0
step(){ echo "=== $1"; shift; "$@"; c=$?; echo "rc=$c $1"; [ "$c" = 0 ] || F=$((F+1)); }
step boot bash /workspace/remote-boot.sh
step setup bash "$J/setup-judge.sh"
step smoke python3 "$J/vision-smoke.py"
step discrim python3 "$J/judge-discrim.py"
echo "=== summary fails=$F"
[ "$F" = 0 ] && echo PASS_ALL || echo FAIL_SOME
exit "$F"
