#!/usr/bin/env bash
set -euo pipefail
P=${1:?pose}; T=${2:?tag}; SD=${3:?seed}
CFG=${CFG:-5.0}; SMP=${SMP:-euler_ancestral}; SCH=${SCH:-karras}; STP=${STP:-28}
CNS=${CNS:-0.9}; W=${W:-832}; H=${H:-1216}; DEN=${DEN:-1.0}; IMG=${IMG:-}
CKPT=${CKPT:-lustify_v9_finalsdxl_.safetensors}
VAE=${VAE:-sdxl_vae.safetensors}
I=${I:-/workspace/comfy/input}
SK=${SK:-skel-$P.png}
[ -s "$I/$SK" ] || { echo "NOSKEL $SK" >&2; exit 1; }
[ -s "$I/prompt-$P.txt" ] || { echo "NOPROMPT $P" >&2; exit 1; }
c=$(curl -s -o /dev/null -w "%{http_code}" http://127.0.0.1:8188/ || true)
[ "$c" = 200 ] || { echo "NOCORE $c" >&2; exit 1; }
: > /tmp/gen-debug.log
J=$(python3 - \
  "$I" "$P" "$T" "$SD" "$CFG" "$SMP" "$SCH" "$STP" \
  "$CKPT" "$VAE" "$SK" "$W" "$H" "$CNS" "$IMG" "$DEN" <<PY
import json,sys
i,p,t,sd,cfg,smp,sch,stp,ck,vae,sk,w,h,cns,img,den=sys.argv[1:]
rd=lambda f:open(f"{i}/{f}").read().strip()
g={"3":("CheckpointLoaderSimple",{"ckpt_name":ck}),
 "5":("LoadImage",{"image":sk}),
 "6":("ControlNetLoader",{"control_net_name":"openpose-xinsir-sdxl.safetensors"}),
 "7":("CLIPTextEncode",{"text":rd(f"prompt-{p}.txt"),"clip":["3",1]}),
 "8":("CLIPTextEncode",{"text":rd(f"neg-{p}.txt"),"clip":["3",1]}),
 "9":("ControlNetApplyAdvanced",{"positive":["7",0],"negative":["8",0],
   "control_net":["6",0],"image":["5",0],"strength":float(cns),
   "start_percent":0.0,"end_percent":1.0,"vae":["3",2]}),
 "10":("EmptyLatentImage",{"width":int(w),"height":int(h),"batch_size":1}),
 "11":("KSampler",{"seed":int(sd),"steps":int(stp),"cfg":float(cfg),
   "sampler_name":smp,"scheduler":sch,"denoise":1.0,"model":["3",0],
   "positive":["9",0],"negative":["9",1],"latent_image":["10",0]}),
 "12":("VAEDecode",{"samples":["11",0],"vae":["3",2]}),
 "13":("SaveImage",{"filename_prefix":t,"images":["12",0]})}
if img:
 g["14"]=("LoadImage",{"image":img})
 g["15"]=("VAEEncode",{"pixels":["14",0],"vae":["3",2]})
 g["11"][1]["latent_image"]=["15",0]
 g["11"][1]["denoise"]=float(den)
w2={k:{"class_type":v[0],"inputs":v[1]} for k,v in g.items()}
print(json.dumps({"prompt":w2,"client_id":t}))
PY
)
echo "$J" > /tmp/gen-prompt.json
r=$(curl -s -X POST -H "content-type: application/json" -d "$J" http://127.0.0.1:8188/prompt)
echo "q $r" >> /tmp/gen-debug.log
pid=$(printf "%s" "$r" | python3 -c "import json,sys
try: print(json.load(sys.stdin).get(\"prompt_id\") or \"\")
except Exception: print(\"\")")
[ -n "$pid" ] || { echo "NOPID $r" >&2; exit 1; }
st=; f=
for i in $(seq 1 240); do
  sleep 2
  h=$(curl -s "http://127.0.0.1:8188/history/$pid")
  read -r st f < <(printf "%s" "$h" | python3 -c "import json,sys
try: d=json.load(sys.stdin)
except Exception: print(\"waiting -\"); raise SystemExit
e=d.get(sys.argv[1]) or {}
s=e.get(\"status\") or {}
o=e.get(\"outputs\") or {}
n=[x[\"filename\"] for v in o.values() for x in (v.get(\"images\") or [])]
print(s.get(\"status_str\",\"waiting\"), n[0] if n else \"-\")" "$pid") || true
  echo "$i $st $f" >> /tmp/gen-debug.log
  [ "$st" = success ] && break
  if [ "$st" = error ]; then echo "ERROR $T" >&2; tail -5 /tmp/gen-debug.log >&2; exit 1; fi
done
if [ "$st" != success ] || [ "$f" = - ]; then echo "TIMEOUT $T st=$st" >&2; exit 1; fi
echo "$f"
