#!/usr/bin/env bash
set -euo pipefail
id=${1:?pod id}
d=$(dirname "$0")
b64=$(base64 -w0 "$d/remote-boot.sh")
python3 -c 'import json,sys;c="echo "+sys.argv[1]+" | base64 -d > /workspace/boot.sh && setsid bash /workspace/boot.sh > /workspace/boot.log 2>&1 < /dev/null & echo kicked";print(json.dumps({"command":[c],"timeoutSeconds":25}))' "$b64" > /tmp/exec.json
bash "$d/v2.sh" POST "/pods/$id/exec" "$(cat /tmp/exec.json)"
