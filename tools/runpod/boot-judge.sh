#!/usr/bin/env bash
set -euo pipefail
M=/workspace/comfy
[ -d "$M/output" ] || { echo "NOVOLUME $M/output" >&2; exit 1; }
mkdir -p /workspace/judge/in /workspace/judge/log
python -c "import torch,sys;sys.exit(0 if torch.cuda.is_available() else 1)" || { echo NOCUDA >&2; exit 1; }
nvidia-smi --query-gpu=name,memory.total --format=csv,noheader
echo BOOTJUDGE_OK
