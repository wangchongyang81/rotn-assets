#!/usr/bin/env bash
set -uo pipefail
python - <<'PY'
from PIL import Image, ImageDraw
W,H=832,1216
im=Image.new('RGB',(W,H),(0,0,0)); d=ImageDraw.Draw(im)
L=[((416,266),(416,310)),((416,316),(416,650)),((341,650),(491,650))]
L+=[((416,316),(311,316)),((311,316),(206,316)),((206,316),(101,316)),((101,316),(41,316))]
L+=[((416,300),(521,300)),((521,300),(611,380)),((611,380),(430,648))]
L+=[((341,650),(321,885)),((321,885),(301,1110)),((301,1110),(266,1142))]
L+=[((491,650),(511,885)),((511,885),(531,1110)),((531,1110),(566,1142))]
for a,b in L: d.line([a,b],fill=(255,255,255),width=18)
d.line([(416,316),(416,650)],fill=(255,255,255),width=24); d.ellipse([339,120,493,266],outline=(255,255,255),width=18)
d.ellipse([20,300,52,332],outline=(255,255,255),width=16)
im.save('/workspace/comfy/output/skel-ppose2.png'); print('saved')
px=im.convert('L').load(); r=[y for y in range(H) if any(px[x,y]>20 for x in range(0,W,2))]; print('top',r[0],'bot',r[-1],'h',r[-1]-r[0])
import json
C="checkpoints/NoobAI-XL-v1.1.safetensors"
P="(standing:1.3), masterpiece, best quality, very aesthetic, absurdres, solo, 1girl, anime style, cel shading, nude, completely nude, breasts, nipples, navel, vagina, labia, bare feet"
P+=", detailed face, detailed eyes, one hand on hip, (left arm straight out horizontal:1.4), arm fully extended, hand at arm end, five fingers, legs apart, feet visible, straight-on front view, head level"
P+=", female adult mid-twenties, medium build, head to body ratio 1 to 7, (white background:1.4), (simple background:1.2), even flat light, studio white"
N="mannequin, 3d render, faceless, four arms, extra arms, malformed hands, extra fingers, distorted face, chibi, painterly, western comic, (ground shadow:1.5), watermark, clothing, arms down, a-pose, cropped feet, out of frame"
N+=", (halo:1.4), gradient shading, small head, long torso, profile view, oversized breasts, kitten, cat, (blue background:1.3), cyan background, (blue tint:1.3), teal background, vignette, short arm, elbow bent, arm half extended"
w={"1":{"class_type":"CheckpointLoaderSimple","inputs":{"ckpt_name":C}},"2":{"class_type":"CLIPTextEncode","inputs":{"text":P,"clip":["1",1]}},"3":{"class_type":"CLIPTextEncode","inputs":{"text":N,"clip":["1",1]}},"4":{"class_type":"LoadImage","inputs":{"image":"skel-ppose2.png"}}}
w["6"]={"class_type":"ControlNetLoader","inputs":{"control_net_name":"controlnet/openpose-xinsir-sdxl.safetensors"}};w["7"]={"class_type":"ControlNetApplyAdvanced","inputs":{"positive":["2",0],"negative":["3",0],"control_net":["6",0],"image":["4",0],"strength":0.95,"start_percent":0.0,"end_percent":1.0,"vae":["1",2]}}
w["8"]={"class_type":"EmptyLatentImage","inputs":{"width":832,"height":1216,"batch_size":1}};w["9"]={"class_type":"KSampler","inputs":{"seed":7,"steps":28,"cfg":6.0,"sampler_name":"euler_ancestral","scheduler":"normal","denoise":1.0,"model":["1",0],"positive":["7",0],"negative":["7",1],"latent_image":["8",0]}}
w["10"]={"class_type":"VAEDecode","inputs":{"samples":["9",0],"vae":["1",2]}};w["11"]={"class_type":"SaveImage","inputs":{"filename_prefix":"anchor-pw","images":["10",0]}}
json.dump({"prompt":w,"client_id":"pw"},open('/tmp/pw.json','w'));print('written')
PY
r=$(curl -s -X POST http://127.0.0.1:8188/prompt -H 'content-type: application/json' --data @/tmp/pw.json)
p=$(printf '%s' "$r" | python3 -c 'import json,sys;print(json.load(sys.stdin).get("prompt_id",""))' 2>/dev/null)
for i in $(seq 1 30); do sleep 5; h=$(curl -s "http://127.0.0.1:8188/history/$p"); [[ $h != "{}" ]] && break; done
echo "anchor $(printf '%s' "$h" | grep -o 'anchor-pw_[0-9]*_.png' | head -1)"
