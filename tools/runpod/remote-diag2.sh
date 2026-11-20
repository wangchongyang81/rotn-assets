#!/usr/bin/env bash
set -uo pipefail
echo "=== out"; cat /workspace/tz5.out
echo "=== queue"; curl -s http://127.0.0.1:8188/queue | head -c 400; echo
echo "=== log"; tail -20 /workspace/comfy/comfy.log
echo "=== files"; ls -lt /workspace/comfy/output | head -5
