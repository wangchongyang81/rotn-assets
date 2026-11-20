# Pod recipe — proven 2026-11-20

Proven: 4090 SECURE EU-RO-1, 832x1216, 28 steps, anchor pair + sheet on volume.

## Hard requirements
- torch 2.8.0+cu128 only, via remote-torch28.sh. comfy_kitchen needs builtin generics
  (list[bool], list[int]); <2.8 fails "infer_schema: unsupported type". Index /whl/cu128
- --fp16-unet always (6.6 GB ckpt, 8 GB OOM in fp32)
- base runpod/pytorch:2.4.0-py3.11-cuda12.4.1-devel-ubuntu22.04
- volume 39dhm3ia6u at /workspace, container disk 50, SECURE EU-RO-1
- apt install aria2. exec API is 403, use ssh -n.

## Symlinks — both are real dirs on the base
rm -rf /opt/ComfyUI/output /opt/ComfyUI/input
ln -sfn /workspace/comfy/output /opt/ComfyUI/output
ln -sfn /workspace/comfy/output /opt/ComfyUI/input

## Names carry the subfolder
checkpoints/NoobAI-XL-v1.1.safetensors
controlnet/openpose-xinsir-sdxl.safetensors

## Steps
1. up-connect.sh: create from pod-probe.json, retry capacity, print ssh mapping. Key ~/.ssh/id_ed25519
2. remote-boot.sh, wait for "started"
3. remote-prep.sh, restart
4. remote-torch28.sh, restart; remote-aux.sh, then remote-torch28.sh again
5. remote-dl.sh then remote-cn.sh, wait for ckpt_done and cn_done in /workspace/dl.log
6. remote-smoke.sh, gate on smoke_00001_.png
7. anchors: seed 7, strength 0.9, prompts and negative in PROMPTS.md
   remote-tskel3.sh draws skel-tpose.png and renders anchor-tv2
   remote-pskel.sh draws skel-ppose.png and renders anchor-pv
   remote-sheet.sh tiles the four into sheet-final.png
   gate each render: f0.18 above 700 on T, h within 8%, corners 255
8. pod-down.sh, volume persists
