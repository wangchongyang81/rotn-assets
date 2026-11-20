#!/usr/bin/env bash
set -uo pipefail
c=$HOME/.runpod/config.toml
k=${1:-}
if [[ -z $k ]]; then read -r k < /dev/tty || true; fi
if [[ -z $k && -t 0 ]]; then read -r k || true; fi
k=${k//[$'\r\n\t ']/}
[[ -z $k ]] && { echo 'empty, nothing written' >&2; exit 1; }
python3 - "$c" "$k" <<'PY' || exit 1
import re,sys
p,k=sys.argv[1],sys.argv[2]
s=open(p).read()
s2=re.sub(r"^apikey *= *'.*'$", "apikey = '%s'" % k, s, count=1, flags=re.M)
if s2==s: s2=s.rstrip("\n")+"\napikey = '%s'\n" % k
open(p,'w').write(s2)
print('written')
PY
chmod 600 "$c"
echo "stored, length ${#k}"
