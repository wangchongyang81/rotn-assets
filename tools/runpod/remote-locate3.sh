#!/usr/bin/env bash
set -uo pipefail
cd /workspace/comfy/output
ls -l anchor-pz_00001_.png
python - <<'PY'
from PIL import Image
for n in ('anchor-pz_00001_.png','anchor-tv2_00001_.png'):
    im=Image.open(n).convert('RGB'); W,Hh=im.size; px=im.load()
    pts=[(4,4),(W-5,4),(4,Hh-5),(W-5,Hh-5)]
    print(n,'corners',[px[x,y] for x,y in pts])
    bg=px[4,4]
    def d(p): return sum(abs(a-b) for a,b in zip(p,bg))
    rows=[]
    for y in range(Hh):
        xs=[x for x in range(0,W,2) if d(px[x,y])>24]
        rows.append((min(xs),max(xs)) if xs else None)
    ys=[i for i,r in enumerate(rows) if r]
    if not ys: print(' empty'); continue
    top,bot=ys[0],ys[-1]; h=max(bot-top,1)
    print(' h',h,'top',top,'bot',bot,'gap_below',Hh-bot)
    for f in range(0,43,3):
        y=int(top+h*f/100); r=rows[y]
        print('  %d%%'%f,r,'w',(r[1]-r[0]) if r else None)
    y=int(top+h*0.62); print('  legpix',[px[x,y] for x in (350,380,450,480)])
PY
