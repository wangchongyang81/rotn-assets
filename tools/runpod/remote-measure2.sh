#!/usr/bin/env bash
set -uo pipefail
cd /workspace/comfy/output
ls -l anchor-t_00001_.png anchor-p2_00001_.png skel-p2_00001_.png
python - <<'PY'
from PIL import Image
for n in ('anchor-t_00001_.png','anchor-p2_00001_.png'):
    im=Image.open(n).convert('L'); W,Hh=im.size; px=im.load()
    rows=[]
    for y in range(Hh):
        xs=[x for x in range(0,W,2) if px[x,y]<245]
        rows.append((min(xs),max(xs)) if xs else None)
    ys=[i for i,r in enumerate(rows) if r]
    if not ys: print(n,'empty'); continue
    top,bot=ys[0],ys[-1]; h=max(bot-top,1)
    print(n,'h',h,'top',top,'bot',bot)
    for f in (0.18,0.28,0.5,0.75,0.95):
        r=rows[int(top+h*f)]
        print('  f%.2f'%f,(r[1]-r[0]) if r else None)
PY
