#!/usr/bin/env bash
set -uo pipefail
cd /workspace/comfy/output
ls -l skel-tz_00001_.png
python - <<'PY'
from PIL import Image
im=Image.open('skel-tz_00001_.png').convert('RGB'); W,Hh=im.size; px=im.load()
print('skel size',im.size,'corners',px[0,0],px[W-1,Hh-1])
bg=px[0,0]
def d(p): return sum(abs(a-b) for a,b in zip(p,bg))
rows=[]
for y in range(Hh):
    xs=[x for x in range(0,W,2) if d(px[x,y])>40]
    rows.append((min(xs),max(xs)) if xs else None)
ys=[i for i,r in enumerate(rows) if r]
print('skel rows',len(ys))
if ys:
    top,bot=ys[0],ys[-1]; h=max(bot-top,1)
    print('skel h',h,'top',top,'bot',bot)
    for f in (0.12,0.18,0.28,0.5,0.75,0.95):
        r=rows[int(top+h*f)]
        print('  f%.2f'%f,(r[1]-r[0]) if r else None)
a=Image.open('anchor-tz_00001_.png').convert('RGB'); q=a.load()
print('grid', [q[x,y] for x,y in ((50,50),(400,50),(780,50),(50,600),(780,600),(50,1180),(400,1200),(780,1180))])
PY
