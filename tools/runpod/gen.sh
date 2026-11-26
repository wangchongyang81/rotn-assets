#!/usr/bin/env bash
set -euo pipefail
P=${1:?pose}; T=${2:?tag}; SD=${3:?seed}
CFG=${CFG:-5.0}; SMP=${SMP:-dpmpp_2m}; SCH=${SCH:-karras}; STP=${STP:-30}
CKPT=${CKPT:-bigaspv25-20250716.safetensors}
I=${I:-/workspace/comfy/input}
J=$(python - "$I" "$P" "$T" "$SD" "$CFG" "$SMP" "$SCH" "$STP" "$CKPT" <<'PY'
import json,sys,os
i,p,t,sd,cfg,smp,sch,stp,ck=sys.argv[1:]
rd=lambda f:open(f"{i}/{f}").read().strip()
g={"3":("CheckpointLoaderSimple",{"ckpt_name":ck}),
"4":("PixelSpaceVAELoader",{"pixel_space":"sdxl_vae.safetensors"}),
"6":("CLIPTextEncode",{"text":rd(f"prompt-{p}.txt"),"clip":["3",1]}),
"7":("CLIPTextEncode",{"text":rd(f"neg-{p}.txt"),"clip":["3",1]}),
"9":("EmptyLatentImage",{"width":int(os.environ.get("W",832)),"height":int(os.environ.get("H",1216)),"batch_size":1}),
"10":("KSampler",{"seed":int(sd),"steps":int(stp),"cfg":float(cfg),"sampler_name":smp,"scheduler":sch,"denoise":1.0,"model":["3",0],"positive":["6",0],"negative":["7",0],"vae":["4",0],"latent_image":["9",0]}),
"11":("VAEDecode",{"samples":["10",0],"vae":["4",0]}),
"12":("SaveImage",{"filename_prefix":t,"images":["11",0]})}
print(json.dumps({"prompt":{k:{"class_type":v[0],"inputs":v[1]} for k,v in g.items()}}))
PY
)
PID=$(curl -s -X POST -H 'Content-Type: application/json' -d "$J" http://127.0.0.1:8188/prompt | python -c "import json,sys;print(json.load(sys.stdin)['prompt_id'])")
for i in $(seq 1 240); do
  R=$(curl -s http://127.0.0.1:8188/history/$PID)
  case "$R" in *'"status_str": "success"'*) break;; *'"status_str": "error"'*) echo fail; exit 1;; esac; sleep 2
done
echo "$T done"
