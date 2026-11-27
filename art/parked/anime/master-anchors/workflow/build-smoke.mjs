import fs from "node:fs";
const P = "/workspaces/rotn-assets/master/anchors/anchor-v1-female-t/front.txt";
const L = fs.readFileSync(P, "utf8").trim().split("\n");
const neg = L[L.length - 1].replace(/^negative:\s*/, "");
const pos = L.slice(0, L.length - 1).join(" ");
const wf = {
  "1": { class_type: "CheckpointLoaderSimple", inputs: { ckpt_name: "NoobAI-XL-v1.1.safetensors" } },
  "2": { class_type: "CLIPTextEncode", inputs: { text: pos, clip: ["1", 1] } },
  "3": { class_type: "CLIPTextEncode", inputs: { text: neg, clip: ["1", 1] } },
  "4": { class_type: "LoadImage", inputs: { image: "tpose-832x1216.png" } },
  "5": { class_type: "ControlNetLoader", inputs: { control_net_name: "openpose-xinsir-sdxl.safetensors" } },
  "6": { class_type: "ControlNetApplyAdvanced", inputs: { positive: ["2",0], negative: ["3",0], control_net: ["5",0], image: ["4",0], strength: 0.85, start_percent: 0.0, end_percent: 1.0 } },
  "7": { class_type: "EmptyLatentImage", inputs: { width: 832, height: 1216, batch_size: 1 } },
  "8": { class_type: "KSampler", inputs: { model: ["1",0], seed: 730000, steps: 24, cfg: 6, sampler_name: "euler_ancestral", scheduler: "karras", positive: ["6",0], negative: ["6",1], latent_image: ["7",0], denoise: 1.0 } },
  "9": { class_type: "VAEDecode", inputs: { samples: ["8",0], vae: ["1",2] } },
  "10": { class_type: "SaveImage", inputs: { images: ["9",0], filename_prefix: "smoke-v1-f-t-front" } },
};
fs.writeFileSync("/tmp/wf.json", JSON.stringify({ prompt: wf, client_id: "smoke1" }));
console.log("nodes", Object.keys(wf).length, "pos", pos.length, "neg", neg.length);
