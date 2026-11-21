#!/usr/bin/env bash
set -euo pipefail
V=/workspace/comfy
mkdir -p $V/models/checkpoints $V/models/controlnet $V/models/loras $V/output $V/input
cd /opt
[ -d ComfyUI ] || git clone -q https://github.com/comfyanonymous/ComfyUI.git
cd ComfyUI
git checkout -q 8f40b43e0204d5b9780f3e9618e140e929e80594
pip install -q -r requirements.txt
python -c "import torch,torchaudio,sys;sys.exit(0 if torch.__version__.startswith('2.8') else 1)" 2>/dev/null || \
  pip install -q --index-url https://download.pytorch.org/whl/cu128 torch==2.8.0 torchvision==0.23.0 torchaudio==2.8.0
ln -sfn $V/models/checkpoints models/checkpoints
ln -sfn $V/models/controlnet models/controlnet
ln -sfn $V/models/loras models/loras
ln -sfn $V/output output
ln -sfn $V/input input
sed -i 's/^except ImportError as e:/except Exception as e:/' comfy/quant_ops.py
pkill -f "[m]ain.py" || true
setsid nohup python main.py --listen 0.0.0.0 --port 8188 --fp16-unet > $V/comfy.log 2>&1 < /dev/null &
echo started
