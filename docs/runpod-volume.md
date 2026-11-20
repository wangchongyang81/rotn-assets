# RunPod persistent volume
networkVolumeId 39dhm3ia6u
mount /workspace
Models: comfy/models/checkpoints, comfy/models/controlnet
Pods deleted 2026-11-20. Volume persists independently of pods.
Resume: create pod, mount this volume, then `runpodctl pod start` before SSH.
Second recovery path: private HF repo.

## Resume command
runpodctl pod create --name rotn-pilot-3 \
  --network-volume-id 39dhm3ia6u \
  --volume-mount-path /workspace \
  --container-disk-in-gb 50 \
  --gpu-id "NVIDIA GeForce RTX 4090" \
  --image runpod/pytorch:2.4.0-py3.11-cuda12.4.1-devel-ubuntu22.04
Then `runpodctl pod get <id>` for the SSH port, then comfy with --fp16-unet.

## Cost
Network volume 39dhm3ia6u bills ~0.19 USD/day (~5.70/month, ~3.8% of the 150 budget).
Pods deleted 2026-11-20, compute at 0.00. This line is the only residual charge.
