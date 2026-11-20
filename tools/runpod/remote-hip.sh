#!/usr/bin/env bash
set -uo pipefail
cd /workspace/comfy/output
python - <<'PY'
from PIL import Image
im=Image.open('anchor-qa2_00001_.png').convert('RGB'); W,Hh=im.size; px=im.load()
bg=px[4,4]
def d(p): return sum(abs(a-b) for a,b in zip(p,bg))
rows=[]
for y in range(Hh):
    xs=[x for x in range(0,W,2) if d(px[x,y])>24]
    rows.append(xs)
ys=[i for i,x in enumerate(rows) if x]; top,bot=ys[0],ys[-1]; h=bot-top
for pct in (44,46,48,50,52,54,56):
    y=int(top+h*pct/100); xs=rows[y]
    runs=1 if not xs else 1+sum(1 for a,b in zip(xs,xs[1:]) if b-a>8)
    print(f'{pct}% runs {runs}', xs[0] if xs else None, xs[-1] if xs else None)
PY
