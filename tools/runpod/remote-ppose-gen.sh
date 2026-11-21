#!/usr/bin/env bash
set -uo pipefail
# usage: remote-ppose-gen.sh <pose> <seed> <out>
POSE=${1:?pose}; SEED=${2:?seed}; OUT=${3:?out}
D=/workspace/comfy/input
skelname(){ case $1 in tpose) echo skel-tpose.png;; *) echo skel-ppose-$1.png;; esac; }
SK=$D/$(skelname $POSE); PF=$D/prompt-$POSE.txt; NF=$D/neg-$POSE.txt; SF=$D/sha-$POSE.txt
for f in "$SK" "$PF" "$NF" "$SF"; do [ -s "$f" ] || { echo "MISSING $f"; exit 1; }; done
curl -s -o /dev/null -w "http %{http_code}\n" http://127.0.0.1:8188/
python - "$(cat "$PF")" "$(cat "$NF")" "$SK" "$SEED" "$OUT" <<'PY'
import sys,json,urllib.request
P,N,SK,SEED,OUT=sys.argv[1:6]
C="checkpoints/NoobAI-XL-v1.1.safetensors"
w={"1":{"class_type":"CheckpointLoaderSimple","inputs":{"ckpt_name":C}},
"2":{"class_type":"CLIPTextEncode","inputs":{"text":P,"clip":["1",1]}},
"3":{"class_type":"CLIPTextEncode","inputs":{"text":N,"clip":["1",1]}},
"4":{"class_type":"LoadImage","inputs":{"image":SK.split('/')[-1]}},
"5":{"class_type":"EmptyLatentImage","inputs":{"width":832,"height":1216,"batch_size":1}},
"6":{"class_type":"ControlNetLoader","inputs":{"control_net_name":"controlnet/openpose-xinsir-sdxl.safetensors"}},
"7":{"class_type":"ControlNetApplyAdvanced","inputs":{"positive":["2",0],"negative":["3",0],"control_net":["6",0],"image":["4",0],"strength":0.9,"start_percent":0.0,"end_percent":1.0,"vae":["1",2]}},
"8":{"class_type":"KSampler","inputs":{"model":["1",0],"positive":["7",0],"negative":["7",1],"latent_image":["5",0],"seed":int(SEED),"steps":28,"cfg":5.0,"sampler_name":"euler_ancestral","scheduler":"normal","denoise":1.0}},
"9":{"class_type":"VAEDecode","inputs":{"samples":["8",0],"vae":["1",2]}},
"10":{"class_type":"SaveImage","inputs":{"images":["9",0],"filename_prefix":OUT}}}
r=urllib.request.urlopen(urllib.request.Request("http://127.0.0.1:8188/prompt",
 json.dumps({"prompt":w}).encode(),{"Content-Type":"application/json"}))
print(r.read().decode()[:120])
PY
