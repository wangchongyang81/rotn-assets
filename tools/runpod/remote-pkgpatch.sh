#!/usr/bin/env bash
set -uo pipefail
pkill -f main.py || true
python - <<'PY'
import pathlib,re
root=pathlib.Path('/usr/local/lib/python3.11/dist-packages/comfy_kitchen')
pat=re.compile(r'\b(list|dict|tuple|set)$$')
for p in sorted(root.rglob('*.py')):
    s=p.read_text(); n=len(pat.findall(s))
    if not n: continue
    s=pat.sub(lambda m:m.group(1).capitalize()+'[',s)
    if 'from typing import' not in s:
        L=s.split('\n')
        for i,l in enumerate(L):
            if l.startswith(('import ','from ')):
                L.insert(i,'from typing import Dict, List, Set, Tuple'); break
        s='\n'.join(L)
    p.write_text(s); print('patched',p.name,n)
PY
echo "=== left"; grep -rnE '\b(list|dict|tuple|set)$$' /usr/local/lib/python3.11/dist-packages/comfy_kitchen --include=*.py | head -5
cd /opt/ComfyUI
nohup python main.py --listen 0.0.0.0 --port 8188 --fp16-unet > /workspace/comfy/comfy.log 2>&1 &
sleep 18
curl -s -o /dev/null -w "local %{http_code}\n" http://127.0.0.1:8188/
