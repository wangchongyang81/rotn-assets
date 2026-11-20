#!/usr/bin/env bash
set -uo pipefail
python -c 'import torch;print("torch",torch.__version__)'; curl -s -o /dev/null -w "http %{http_code}\n" http://127.0.0.1:8188/
python - <<'PY'
from PIL import Image, ImageDraw; W,H=832,1216; im=Image.new('RGB',(W,H),(0,0,0)); d=ImageDraw.Draw(im)
L=[((416,266),(416,300)),((416,300),(416,650)),((341,650),(491,650))]
L+=[((416,300),(311,300)),((311,300),(206,300)),((206,300),(101,300)),((101,300),(41,300))]
L+=[((416,300),(521,300)),((521,300),(611,380)),((611,380),(430,648))]
L+=[((341,650),(301,885)),((301,885),(261,1110)),((261,1110),(226,1142))]
L+=[((491,650),(531,885)),((531,885),(571,1110)),((571,1110),(606,1142))]
for a,b in L: d.line([a,b],fill=(255,255,255),width=18)
d.line([(416,300),(416,650)],fill=(255,255,255),width=24); d.ellipse([339,120,493,266],outline=(255,255,255),width=18)
im.save('/workspace/comfy/output/skel-ppose6.png'); print('saved')
px=im.convert('L').load(); [print('row',y,[x for x in range(0,W,2) if px[x,y]>20][:1]+[x for x in range(0,W,2) if px[x,y]>20][-1:]) for y in (270,300,330)]
import json
C="checkpoints/NoobAI-XL-v1.1.safetensors"
P="(standing:1.3), masterpiece, best quality, absurdres, solo, 1girl, anime style, flat colour, flat shading, cel shading, nude, completely nude, breasts, nipples, navel, vagina, labia, bare feet"
P+=", detailed face, detailed eyes, (left arm straight out horizontal:1.5), arm fully extended, five fingers, (right hand on hip:1.3), right arm bent at elbow, legs apart, feet visible, straight-on front view, head level"
P+=", female adult mid-twenties, medium build, head to body ratio 1 to 7, (white background:1.4), (simple background:1.2), even flat light, studio white"
N="mannequin, 3d render, faceless, four arms, extra arms, malformed hands, extra fingers, distorted face, chibi, painterly, western comic, (ground shadow:1.5), watermark, clothing, a-pose, cropped feet, out of frame"
N+=", (halo:1.4), gradient shading, heavy shading, purple shadow, small head, long torso, profile view, oversized breasts, kitten, cat, (blue background:1.3), (blue tint:1.3), vignette"
N+=", arm angled down, sloping arm, drooping arm, diagonal arm, bent straight arm, both arms out, t-pose"
w={"1":{"class_type":"CheckpointLoaderSimple","inputs":{"ckpt_name":C}},"2":{"class_type":"CLIPTextEncode","inputs":{"text":P,"clip":["1",1]}},"3":{"class_type":"CLIPTextEncode","inputs":{"text":N,"clip":["1",1]}},"4":{"class_type":"LoadImage","inputs":{"image":"skel-ppose6.png"}}}
w["6"]={"class_type":"ControlNetLoader","inputs":{"control_net_name":"controlnet/openpose-xinsir-sdxl.safetensors"}};w["7"]={"class_type":"ControlNetApplyAdvanced","inputs":{"positive":["2",0],"negative":["3",0],"control_net":["6",0],"image":["4",0],"strength":0.9,"start_percent":0.0,"end_percent":1.0,"vae":["1",2]}}
w["8"]={"class_type":"EmptyLatentImage","inputs":{"width":832,"height":1216,"batch_size":1}};w["9"]={"class_type":"KSampler","inputs":{"seed":7,"steps":28,"cfg":6.0,"sampler_name":"euler_ancestral","scheduler":"normal","denoise":1.0,"model":["1",0],"positive":["7",0],"negative":["7",1],"latent_image":["8",0]}}
w["10"]={"class_type":"VAEDecode","inputs":{"samples":["9",0],"vae":["1",2]}};w["11"]={"class_type":"SaveImage","inputs":{"filename_prefix":"anchor-qa2","images":["10",0]}}
json.dump({"prompt":w,"client_id":"qa2"},open('/tmp/qa2.json','w'));print('written')
PY
r=$(curl -s -X POST http://127.0.0.1:8188/prompt -H 'content-type: application/json' --data @/tmp/qa2.json)
p=$(printf '%s' "$r" | python3 -c 'import json,sys;print(json.load(sys.stdin).get("prompt_id",""))' 2>/dev/null)
for i in $(seq 1 30); do sleep 5; h=$(curl -s "http://127.0.0.1:8188/history/$p"); [[ $h != "{}" ]] && break; done
echo "anchor $(printf '%s' "$h" | grep -o 'anchor-qa2_[0-9]*_.png' | head -1)"
