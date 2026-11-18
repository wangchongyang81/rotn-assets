# ControlNet record

File: ~/models/controlnet/openpose-xinsir-sdxl.safetensors
Source: huggingface.co/xinsir/controlnet-openpose-sdxl-1.0
  diffusion_pytorch_model.safetensors
Size: 2502139104
sha256: b8524e557a7df60d081f5d4a0eb109967d107df217943bf88c2d99b9ebcc06c5
Licence: apache-2.0
Base: SDXL, loads on NoobAI by architecture

## Obligation
Apache-2.0 requires attribution and a copy of the licence in the shipped
credits, plus a NOTICE of modification if the file is altered.

## Why this file and not the NoobAI one
civitai 962537 is NoobAI-tuned and better on the P-pose, but is login-gated.
This file is ungated. Swap to the NoobAI ControlNet for Stage C once a Civitai
token exists; Stage A is two T-pose fronts, which this handles cleanly.

## twins
The repo also ships diffusion_pytorch_model_twins.safetensors, same byte size,
undocumented in the README. Not downloaded, not needed.
