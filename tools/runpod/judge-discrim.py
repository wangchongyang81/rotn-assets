import glob, sys, torch
from PIL import Image
from transformers import Qwen2_5_VLForConditionalGeneration, AutoProcessor
M = "/workspace/judge/model"
im = sorted(glob.glob("/workspace/judge/in/*.png"))
if not im: sys.exit("NOIMAGE")
good = Image.open(im[0]); w, h = good.size
bad = good.crop((0, 0, w, h - 260))
m = Qwen2_5_VLForConditionalGeneration.from_pretrained(M, torch_dtype=torch.bfloat16, device_map="cuda")
p = AutoProcessor.from_pretrained(M)
q = "Are both feet inside the frame? Answer yes or no."
def ask(img):
    msg = [{"role": "user", "content": [{"type": "image", "image": img}, {"type": "text", "text": q}]}]
    t = p.apply_chat_template(msg, tokenize=False, add_generation_prompt=True)
    x = p(text=[t], images=[img], return_tensors="pt").to("cuda")
    o = m.generate(**x, max_new_tokens=4)
    return p.batch_decode(o[:, x.input_ids.shape[1]:], skip_special_tokens=True)[0].strip().lower()
g, b = ask(good), ask(bad)
print("good", g, "| cropped", b)
ok = g.startswith("yes") and b.startswith("no")
print("DISCRIM", "PASS" if ok else "FAIL")
sys.exit(0 if ok else 1)
