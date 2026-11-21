#!/usr/bin/env bash
set -euo pipefail
B=hf://buckets/wangchongyang81/rotn-bin
cd /workspace
NEW=$(ls -1 images/comfy-app-2*.tar.gz | sort | tail -1)
ln -sf "$NEW" images/comfy-app-LATEST.tar.gz
echo "latest -> $NEW"
hf buckets sync comfy/models "$B/models" --include '*.safetensors' --plan /root/m.plan
hf buckets sync --apply /root/m.plan
hf buckets sync images "$B/snapshots" --include '*.tar.gz' --plan /root/s.plan
hf buckets sync --apply /root/s.plan
REM=$(hf buckets ls -R "$B/models"; hf buckets ls -R "$B/snapshots")
for p in models/checkpoints/NoobAI-XL-v1.1.safetensors \
         models/controlnet/openpose-xinsir-sdxl.safetensors; do
  L=$(stat -c%s "comfy/${p#models/}")
  R=$(printf '%s\n' "$REM" | awk -v p="$p" '$NF==p {print $1}')
  [ "$L" = "$R" ] || { echo "SIZE MISMATCH $p local=$L remote=$R"; exit 1; }
done
for t in images/comfy-app-2*.tar.gz; do
  b=snapshots/$(basename "$t")
  L=$(stat -c%s "$t")
  R=$(printf '%s\n' "$REM" | awk -v p="$b" '$NF==p {print $1}')
  [ "$L" = "$R" ] || { echo "SIZE MISMATCH $b local=$L remote=$R"; exit 1; }
done
echo "MIRROR VERIFIED - safe to terminate"
