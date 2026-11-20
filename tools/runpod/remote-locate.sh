#!/usr/bin/env bash
set -uo pipefail
cd /workspace/comfy/output
python - <<'PY'
from PIL import Image
for n in ('anchor-px_00001_.png','anchor-pv_00001_.png','anchor-tv2_00001_.png'):
    im=Image.open(n).convert('RGB'); W,Hh=im.size; px=im.load()
    bg=px[4,4]
    def d(p): return sum(abs(a-b) for a,b in zip(p,bg))
    rows=[]
    for y in range(Hh):
        xs=[x for x in range(0,W,2) if d(px[x,y])>24]
        rows.append((min(xs),max(xs)) if xs else None)
    ys=[i for i,r in enumerate(rows) if r]
    if not ys: print(n,'empty'); continue
    top,bot=ys[0],ys[-1]; h=max(bot-top,1)
    print(n,'h',h,'top',top)
    for f in range(0,43,3):
        y=int(top+h*f/100); r=rows[y]
        print('  %d%%'%f,r,'w',(r[1]-r[0]) if r else None)
    y=int(top+h*0.62)
    print('  legpix',[px[x,y] for x in (350,380,450,480)])
PY
