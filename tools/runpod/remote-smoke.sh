#!/usr/bin/env bash
set -uo pipefail
python - <<'PY'
import json
C="checkpoints/NoobAI-XL-v1.1.safetensors"
w={"1":{"class_type":"CheckpointLoaderSimple","inputs":{"ckpt_name":C}},
"2":{"class_type":"CLIPTextEncode","inputs":{"text":"1girl, solo, standing, full body, white background","clip":["1",1]}},
"3":{"class_type":"CLIPTextEncode","inputs":{"text":"lowres, blurry, bad anatomy","clip":["1",1]}},
"4":{"class_type":"EmptyLatentImage","inputs":{"width":832,"height":1216,"batch_size":1}},
"5":{"class_type":"KSampler","inputs":{"seed":42,"steps":24,"cfg":6.0,"sampler_name":"euler_ancestral","scheduler":"normal","denoise":1.0,"model":["1",0],"positive":["2",0],"negative":["3",0],"latent_image":["4",0]}},
"6":{"class_type":"VAEDecode","inputs":{"samples":["5",0],"vae":["1",2]}},
"7":{"class_type":"SaveImage","inputs":{"filename_prefix":"smoke","images":["6",0]}}}
json.dump({"prompt":w,"client_id":"smoke1"},open('/tmp/wf.json','w')); print('workflow written')
PY
r=$(curl -s -X POST http://127.0.0.1:8188/prompt -H 'content-type: application/json' --data @/tmp/wf.json)
echo "queue $r"
pid=$(printf '%s' "$r" | python3 -c 'import json,sys;print(json.load(sys.stdin).get("prompt_id",""))' 2>/dev/null)
for i in $(seq 1 24); do
  sleep 5
  h=$(curl -s "http://127.0.0.1:8188/history/$pid")
  [[ $h != "{}" ]] && { echo "done $i"; break; }
  echo "wait $i"
done
ls -l /workspace/comfy/output | tail -3
