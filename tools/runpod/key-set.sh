#!/usr/bin/env bash
set -euo pipefail
c=$HOME/.runpod/config.toml
read -r -s -p 'RunPod API key: ' k; echo
[[ -z $k ]] && { echo 'empty, nothing written' >&2; exit 1; }
python3 - "$c" "$k" <<'PY'
import re,sys
p,k=sys.argv[1],sys.argv[2]
s=open(p).read()
s2=re.sub(r"^apikey *= *'.*'$", "apikey = '%s'" % k, s, count=1, flags=re.M)
assert s2!=s, 'no apikey line'
open(p,'w').write(s2)
PY
chmod 600 "$c"; echo "stored, length ${#k}"
