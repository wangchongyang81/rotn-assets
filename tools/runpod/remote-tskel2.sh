#!/usr/bin/env bash
set -uo pipefail
D=/workspace/comfy/output
df -h /workspace | tail -1; ls -lt $D | head -6
python - <<'PY'
from PIL import Image, ImageDraw
W,H=832,1216
im=Image.new('RGB',(W,H),(0,0,0)); d=ImageDraw.Draw(im)
L=[((416,260),(416,620)),((416,300),(300,300)),((300,300),(230,300)),((230,300),(160,300)),
   ((416,300),(532,300)),((532,300),(602,300)),((602,300),(672,300)),
   ((416,620),(340,620)),((340,620),(330,850)),((330,850),(320,1080)),((320,1080),(300,1140)),
   ((416,620),(492,620)),((492,620),(502,850)),((502,850),(512,1080)),((512,1080),(532,1140))]
for a,b in L: d.line([a,b],fill=(255,255,255),width=13)
d.ellipse([360,144,472,256],outline=(255,255,255),width=13)
im.save('/workspace/comfy/output/skel-tpose.png'); print('drawn',im.size)
PY
ls -l $D/skel-tpose.png
bash /workspace/tz5.sh
