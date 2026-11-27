#!/usr/bin/env bash
set -uo pipefail
S=$1
c=$(curl -s -o /dev/null -w '%{http_code}' http://127.0.0.1:8188/ || true)
[ "$c" = 200 ] || { echo "NOCORE $c"; exit 1; }
python3 - "$S" <<'PY'
import json,sys
s=sys.argv[1]; t=open(f"/workspace/anchors/{s}-t.txt").read().split("negative:")
P,N=t[0].replace("positive:","").strip(),t[1].strip()
w={"1":{"class_type":"CheckpointLoaderSimple","inputs":{"ckpt_name":"NoobAI-XL-v1.1.safetensors"}},"2":{"class_type":"CLIPTextEncode","inputs":{"text":P,"clip":["1",1]}},"3":{"class_type":"CLIPTextEncode","inputs":{"text":N,"clip":["1",1]}},"4":{"class_type":"LoadImage","inputs":{"image":"skel-tpose2.png"}},"6":{"class_type":"ControlNetLoader","inputs":{"control_net_name":"openpose-xinsir-sdxl.safetensors"}},"7":{"class_type":"ControlNetApplyAdvanced","inputs":{"positive":["2",0],"negative":["3",0],"control_net":["6",0],"image":["4",0],"strength":0.9,"start_percent":0.0,"end_percent":1.0,"vae":["1",2]}},"8":{"class_type":"EmptyLatentImage","inputs":{"width":1216,"height":1536,"batch_size":1}},"9":{"class_type":"KSampler","inputs":{"seed":730010,"steps":24,"cfg":6.0,"sampler_name":"euler_ancestral","scheduler":"karras","denoise":1.0,"model":["1",0],"positive":["7",0],"negative":["7",1],"latent_image":["8",0]}},"10":{"class_type":"VAEDecode","inputs":{"samples":["9",0],"vae":["1",2]}},"11":{"class_type":"SaveImage","inputs":{"filename_prefix":"anchor-"+s,"images":["10",0]}}}
json.dump({"prompt":w,"client_id":s},open("/tmp/r.json","w"));print("written")
PY
r=$(curl -s -X POST http://127.0.0.1:8188/prompt -H 'content-type: application/json' --data @/tmp/r.json)
p=$(printf '%s' "$r" | python3 -c 'import json,sys;print(json.load(sys.stdin).get("prompt_id",""))' 2>/dev/null)
for i in $(seq 1 60); do sleep 5; h=$(curl -s "http://127.0.0.1:8188/history/$p"); [[ $h != "{}" ]] && break; done
echo "out $(printf '%s' "$h" | grep -o 'anchor-[a-z-]*_[0-9]*_.png' | head -1)"
