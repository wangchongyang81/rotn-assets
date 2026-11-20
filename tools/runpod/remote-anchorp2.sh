#!/usr/bin/env bash
set -uo pipefail
python - <<'PY'
import json
C="checkpoints/NoobAI-XL-v1.1.safetensors"
P="1girl, solo, standing, one hand on hip, legs slightly apart, full body, head to toe, white background"
N="lowres, blurry, bad anatomy, extra limbs"
w={"1":{"class_type":"CheckpointLoaderSimple","inputs":{"ckpt_name":C}},
"2":{"class_type":"CLIPTextEncode","inputs":{"text":P,"clip":["1",1]}},
"3":{"class_type":"CLIPTextEncode","inputs":{"text":N,"clip":["1",1]}},
"4":{"class_type":"LoadImage","inputs":{"image":"pose2b_00001_.png"}},
"6":{"class_type":"ControlNetLoader","inputs":{"control_net_name":"controlnet/openpose-xinsir-sdxl.safetensors"}},
"5":{"class_type":"OpenposePreprocessor","inputs":{"image":["4",0],"detect_hand":"enable","detect_body":"enable","detect_face":"enable","resolution":1024,"scale_stick_for_xinsr_cn":"enable"}},
"7":{"class_type":"ControlNetApplyAdvanced","inputs":{"positive":["2",0],"negative":["3",0],"control_net":["6",0],"image":["5",0],"strength":0.9,"start_percent":0.0,"end_percent":1.0,"vae":["1",2]}},
"8":{"class_type":"EmptyLatentImage","inputs":{"width":832,"height":1216,"batch_size":1}},
"9":{"class_type":"KSampler","inputs":{"seed":7,"steps":28,"cfg":6.0,"sampler_name":"euler_ancestral","scheduler":"normal","denoise":1.0,"model":["1",0],"positive":["7",0],"negative":["7",1],"latent_image":["8",0]}},
"10":{"class_type":"VAEDecode","inputs":{"samples":["9",0],"vae":["1",2]}},
"11":{"class_type":"SaveImage","inputs":{"filename_prefix":"anchor-p2","images":["10",0]}},"12":{"class_type":"SaveImage","inputs":{"filename_prefix":"skel-p2","images":["5",0]}}}
json.dump({"prompt":w,"client_id":"ap2"},open('/tmp/ap2.json','w'));print('written')
PY
r=$(curl -s -X POST http://127.0.0.1:8188/prompt -H 'content-type: application/json' --data @/tmp/ap2.json)
p=$(printf '%s' "$r" | python3 -c 'import json,sys;print(json.load(sys.stdin).get("prompt_id",""))' 2>/dev/null)
for i in $(seq 1 30); do sleep 5; h=$(curl -s "http://127.0.0.1:8188/history/$p"); [[ $h != "{}" ]] && break; done
echo "anchor $(printf '%s' "$h" | grep -o 'anchor-p2_[0-9]*_.png' | head -1)"
