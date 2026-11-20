#!/usr/bin/env bash
set -uo pipefail
python -c 'import torch;print("torch",torch.__version__)'; curl -s -o /dev/null -w "http %{http_code}\n" http://127.0.0.1:8188/
cd /workspace/comfy/output
ls -l anchor-qa4_00001_.png
python - <<'PY'
from PIL import Image
im=Image.open('anchor-qa4_00001_.png').convert('RGB'); W,Hh=im.size; px=im.load()
bg=px[4,4]
def d(p): return sum(abs(a-b) for a,b in zip(p,bg))
rows=[]
for y in range(Hh):
    xs=[x for x in range(0,W,2) if d(px[x,y])>24]
    rows.append(xs)
ys=[i for i,x in enumerate(rows) if x]; top,bot=ys[0],ys[-1]; h=bot-top
print('h',h,'top',top)
for pct in (12,15,18,21,44,48,52,56,58):
    y=int(top+h*pct/100); xs=rows[y]
    runs=1 if not xs else 1+sum(1 for a,b in zip(xs,xs[1:]) if b-a>8)
    print(f'{pct}% runs {runs}', xs[0] if xs else None, xs[-1] if xs else None)
PY
