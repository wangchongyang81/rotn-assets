#!/usr/bin/env bash
set -uo pipefail
cd "$(dirname "$0")/../.."
DRY=${DRY:-1}; DAYS=${DAYS:-7}; H=${1:-}; P=${2:-}; R=wangchongyang81/rotn-pilot
S="-i $HOME/.ssh/id_ed25519 -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=ERROR -o ConnectTimeout=20"
echo "== container DRY=$DRY"
if [ -n "$H" ]; then
  C=$(ssh -n $S -p "$P" root@"$H" "find /workspace -maxdepth 1 -name '*.out' -mtime +$DAYS | wc -l")
  echo "out_files $C"
  [ "$DRY" != 1 ] && [ "$C" -gt 0 ] && ssh -n $S -p "$P" root@"$H" "find /workspace -maxdepth 1 -name '*.out' -mtime +$DAYS -delete"
else echo "skipped no host"; fi
echo "== volume"
if [ -n "$H" ]; then
  ssh $S -p "$P" root@"$H" "find /workspace/comfy/output -name '*.png' -mtime +$DAYS" > /tmp/cand.txt 2>/dev/null
  python - <<'PY'
import json
keys=set()
for l in open('art/labels/attempts.jsonl'):
    try:
        d=json.loads(l); keys.add(d['tag']); keys.add(d['id'])
    except Exception: pass
out=[]; keep=0
for f in open('/tmp/cand.txt'):
    f=f.strip()
    if not f: continue
    if f.split('/')[-1].split('_')[0] in keys: keep+=1
    else: out.append(f)
abort=bool(keep+len(out)) and not keep and __import__('os').environ.get('FORCE')!='1'
if abort: out=[]; print('ZERO MATCH - keep all')
open('/tmp/del.txt','w').write('\n'.join(out)+'\n' if out else '')
print('candidates',keep+len(out),'referenced',keep,'orphans',len(out),'ABORTED' if abort else '')
PY
  head -5 /tmp/del.txt
  if [ "$DRY" != 1 ]; then while read -r f; do [ -n "$f" ] && ssh -n $S -p "$P" root@"$H" "rm -f '$f'"; done < /tmp/del.txt; fi
else echo "skipped no host"; fi
echo "== hf"
python - "$R" "$DRY" <<'PYX'
import os,subprocess,sys
from huggingface_hub import HfApi
R=sys.argv[1]; dry=sys.argv[2]=='1'; KEEP={'.gitattributes','README.md'}
loc=set(subprocess.run(['git','ls-files'],capture_output=True,text=True).stdout.split())
stripped={f.removeprefix('art/') for f in loc}
api=HfApi(); rem=set(api.list_repo_files(R,repo_type='model'))
def orphan(f):
    if f in KEEP: return False
    if f.startswith('art/'): return f.removeprefix('art/') in rem
    return f not in stripped and not os.path.exists(f) and not os.path.exists('art/'+f)
ex=sorted(f for f in rem if orphan(f))
miss=sorted(f for f in stripped if f not in rem)
print('extra',len(ex),'missing',len(miss))
for f in ex[:8]: print('  ',f)
open('/tmp/hfdel.txt','w').write('\n'.join(ex)+'\n' if ex else '')
if dry or not ex: print('hf','dry' if dry else 'none'); raise SystemExit
api.delete_files(R,ex,repo_type='model',commit_message='prune orphan duplicates'); print('hf deleted',len(ex))
PYX