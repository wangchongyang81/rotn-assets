#!/usr/bin/env bash
set -uo pipefail
pkill -f main.py || true
python - <<'PY'
import pathlib, re
roots=[pathlib.Path('/usr/local/lib/python3.11/dist-packages/comfy_kitchen'), pathlib.Path('/opt/ComfyUI/comfy')]
pairs=[(r'\blist$$','List['),(r'\bdict$$','Dict['),(r'\btuple$$','Tuple['),(r'\bset$$','Set[')]
n=0
for root in roots:
    for p in sorted(root.rglob('*.py')):
        s=p.read_text(); o=s
        for a,b in pairs: s=re.sub(a,b,s)
        if s==o: continue
        if 'from typing import' not in s:
            L=s.split('\n')
            for i,l in enumerate(L):
                if l.startswith(('import ','from ')):
                    L.insert(i,'from typing import Dict, List, Set, Tuple'); break
            s='\n'.join(L)
        p.write_text(s); n+=1
print('files',n)
PY
cd /opt/ComfyUI
nohup python main.py --listen 0.0.0.0 --port 8188 --fp16-unet > /workspace/comfy/comfy.log 2>&1 &
sleep 18
curl -s -o /dev/null -w "local %{http_code}\n" http://127.0.0.1:8188/
grep -rn "unsupported type" /workspace/comfy/comfy.log | head -2
