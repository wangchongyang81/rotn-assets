#!/usr/bin/env bash
set -euo pipefail
V=/workspace/comfy
mkdir -p $V/models/checkpoints $V/models/controlnet $V/models/loras $V/output $V/input
cd /opt
[ -d ComfyUI ] || git clone -q https://github.com/comfyanonymous/ComfyUI.git
cd ComfyUI
git checkout -q 8f40b43e0204d5b9780f3e9618e140e929e80594
pip install -q --break-system-packages -r requirements.txt
python -c "import torch,torchaudio,sys;sys.exit(0 if torch.__version__.startswith('2.8') else 1)" 2>/dev/null || \
  pip install -q --break-system-packages --index-url https://download.pytorch.org/whl/cu128 torch==2.8.0 torchvision==0.23.0 torchaudio==2.8.0
for d in models/checkpoints models/controlnet models/loras output input; do rm -rf "$d"; done
ln -sfnT $V/models/checkpoints models/checkpoints
ln -sfnT $V/models/controlnet models/controlnet
ln -sfnT $V/models/loras models/loras
ln -sfnT $V/output output
ln -sfnT $V/input input
if grep -q '^except ImportError as e:' comfy/quant_ops.py; then
  sed -i 's/^except ImportError as e:/except Exception as e:/' comfy/quant_ops.py; echo PATCHED
else echo NOPATCH; fi
pkill -f "[m]ain.py" || true
setsid nohup python main.py --listen 0.0.0.0 --port 8188 --fp16-unet > $V/comfy.log 2>&1 < /dev/null &
for i in $(seq 1 20); do
  c=$(curl -s -o /dev/null -w '%{http_code}' http://127.0.0.1:8188/ || true)
  [ "$c" = "200" ] && { echo "STARTED $c"; exit 0; }
  sleep 3
done
echo "START FAIL $(tail -3 $V/comfy.log | cut -c1-80)" >&2; exit 1
