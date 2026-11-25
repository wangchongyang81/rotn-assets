import glob, json, torch
from PIL import Image
from transformers import Qwen2_5_VLForConditionalGeneration, AutoProcessor
J = "/workspace/judge"
man = json.load(open(f"{J}/manifest.json"))
m = Qwen2_5_VLForConditionalGeneration.from_pretrained(f"{J}/model", torch_dtype=torch.bfloat16, device_map="cuda")
p = AutoProcessor.from_pretrained(f"{J}/model")
out = open(man["out"], "a")
for pose in man["poses"]:
    hit = sorted(glob.glob(f"{J}/in/*{pose}*.png"))
    if not hit: print("noimage", pose); continue
    img = Image.open(hit[0])
    for c in man["criteria"]:
        q = f"Look at the figure. Criterion: {c}. Pass or fail? One word."
        msg = [{"role": "user", "content": [{"type": "image", "image": img}, {"type": "text", "text": q}]}]
        t = p.apply_chat_template(msg, tokenize=False, add_generation_prompt=True)
        x = p(text=[t], images=[img], return_tensors="pt").to("cuda")
        o = m.generate(**x, max_new_tokens=4)
        a = p.batch_decode(o[:, x.input_ids.shape[1]:], skip_special_tokens=True)[0].strip().lower()
        out.write(json.dumps({"pose": pose, "criterion": c, "verdict": "pass" if a.startswith("pass") else "fail", "raw": a}) + "\n")
    print("scored", pose)
out.close(); print("done", man["out"])
