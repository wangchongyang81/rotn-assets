#!/usr/bin/env bash
set -euo pipefail
P=${1:?pose}; T=${2:?tag}; SD=${3:?seed}
CFG=${CFG:-5.0}; SMP=${SMP:-dpmpp_2m}
I=/workspace/comfy/input
J=$(python - "$I" "$P" "$T" "$SD" "$CFG" "$SMP" <<'PY'
import json,sys
i,p,t,sd,cfg,smp=sys.argv[1:]
rd=lambda f:open(f"{i}/{f}").read().strip()
g={"3":("CheckpointLoaderSimple",{"ckpt_name":"NoobAI-XL-v1.1.safetensors"}),
"4":("ControlNetLoader",{"control_net_name":"openpose-xinsir-sdxl.safetensors"}),
"5":("LoadImage",{"image":f"skel-{p}.png","upload":"image"}),
"6":("CLIPTextEncode",{"text":rd(f"prompt-{p}.txt"),"clip":["3",1]}),
"7":("CLIPTextEncode",{"text":rd(f"neg-{p}.txt"),"clip":["3",1]}),
"8":("ControlNetApplyAdvanced",{"strength":0.85,"start_percent":0.0,"end_percent":1.0,"positive":["6",0],"negative":["7",0],"control_net":["4",0],"image":["5",0]}),
"9":("EmptyLatentImage",{"width":832,"height":1216,"batch_size":1}),
"10":("KSampler",{"seed":int(sd),"steps":28,"cfg":float(cfg),"sampler_name":smp,"scheduler":"karras","denoise":1.0,"model":["3",0],"positive":["8",0],"negative":["8",1],"latent_image":["9",0]}),
"11":("VAEDecode",{"samples":["10",0],"vae":["3",2]}),
"12":("SaveImage",{"filename_prefix":t,"images":["11",0]})}
print(json.dumps({"prompt":{k:{"class_type":v[0],"inputs":v[1]} for k,v in g.items()}}))
PY
)
PID=$(curl -s -X POST -H 'Content-Type: application/json' -d "$J" http://127.0.0.1:8188/prompt | python -c "import json,sys;print(json.load(sys.stdin)['prompt_id'])")
for i in $(seq 1 180); do
  R=$(curl -s http://127.0.0.1:8188/history/$PID)
  case "$R" in *'"status_str": "success"'*) break;; *'"status_str": "error"'*) echo fail; exit 1;; esac; sleep 2
done
echo "$T done"
