# Workflow

The API-format workflow, the artifact that transfers to fal unchanged.
`build-smoke.mjs` rebuilds the JSON from the prompt file; the JSON is the
committed truth.

Nodes: checkpoint, two encodes, LoadImage skeleton, ControlNetLoader,
ControlNetApplyAdvanced 0.8 full range, latent 832x1216, KSampler euler_ancestral
karras 24 cfg 6 seed 730000, VAEDecode, SaveImage.

## Local status
CPU, 2 cores, no GPU. Dies at model load with or without --fp16-unet.
`manual cast: torch.float32` means fp16 halves storage, not the working set.
OOM on 7.9 GB RAM. Untested output. Local abandoned for throughput.

## fal
Same JSON. Replace LoadImage and the two loader nodes with uploaded file URLs.
Confirm the endpoint accepts seed, negative and safety off before trusting it.
