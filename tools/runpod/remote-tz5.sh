#!/usr/bin/env bash
set -uo pipefail
python - <<'PY'
import json
C="checkpoints/NoobAI-XL-v1.1.safetensors"
P="(t-pose:1.5), masterpiece, best quality, very aesthetic, absurdres, solo, 1girl, anime style, anime coloring, cel shading, nude, completely nude, breasts, nipples, navel, vagina, labia, bare legs, bare feet"
P="$P, detailed face, detailed eyes, eyelashes, short hair, arms straight out horizontal level with shoulders, straight elbows, hands open at arm ends, five fingers, face unobstructed"
P="$P, standing straight, legs together parallel, feet visible, straight-on front view, head level"
P="$P, female adult mid-twenties, warm-neutral skin, medium build, moderate natural bust, head to body ratio 1 to 7"
P="$P, simple background, white background, even flat light"
N="mannequin, 3d render, 3d model, base mesh, faceless, no face, featureless, bald, four arms, extra arms, malformed hands, extra fingers, fused fingers, distorted face, chibi, painterly, western comic, (ground shadow:1.5), watermark, text, props, helmet, armor, clothing, arms down, a-pose, arms angled down, crossed ankles, cropped feet, out of frame, hands in front of face, (halo:1.4), cross above head, gradient shading, small head, long torso, profile view, side view, oversized breasts, blue tint, black background, kitten, cat"
w={"1":{"class_type":"CheckpointLoaderSimple","inputs":{"ckpt_name":C}},
"2":{"class_type":"CLIPTextEncode","inputs":{"text":P,"clip":["1",1]}},
"3":{"class_type":"CLIPTextEncode","inputs":{"text":N,"clip":["1",1]}},
"4":{"class_type":"LoadImage","inputs":{"image":"skel-tpose.png"}},
"6":{"class_type":"ControlNetLoader","inputs":{"control_net_name":"controlnet/openpose-xinsir-sdxl.safetensors"}},
"7":{"class_type":"ControlNetApplyAdvanced","inputs":{"positive":["2",0],"negative":["3",0],"control_net":["6",0],"image":["4",0],"strength":0.9,"start_percent":0.0,"end_percent":1.0,"vae":["1",2]}},
"8":{"class_type":"EmptyLatentImage","inputs":{"width":832,"height":1216,"batch_size":1}},
"9":{"class_type":"KSampler","inputs":{"seed":7,"steps":28,"cfg":6.0,"sampler_name":"euler_ancestral","scheduler":"normal","denoise":1.0,"model":["1",0],"positive":["7",0],"negative":["7",1],"latent_image":["8",0]}},
"10":{"class_type":"VAEDecode","inputs":{"samples":["9",0],"vae":["1",2]}},
"11":{"class_type":"SaveImage","inputs":{"filename_prefix":"anchor-tw3","images":["10",0]}}}
json.dump({"prompt":w,"client_id":"tw3"},open('/tmp/tw3.json','w'));print('written')
PY
r=$(curl -s -X POST http://127.0.0.1:8188/prompt -H 'content-type: application/json' --data @/tmp/tw3.json)
p=$(printf '%s' "$r" | python3 -c 'import json,sys;print(json.load(sys.stdin).get("prompt_id",""))' 2>/dev/null)
for i in $(seq 1 30); do sleep 5; h=$(curl -s "http://127.0.0.1:8188/history/$p"); [[ $h != "{}" ]] && break; done
echo "anchor $(printf '%s' "$h" | grep -o 'anchor-tw3_[0-9]*_.png' | head -1)"
