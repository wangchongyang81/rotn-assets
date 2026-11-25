import glob, sys, torch
from PIL import Image
from transformers import Qwen2_5_VLForConditionalGeneration, AutoProcessor
M = "/workspace/judge/model"
im = sorted(glob.glob("/workspace/judge/in/*.png"))
if not im: sys.exit("NOIMAGE")
img = Image.open(im[0])
m = Qwen2_5_VLForConditionalGeneration.from_pretrained(M, torch_dtype=torch.bfloat16, device_map="cuda")
p = AutoProcessor.from_pretrained(M)
q = "Is the whole figure including both feet inside the frame? Answer yes or no."
msg = [{"role": "user", "content": [{"type": "image", "image": img}, {"type": "text", "text": q}]}]
t = p.apply_chat_template(msg, tokenize=False, add_generation_prompt=True)
x = p(text=[t], images=[img], return_tensors="pt").to("cuda")
o = m.generate(**x, max_new_tokens=16)
print(p.batch_decode(o[:, x.input_ids.shape[1]:], skip_special_tokens=True)[0].strip())
