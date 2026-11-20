#!/usr/bin/env bash
set -uo pipefail
cat /workspace/dl.log /workspace/remote-dl.sh.out /workspace/cn.out 2>/dev/null
apt-get update -qq && apt-get install -y -qq aria2 > /workspace/apt.log 2>&1
command -v aria2c && echo ARIA_OK || tail -3 /workspace/apt.log
cd /opt/ComfyUI
grep -rn "stride" --include=*.py comfy | grep "list$$" | head -6
grep -rln "torch.library\|custom_op" --include=*.py comfy | head -6
setsid bash /workspace/remote-dl.sh > /workspace/dl2.out 2>&1 < /dev/null &
setsid bash /workspace/cn.sh > /workspace/cn2.out 2>&1 < /dev/null &
echo relaunched
