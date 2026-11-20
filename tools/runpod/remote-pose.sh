#!/usr/bin/env bash
set -uo pipefail
python - <<'PY'
import json
C="checkpoints/NoobAI-XL-v1.1.safetensors"
P="1girl, solo, t-pose, arms out, standing, full body, white background"
N="lowres, blurry, bad anatomy, extra limbs, cropped, watermark"
w={"1":{"class_type":"CheckpointLoaderSimple","inputs":{"ckpt_name":C}},
"2":{"class_type":"CLIPTextEncode","inputs":{"text":P,"clip":["1",1]}},
"3":{"class_type":"CLIPTextEncode","inputs":{"text":N,"clip":["1",1]}},
"4":{"class_type":"EmptyLatentImage","inputs":{"width":832,"height":1216,"batch_size":1}},
"5":{"class_type":"KSampler","inputs":{"seed":7,"steps":28,"cfg":6.0,"sampler_name":"euler_ancestral","scheduler":"normal","denoise":1.0,"model":["1",0],"positive":["2",0],"negative":["3",0],"latent_image":["4",0]}},
"6":{"class_type":"VAEDecode","inputs":{"samples":["5",0],"vae":["1",2]}},
"7":{"class_type":"SaveImage","inputs":{"filename_prefix":"pose1","images":["6",0]}}}
json.dump({"prompt":w,"client_id":"p1"},open('/tmp/p1.json','w'));print('written')
PY
r=$(curl -s -X POST http://127.0.0.1:8188/prompt -H 'content-type: application/json' --data @/tmp/p1.json)
echo "q $r"
p=$(printf '%s' "$r" | python3 -c 'import json,sys;print(json.load(sys.stdin).get("prompt_id",""))' 2>/dev/null)
for i in $(seq 1 24); do sleep 5; h=$(curl -s "http://127.0.0.1:8188/history/$p"); [[ $h != "{}" ]] && break; done
f=$(printf '%s' "$h" | grep -o 'pose1_[0-9]*_.png' | head -1)
echo "file $f"
