#!/usr/bin/env bash
set -uo pipefail
cd "$(dirname "$0")/../.."
DRY=${DRY:-1}; T=../rotn-src/docs/continuity
python - "$DRY" "$T/STATE.md" "$T/WORKPLAN.md" <<'PY'
import sys,pathlib
dry=sys.argv[1]=='1'; s=pathlib.Path(sys.argv[2]); w=pathlib.Path(sys.argv[3])
blk=pathlib.Path('docs/continuity/state-venice.md').read_text().rstrip().splitlines()
L=s.read_text().splitlines()
i=L.index('## venice — prose, content, direction')
j=next(k for k in range(i+1,len(L)) if L[k].startswith('## '))
new=L[:i+1]+blk+['']+L[j:]
wl=w.read_text().splitlines()
a=next(k for k,x in enumerate(wl) if x.startswith('## P5'))
b=next(k for k in range(a+1,len(wl)) if wl[k].startswith('## '))
sub=iter(pathlib.Path('docs/continuity/workplan-venice.md').read_text().splitlines()); n=0
for k in range(a,b):
    if '[venice]' in wl[k]:
        try: wl[k]=next(sub); n+=1
        except StopIteration: break
print('state',len(L),'->',len(new),'| workplan replaced',n)
if dry: print('DRY, nothing written'); sys.exit(0)
s.write_text('\n'.join(new)+'\n'); w.write_text('\n'.join(wl)+'\n'); print('written')
PY
