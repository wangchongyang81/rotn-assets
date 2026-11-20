# Pod recipe — proven 2026-11-20

Proven: 4090 SECURE EU-RO-1, 832x1216, 28 steps, anchor pair + sheet on volume.

## Hard requirements
- torch 2.8.0+cu128 only; <2.8 fails "infer_schema: unsupported type". /whl/cu128
- controlnet_aux requirements.txt downgrades torch: re-pin after it
- --fp16-unet always (6.6 GB ckpt, 8 GB OOM in fp32)
- base runpod/pytorch:2.4.0-py3.11-cuda12.4.1-devel-ubuntu22.04
- volume 39dhm3ia6u at /workspace, disk 50, SECURE EU-RO-1; apt aria2; exec 403

## Symlinks — both targets are real dirs on the base
rm -rf /opt/ComfyUI/output /opt/ComfyUI/input
ln -sfn /workspace/comfy/output /opt/ComfyUI/output
ln -sfn /workspace/comfy/output /opt/ComfyUI/input
# model paths carry their subfolder
checkpoints/NoobAI-XL-v1.1.safetensors
controlnet/openpose-xinsir-sdxl.safetensors

## Steps
1. up-connect.sh: create from pod-probe.json, retry, print ssh mapping. Key ~/.ssh/id_ed25519
2. remote-boot.sh, wait for "started"
3. remote-prep.sh: pins torch 2.8.0, both symlinks, restarts, wants "local 200"
4. remote-aux.sh: clones github.com/Fannovel16/comfyui_controlnet_aux, installs
   requirements.txt, re-pins torch 2.8.0, restarts, wants "local 200" and
   OpenposePreprocessor in the object_info pose list
5. remote-dl.sh then remote-cn.sh, wait for ckpt_done and cn_done in /workspace/dl.log
6. remote-smoke.sh, gate on smoke_00001_.png
7. anchors: seed 7, strength 0.9, prompts and negative in PROMPTS.md
   remote-tskel3.sh draws skel-tpose.png and renders anchor-tv2
   remote-pskel.sh draws skel-ppose.png and renders anchor-pv
   remote-sheet.sh tiles the four into sheet-final.png
   gate each render: f0.18 above 700 on T, h within 8%, corners 255
8. pod-down.sh, volume persists
