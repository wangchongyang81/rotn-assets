#!/usr/bin/env bash
set -uo pipefail
python - <<'PY'
p='/opt/ComfyUI/comfy/ldm/modules/attention.py'
s=open(p).read(); b=s
s=s.replace('list[int]','List[int]')
if 'from typing import List' not in s:
    L=s.split('\n')
    for i,l in enumerate(L):
        if l.startswith('import ') or l.startswith('from '):
            L.insert(i,'from typing import List'); break
    s='\n'.join(L)
open(p,'w').write(s)
print('patched' if s!=b else 'no change')
PY
for i in $(seq 1 40); do pgrep -f "pip install" >/dev/null || break; sleep 5; done
pkill -f main.py || true
cd /opt/ComfyUI
nohup python main.py --listen 0.0.0.0 --port 8188 --fp16-unet > /workspace/comfy/comfy.log 2>&1 &
sleep 14
curl -s -o /dev/null -w "local %{http_code}\n" http://127.0.0.1:8188/
