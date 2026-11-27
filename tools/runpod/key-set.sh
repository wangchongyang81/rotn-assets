#!/usr/bin/env bash
set -uo pipefail
c=$HOME/.runpod/config.toml
mkdir -p "$HOME/.runpod"; chmod 700 "$HOME/.runpod"
[ -f "$c" ] || : > "$c"
k=${1:-}
if [[ -z $k ]]; then read -rsp 'apikey: ' k < /dev/tty || true; echo; fi
k=${k//[$'\r\n\t ']/}
[[ -z $k ]] && { echo 'empty, nothing written' >&2; exit 1; }
python3 - "$c" "$k" <<'PY' || exit 1
import re,sys
p,k=sys.argv[1],sys.argv[2]
L=open(p).read().splitlines()
L=[l for l in L if not re.match(r"\s*apikey\s*=",l)]
open(p,'w').write("\n".join(["apikey = '%s'" % k]+L)+"\n")
print('written, deduped')
PY
chmod 600 "$c"; echo "stored, length ${#k}"
