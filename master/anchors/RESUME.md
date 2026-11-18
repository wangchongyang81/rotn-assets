# Resume after a stop

State at 2026-11-18 22:52. Smoke test was queued, then killed cleanly to avoid a
mid-render Codespace stop. Re-queue it; nothing is lost by the kill.

## Installed, survives a stop, not a rebuild
~/ComfyUI, venv built, cpu torch
~/ComfyUI/models/checkpoints/NoobAI-XL-v1.1.safetensors
  sha256 6681e8e4b134c81f16533acedb0d406d7e5e366e1624b4105178c64d00b05d51
~/models/controlnet/openpose-xinsir-sdxl.safetensors
  sha256 b8524e557a7df60d081f5d4a0eb109967d107df217943bf88c2d99b9ebcc06c5
~/ComfyUI/extra_model_paths.yaml points controlnet at ~/models/controlnet
~/ComfyUI/input/tpose-832x1216.png

## Relaunch
    cd ~/ComfyUI
    nohup ./venv/bin/python3 main.py --cpu --disable-auto-launch --port 8188 > ~/comfy.log 2>&1 &
No --lowvram; it is exclusive with --cpu. Wait for /system_stats 200.

## Re-queue
    node ~/smoke.mjs
    curl -s -X POST -H 'Content-Type: application/json' --data @/tmp/wf.json http://127.0.0.1:8188/prompt
Poll /history/<prompt_id>. 25-40 min on 2 cores.

## Watch
709 MB free. Output PNG is small, but purge ~/.cache/pip if anything large
lands. Raise the idle timeout to 240 before leaving it unattended.
