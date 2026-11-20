#!/usr/bin/env bash
set -uo pipefail
python -c 'import torch;print("torch",torch.__version__)'; curl -s -o /dev/null -w "http %{http_code}\n" http://127.0.0.1:8188/
cd /workspace/comfy/output; ls -l skel-tpose.png
python - <<'PY'
from PIL import Image; import json
C="checkpoints/NoobAI-XL-v1.1.safetensors"
P="(standing:1.3), masterpiece, best quality, absurdres, solo, 1girl, anime style, flat colour, flat shading, cel shading, nude, completely nude, breasts, nipples, navel, vagina, labia, bare feet"
P+=", detailed face, detailed eyes, (left arm straight out horizontal:1.9), arm fully extended, five fingers, legs apart, feet visible, straight-on front view, head level"
P+=", head to body ratio 1 to 7, (white background:1.4), (simple background:1.2), even flat light, studio white, (medium brown skin:1.3), long black hair, red bindi"
N="mannequin, 3d render, faceless, four arms, extra arms, malformed hands, extra fingers, distorted face, chibi, painterly, western comic, (ground shadow:1.5), watermark, clothing, a-pose, cropped feet, out of frame"
N+=", (halo:1.4), gradient shading, heavy shading, purple shadow, small head, long torso, profile view, oversized breasts, kitten, cat, (blue background:1.3), (blue tint:1.3), vignette"
N+=", arm angled down, sloping arm, drooping arm, diagonal arm, bent straight arm, both arms out, t-pose, pale skin, white skin, blonde hair"
N+=", south asian, indian, braid, earrings, leaf in hair, burnt orange skin, short stature"
w={"1":{"class_type":"CheckpointLoaderSimple","inputs":{"ckpt_name":C}},"2":{"class_type":"CLIPTextEncode","inputs":{"text":P,"clip":["1",1]}},"3":{"class_type":"CLIPTextEncode","inputs":{"text":N,"clip":["1",1]}},"4":{"class_type":"LoadImage","inputs":{"image":"skel-tpose.png"}}}
w["6"]={"class_type":"ControlNetLoader","inputs":{"control_net_name":"controlnet/openpose-xinsir-sdxl.safetensors"}};w["7"]={"class_type":"ControlNetApplyAdvanced","inputs":{"positive":["2",0],"negative":["3",0],"control_net":["6",0],"image":["4",0],"strength":0.97,"start_percent":0.0,"end_percent":1.0,"vae":["1",2]}}
w["8"]={"class_type":"EmptyLatentImage","inputs":{"width":832,"height":1216,"batch_size":1}};w["9"]={"class_type":"KSampler","inputs":{"seed":7,"steps":28,"cfg":6.0,"sampler_name":"euler_ancestral","scheduler":"normal","denoise":1.0,"model":["1",0],"positive":["7",0],"negative":["7",1],"latent_image":["8",0]}}
w["10"]={"class_type":"VAEDecode","inputs":{"samples":["9",0],"vae":["1",2]}};w["11"]={"class_type":"SaveImage","inputs":{"filename_prefix":"anchor-r1t8","images":["10",0]}}
json.dump({"prompt":w,"client_id":"r1t8"},open('/tmp/r1t8.json','w'));print('written')
PY
r=$(curl -s -X POST http://127.0.0.1:8188/prompt -H 'content-type: application/json' --data @/tmp/r1t8.json)
p=$(printf '%s' "$r" | python3 -c 'import json,sys;print(json.load(sys.stdin).get("prompt_id",""))' 2>/dev/null)
for i in $(seq 1 30); do sleep 5; h=$(curl -s "http://127.0.0.1:8188/history/$p"); [[ $h != "{}" ]] && break; done
echo "anchor $(printf '%s' "$h" | grep -o 'anchor-r1t8_[0-9]*_.png' | head -1)"
