# Pod recipe — proven 2026-11-20

Proven end to end: 4090 SECURE EU-RO-1, 24 steps 832x1216, 59s, 8.39 it/s,
413 KB PNG on the volume. Volume 39dhm3ia6u holds checkpoint, ControlNet,
outputs. Pod terminated after proof; volume persists.

Order matters. Every step is a script; run them in sequence.

1. body: tools/runpod/pod-probe.json (SECURE, disk 30, startSsh,
   mounts.network volume 39dhm3ia6u at /workspace, dataCenterIds EU-RO-1)
2. create, then read .runtime.ports[] where private is 22 for the SSH port
3. remote-boot.sh   clone 8f40b43, pip install, symlinks, start ComfyUI
4. remote-patch.sh  list[int] -> List[int] in comfy/ldm/modules/attention.py:662
5. remote-fixout.sh move PNGs, output -> volume symlink, restart
6. remote-smoke.sh  checkpoint name carries the checkpoints/ prefix

ssh: root@<ip> -p <port> -i ~/.ssh/id_ed25519

SECURE needs the disk field; COMMUNITY rejects without capacity in EU-RO-1.
Torch 2.6.0+cu124 with the patch. --fp16-unet always.
