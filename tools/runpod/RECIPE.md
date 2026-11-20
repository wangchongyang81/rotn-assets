# Pod recipe — proven 2026-11-20

Proven: 4090 SECURE EU-RO-1, 832x1216, 24 steps, 59s, 8.39 it/s, PNG on volume.

## Hard requirements
- torch 2.8.0+cu128, nothing lower. comfy_kitchen uses builtin generics
  (list[bool] in na.py, list[int] in conv3d.py); torch <2.8 rejects them with
  "infer_schema: unsupported type". Source patches never finished under 2.6.
- index https://download.pytorch.org/whl/cu128
- --fp16-unet always (6.6 GB ckpt, 8 GB OOM in fp32)
- listen 0.0.0.0 port 8188
- base runpod/pytorch:2.4.0-py3.11-cuda12.4.1-devel-ubuntu22.04
- volume 39dhm3ia6u at /workspace, container disk 50

## Output
/opt/ComfyUI/output is a real dir on the base. rm it, ln -sfn
/workspace/comfy/output, else renders die with the pod.

## Checkpoint name
Validator wants the subfolder: checkpoints/NoobAI-XL-v1.1.safetensors

## Steps
1. create from pod-probe.json (SECURE, disk 50, startSsh, EU-RO-1)
2. sshinfo.sh for ip/port, key ~/.ssh/id_ed25519
3. remote-boot.sh, wait for "started"
4. remote-prep.sh: torch 2.8.0, output symlink, restart
5. remote-smoke.sh
6. pod-down.sh, volume persists

apt install aria2. exec API is 403, use ssh -n.
