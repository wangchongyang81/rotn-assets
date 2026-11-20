#!/usr/bin/env bash
set -uo pipefail
python - <<'PY'
from PIL import Image, ImageDraw
W,H=832,1216
im=Image.new('RGB',(W,H),(0,0,0)); d=ImageDraw.Draw(im)
L=[((416,266),(416,300)),((311,300),(521,300)),((311,300),(206,300)),((206,300),(101,300)),((101,300),(61,300)),((521,300),(626,300)),((626,300),(731,300)),((731,300),(771,300))]
L+=[((416,300),(416,650)),((341,650),(491,650)),((341,650),(361,885)),((361,885),(381,1110)),((381,1110),(350,1140)),((491,650),(471,885)),((471,885),(451,1110)),((451,1110),(482,1140))]
for a,b in L: d.line([a,b],fill=(255,255,255),width=18)
d.line([(416,300),(416,650)],fill=(255,255,255),width=24)
d.ellipse([339,120,493,266],outline=(255,255,255),width=18)
im.save('/workspace/comfy/output/skel-tpose.png'); print('drawn',im.size)
g=im.convert('L'); px=g.load()
r=[y for y in range(H) if any(px[x,y]>20 for x in range(0,W,2))]
print('top',r[0],'bot',r[-1],'h',r[-1]-r[0])
import json
C="checkpoints/NoobAI-XL-v1.1.safetensors"
P="(t-pose:1.5), masterpiece, best quality, very aesthetic, absurdres, solo, 1girl, anime style, cel shading, nude, completely nude, breasts, nipples, navel, vagina, labia, bare feet"
P+=", detailed face, detailed eyes, arms straight out horizontal, straight elbows, hands open, five fingers, standing straight, legs straight, feet visible, straight-on front view, head level"
P+=", female adult mid-twenties, medium build, head to body ratio 1 to 7, simple background, white background, even flat light"
N="mannequin, 3d render, faceless, four arms, extra arms, malformed hands, extra fingers, distorted face, chibi, painterly, western comic, (ground shadow:1.5), watermark, clothing, arms down, a-pose, arms angled down, cropped feet, out of frame, (halo:1.4), gradient shading, small head, long torso, profile view, oversized breasts, blue tint, black background, kitten, cat"
w={"1":{"class_type":"CheckpointLoaderSimple","inputs":{"ckpt_name":C}},"2":{"class_type":"CLIPTextEncode","inputs":{"text":P,"clip":["1",1]}},"3":{"class_type":"CLIPTextEncode","inputs":{"text":N,"clip":["1",1]}},"4":{"class_type":"LoadImage","inputs":{"image":"skel-tpose.png"}}}
w["6"]={"class_type":"ControlNetLoader","inputs":{"control_net_name":"controlnet/openpose-xinsir-sdxl.safetensors"}};w["7"]={"class_type":"ControlNetApplyAdvanced","inputs":{"positive":["2",0],"negative":["3",0],"control_net":["6",0],"image":["4",0],"strength":0.9,"start_percent":0.0,"end_percent":1.0,"vae":["1",2]}}
w["8"]={"class_type":"EmptyLatentImage","inputs":{"width":832,"height":1216,"batch_size":1}};w["9"]={"class_type":"KSampler","inputs":{"seed":7,"steps":28,"cfg":6.0,"sampler_name":"euler_ancestral","scheduler":"normal","denoise":1.0,"model":["1",0],"positive":["7",0],"negative":["7",1],"latent_image":["8",0]}};w["10"]={"class_type":"VAEDecode","inputs":{"samples":["9",0],"vae":["1",2]}};w["11"]={"class_type":"SaveImage","inputs":{"filename_prefix":"anchor-tv","images":["10",0]}}
json.dump({"prompt":w,"client_id":"tv"},open('/tmp/tv.json','w'));print('written')
PY
r=$(curl -s -X POST http://127.0.0.1:8188/prompt -H 'content-type: application/json' --data @/tmp/tv.json)
p=$(printf '%s' "$r" | python3 -c 'import json,sys;print(json.load(sys.stdin).get("prompt_id",""))' 2>/dev/null)
for i in $(seq 1 30); do sleep 5; h=$(curl -s "http://127.0.0.1:8188/history/$p"); [[ $h != "{}" ]] && break; done
echo "anchor $(printf '%s' "$h" | grep -o 'anchor-tv_[0-9]*_.png' | head -1)"
