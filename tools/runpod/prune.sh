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
python - "$R" "$DRY" <<'PYX'
import subprocess,sys
from huggingface_hub import HfApi
R=sys.argv[1]; dry=sys.argv[2]=='1'; KEEP={'.gitattributes','README.md'}
loc={f.removeprefix('art/') for f in subprocess.run(['git','ls-files'],capture_output=True,text=True).stdout.split()}
api=HfApi(); rem=set(api.list_repo_files(R,repo_type='model'))
stripped={f.removeprefix('art/') for f in rem}
ex=sorted(f for f in rem if f not in KEEP and f.removeprefix('art/') not in loc)
miss=sorted(loc-stripped-KEEP); print('extra',len(ex),'missing',len(miss))
for f in ex[:10]: print('  ',f)
open('/tmp/hfdel.txt','w').write('\n'.join(ex)+'\n' if ex else '')
if dry or not ex: print('hf', 'dry' if dry else 'none'); raise SystemExit
api.delete_files(R,ex,repo_type='model',commit_message='prune orphans'); print('hf deleted',len(ex))
PYX
