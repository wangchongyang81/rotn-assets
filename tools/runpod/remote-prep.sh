#!/usr/bin/env bash
set -uo pipefail
pkill -f main.py || true
pip install -q --no-cache-dir --index-url https://download.pytorch.org/whl/cu124 --upgrade torch torchvision torchaudio > /workspace/torch.log 2>&1
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
mkdir -p /workspace/comfy/output
rm -rf /opt/ComfyUI/output
ln -sfn /workspace/comfy/output /opt/ComfyUI/output
cd /opt/ComfyUI
nohup python main.py --listen 0.0.0.0 --port 8188 --fp16-unet > /workspace/comfy/comfy.log 2>&1 &
sleep 15
curl -s -o /dev/null -w "local %{http_code}\n" http://127.0.0.1:8188/
