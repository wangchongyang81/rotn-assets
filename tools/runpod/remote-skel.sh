#!/usr/bin/env bash
set -uo pipefail
cd /workspace/comfy/output
ls -l skel-t_00001_.png skel-tz_00001_.png
python - <<'PY'
from PIL import Image, ImageChops
for n in ('skel-t_00001_.png','skel-tz_00001_.png'):
    im=Image.open(n).convert('L'); W,Hh=im.size; px=im.load()
    print(n,im.size,'extrema',im.getextrema())
    print(' rows>20',sum(1 for y in range(Hh) if any(px[x,y]>20 for x in range(0,W,4))))
    print(' bright',sum(1 for y in range(0,Hh,4) for x in range(0,W,4) if px[x,y]>20))
a=Image.open('skel-t_00001_.png').convert('L').resize((832,1216))
b=Image.open('skel-tz_00001_.png').convert('L').resize((832,1216))
print('diff bbox',ImageChops.difference(a,b).getbbox())
PY
