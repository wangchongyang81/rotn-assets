#!/usr/bin/env bash
set -euo pipefail
NS=${HF_NS:?}; C=/workspace/ComfyUI; O=/workspace/out
mkdir -p "$O" "$C/models/checkpoints"
python -m pip install -q huggingface_hub
if [ ! -d "$C/.git" ]; then
  git clone -q https://github.com/comfyanonymous/ComfyUI "$C"
  python -m pip install -q -r "$C/requirements.txt"
fi
[ -s "$C/models/checkpoints/noobaiXL.safetensors" ] || {
  hf download Laxhar/noobai-XL-1.1 NoobAI-XL-v1.1.safetensors --local-dir "$C/models/checkpoints" >/dev/null
  ln -sf NoobAI-XL-v1.1.safetensors "$C/models/checkpoints/noobaiXL.safetensors"; }
cd "$C"
nohup python main.py --listen 127.0.0.1 --port 8188 --fp16-unet > /workspace/comfy.log 2>&1 &
for i in $(seq 60); do curl -sf http://127.0.0.1:8188/system_stats >/dev/null && break; sleep 3; done
W='{"3":{"class_type":"KSampler","inputs":{"seed":7741,"steps":28,"cfg":6.5,"sampler_name":"euler_ancestral","scheduler":"karras","denoise":1,"model":["4",0],"positive":["6",0],"negative":["7",0],"latent_image":["5",0]}},"4":{"class_type":"CheckpointLoaderSimple","inputs":{"ckpt_name":"noobaiXL.safetensors"}},"5":{"class_type":"EmptyLatentImage","inputs":{"width":832,"height":1216,"batch_size":1}},"6":{"class_type":"CLIPTextEncode","inputs":{"text":"__P__","clip":["4",1]}},"7":{"class_type":"CLIPTextEncode","inputs":{"text":"lowres, extra finger, fused finger, watermark, text","clip":["4",1]}},"8":{"class_type":"VAEDecode","inputs":{"samples":["3",0],"vae":["4",2]}},"9":{"class_type":"SaveImage","inputs":{"images":["8",0],"filename_prefix":"anchor"}}}'
W=${W/__P__/female adult mid-twenties, short limb, deep chest, weathered face, chapped lip, (medium breasts:1.1), (small nipples:1.2), (tiny areola:1.4), nude, full body, T-pose, arms level, palms forward, neutral grey backdrop, crisp coloured lineart, head to body ratio 1 to 7}
PID=$(curl -sf -X POST http://127.0.0.1:8188/prompt -H 'Content-Type: application/json' -d "{\"prompt\": $W}" | sed -n 's/.*"prompt_id": *"$$[^"]*$$".*/\1/p')
for i in $(seq 90); do sleep 2; H=$(curl -sf "http://127.0.0.1:8188/history/$PID"); echo "$H" | grep -q '"images"' && break; done
F=$(echo "$H" | sed -n 's/.*"filename": *"$$[^"]*$$".*/\1/p' | head -1)
cp "$C/output/$F" "$O/v3-t-smoke.png"
hf upload "$NS/rotn-render-env" "$O/v3-t-smoke.png" smoke/v3-t.png >/dev/null
echo uploaded
