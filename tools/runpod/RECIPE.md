# Pod recipe — proven 2026-11-20

Proven: 4090 SECURE EU-RO-1, 832x1216, 28 steps, anchor pair + sheet on volume.

## Hard requirements
- torch 2.8.0+cu128, nothing lower. comfy_kitchen uses builtin generics
  (list[bool], list[int]); torch <2.8 rejects with "infer_schema: unsupported type".
- index https://download.pytorch.org/whl/cu128
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
1. create from pod-probe.json (SECURE, disk 50, startSsh, EU-RO-1)
2. sshinfo.sh for ip/port, key ~/.ssh/id_ed25519
3. remote-boot.sh, wait for "started"
4. remote-prep.sh: torch 2.8.0, both symlinks, restart
5. remote-aux.sh: controlnet_aux pack, re-pin torch after
6. anchor sheet, seed 7 throughout, strength 0.9:
   remote-pose.sh, remote-anchor.sh, remote-ppose.sh, remote-anchorp.sh, remote-sheet.sh
7. pod-down.sh, volume persists
