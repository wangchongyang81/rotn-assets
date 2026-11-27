# RunPod persistent volume
networkVolumeId 39dhm3ia6u
mount /workspace
Models: comfy/models/checkpoints, comfy/models/controlnet
One pod only: rotn-pilot. No live pod is assumed. The volume persists
independently of pods. Resume: create pod, mount this volume, then
`runpodctl pod start` before SSH.
Second recovery path: private HF repo, text manifest plus binaries bucket.
See pod-runbook.md.

## Resume command
create.sh is the primary path (x-api-key via gql.sh). The runpodctl form
below is the fallback and is unproven since the Bearer 401 on 2026-11-23;
up-connect.sh wraps it.
runpodctl pod create --name rotn-pilot \
  --network-volume-id 39dhm3ia6u \
  --volume-mount-path /workspace \
  --container-disk-in-gb 50 \
  --gpu-id "NVIDIA GeForce RTX 4090" \
  --ports "22/tcp,8188/http" \
  --image runpod/pytorch:2.4.0-py3.11-cuda12.4.1-devel-ubuntu22.04
Then `runpodctl pod get <id>` for the SSH port, then comfy with --fp16-unet.

## Cost
Network volume 39dhm3ia6u bills ~0.19 USD/day (~5.70/month, ~3.8% of the
150 budget). No live pod, so compute is 0.00. This is the only residual charge.

## Resume PROVEN 2026-11-21 - host and port dead, values historical
Pod kc45pk4bayvjfh, host 213.173.102.196, port 33616.
Volume remounted: NoobAI-XL-v1.1.safetensors 7105349958 bytes, controlnet
present, 4090 live. Ports published at create via --ports. Attach flag is
--network-volume-id.
