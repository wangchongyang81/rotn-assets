#!/usr/bin/env bash
set -uo pipefail
cd "$(dirname "$0")/../.."
DRY=${DRY:-1}; DAYS=${DAYS:-7}; H=${1:-}; P=${2:-}; R=wangchongyang81/rotn-pilot
S="-i $HOME/.ssh/id_ed25519 -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=ERROR -o ConnectTimeout=20"
echo "== container DRY=$DRY"
[ -n "$H" ] && ssh $S -p "$P" root@"$H" 'ls -d /tmp/anc /workspace/*.out /workspace/*.sh 2>/dev/null | wc -l' || echo "skipped no host"
echo "== volume"
if [ -n "$H" ]; then
  ssh $S -p "$P" root@"$H" "find /workspace/comfy/output -name '*.png' -mtime +$DAYS" > /tmp/cand.txt 2>/dev/null
  python - <<'PY'
import json
ids=set()
for l in open('art/labels/attempts.jsonl'):
    try: ids.add(json.loads(l)['id'])
    except Exception: pass
out=[]; keep=0
for f in open('/tmp/cand.txt'):
    f=f.strip()
    if not f: continue
    if f.split('/')[-1].split('_')[0] in ids: keep+=1
    else: out.append(f)
open('/tmp/del.txt','w').write('\n'.join(out)+'\n' if out else '')
print('candidates',keep+len(out),'referenced',keep,'orphans',len(out))
PY
  head -5 /tmp/del.txt
  if [ "$DRY" != 1 ]; then while read -r f; do [ -n "$f" ] && ssh $S -p "$P" root@"$H" "rm -f '$f'"; done < /tmp/del.txt; fi
else echo "skipped no host"; fi
echo "== hf"
python - "$R" <<'PY'
import subprocess,sys
from huggingface_hub import HfApi
loc=set(subprocess.run(['git','ls-files'],capture_output=True,text=True).stdout.split())
ex=sorted(set(HfApi().list_repo_files(sys.argv[1],repo_type='model'))-loc)
print('extra',len(ex)); [print('  ',f) for f in ex[:10]]
open('/tmp/hfdel.txt','w').write('\n'.join(ex))
PY
if [ "$DRY" != 1 ] && [ -s /tmp/hfdel.txt ]; then while read -r f; do hf repo-files delete "$R" "$f" --repo-type model -y >/dev/null 2>&1; done < /tmp/hfdel.txt; fi
