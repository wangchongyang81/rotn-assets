// emits V1/V2 anchor prompts, four views each, per 07
const V = {
  V1: "warm-neutral skin, medium build, heavy work posture",
  V2: "lean, long limb, dry skin, plateau build",
};
const BASE = "neutral grey seamless backdrop, no floor shadow, full body in frame, face hands and feet visible, even soft key light 45 degrees, fill 25 percent, flat even lighting";
const VIEW = {
  front: "front view, facing camera",
  "three-quarter": "three-quarter view, 45 degrees",
  side: "side profile, facing left",
  back: "back view",
};
const NEG = "malformed hands, extra fingers, fused fingers, inconsistent proportions, distorted face, chibi, painterly, western comic, 3d render, floor shadow, watermark, text, props";
const A = [];
for (const v of ["V1", "V2"]) for (const s of ["female", "male"])
  for (const p of ["T", "P"]) A.push({ id: `anchor-${v.toLowerCase()}-${s}-${p.toLowerCase()}`, v, s, p });
export { V, BASE, VIEW, NEG, A };
