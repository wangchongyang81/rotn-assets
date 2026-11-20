# RunPod persistent volume
networkVolumeId 39dhm3ia6u
mount /workspace
Models: comfy/models/checkpoints, comfy/models/controlnet
Pods deleted 2026-11-20. Volume persists independently of pods.
Resume: create pod, mount this volume, then `runpodctl pod start` before SSH.
Second recovery path: private HF repo.
