#!/usr/bin/env bash
set -uo pipefail
cd /workspace/comfy/output
python - <<'PY'
from PIL import Image
n='anchor-tz_00001_.png'
im=Image.open(n).convert('RGB'); W,Hh=im.size; px=im.load()
print('corners',px[0,0],px[W-1,0],px[0,Hh-1],px[W-1,Hh-1])
bg=px[0,0]
def d(p): return sum(abs(a-b) for a,b in zip(p,bg))
rows=[]
for y in range(Hh):
    xs=[x for x in range(0,W,2) if d(px[x,y])>24]
    rows.append((min(xs),max(xs)) if xs else None)
ys=[i for i,r in enumerate(rows) if r]
print('rows',len(ys))
if not ys: raise SystemExit
top,bot=ys[0],ys[-1]; h=max(bot-top,1)
print(n,'h',h,'top',top,'bot',bot,'gap_below',Hh-bot)
for f in (0.12,0.18,0.28,0.5,0.75,0.95):
    r=rows[int(top+h*f)]
    print('  f%.2f'%f,(r[1]-r[0]) if r else None)
PY
