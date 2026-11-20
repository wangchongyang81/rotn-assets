#!/usr/bin/env bash
set -uo pipefail
python -c 'import PIL' 2>/dev/null || pip install -q pillow
python - <<'PY'
from pathlib import Path
from PIL import Image, ImageDraw, ImageFont
o=Path('/workspace/comfy/output')
try: f=ImageFont.load_default(size=26)
except Exception: f=ImageFont.load_default()
W,H=832,1216
names=[('anchor-tv2','T anchor'),('anchor-pv2','P anchor'),('skel-tpose','T skeleton'),('skel-ppose6','P skeleton')]
cells=[]
for n,lab in names:
    p=o/(n+'_00001_.png' if not n.startswith('skel-') else n+'.png')
    im=Image.open(p).convert('RGB'); im.thumbnail((W,H))
    c=Image.new('RGB',(W,H+34),'white')
    c.paste(im,((W-im.width)//2,34+(H-im.height)//2))
    ImageDraw.Draw(c).text((8,6),lab,fill='black',font=f)
    cells.append(c)
s=Image.new('RGB',(W*2,(H+34)*2),'white')
for i,c in enumerate(cells): s.paste(c,((i%2)*W,(i//2)*(H+34)))
s.save(o/'sheet-final.png'); print('sheet',s.size)
PY
ls -l /workspace/comfy/output/sheet-final.png
