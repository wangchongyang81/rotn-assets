#!/usr/bin/env bash
set -uo pipefail
pkill -f main.py || true
python - <<'PY'
import pathlib
root=pathlib.Path('/usr/local/lib/python3.11/dist-packages/comfy_kitchen')
n=0
for p in sorted(root.rglob('*.py')):
    s=p.read_text()
    if 'list[int]' not in s: continue
    s=s.replace('list[int]','List[int]')
    if 'from typing import List' not in s:
        L=s.split('\n')
        for i,l in enumerate(L):
            if l.startswith(('import ','from ')):
                L.insert(i,'from typing import List'); break
        s='\n'.join(L)
    p.write_text(s); n+=1; print('patched',p.name)
print('files',n)
PY
cd /opt/ComfyUI
nohup python main.py --listen 0.0.0.0 --port 8188 --fp16-unet > /workspace/comfy/comfy.log 2>&1 &
sleep 16
curl -s -o /dev/null -w "local %{http_code}\n" http://127.0.0.1:8188/
