#!/usr/bin/env bash
set -uo pipefail
echo "=== log"; tail -12 /workspace/comfy/comfy.log
python - <<'PY'
import pathlib
root=pathlib.Path('/usr/local/lib/python3.11/dist-packages/comfy_kitchen')
n=0
for p in sorted(root.rglob('*.py')):
    L=p.read_text().split('\n')
    fi=[i for i,l in enumerate(L) if l.startswith('from __future__')]
    ti=[i for i,l in enumerate(L) if l.startswith('from typing import')]
    if not fi or not ti or ti[0] > fi[0]: continue
    line=L.pop(ti[0]); L.insert(fi[0],line)
    p.write_text('\n'.join(L)); n+=1; print('fixed',p.name)
print('fixed_count',n)
PY
cd /opt/ComfyUI
nohup python main.py --listen 0.0.0.0 --port 8188 --fp16-unet > /workspace/comfy/comfy.log 2>&1 &
sleep 18
curl -s -o /dev/null -w "local %{http_code}\n" http://127.0.0.1:8188/
tail -6 /workspace/comfy/comfy.log
