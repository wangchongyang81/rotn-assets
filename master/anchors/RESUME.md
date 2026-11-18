# Resume after a stop

Smoke test queued 2026-11-18 22:58. Idle timeout is 240, so it can finish
unattended. Do NOT run `pkill -f 'main.py'` in a block that does more work: the
pattern matches the shell running the block and kills it.

## Installed, survives a stop, not a rebuild
~/ComfyUI with cpu torch
~/ComfyUI/models/checkpoints/NoobAI-XL-v1.1.safetensors
  sha256 6681e8e4b134c81f16533acedb0d406d7e5e366e1624b4105178c64d00b05d51
~/models/controlnet/openpose-xinsir-sdxl.safetensors
  sha256 b8524e557a7df60d081f5d4a0eb109967d107df217943bf88c2d99b9ebcc06c5

## Relaunch
    cd ~/ComfyUI
    nohup ./venv/bin/python3 main.py --cpu --disable-auto-launch --port 8188 > ~/comfy.log 2>&1 &
No --lowvram, exclusive with --cpu. Wait for /system_stats 200.

## Re-queue
    node ~/smoke.mjs
    curl -s -X POST -H 'Content-Type: application/json' --data @/tmp/wf.json http://127.0.0.1:8188/prompt
Poll /history/<prompt_id>, 25-40 min.

## Fallback
fal.ai deploy of the same workflow, unchanged JSON. See FAL.md.
