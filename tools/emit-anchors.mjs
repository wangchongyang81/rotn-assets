import fs from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";
import { V, BASE, VIEW, NEG, A } from "./anchor-spec.mjs";
const ROOT = path.resolve(path.dirname(fileURLToPath(import.meta.url)), "..");
const POSE = {
  t: "arms level and straight out to the sides, legs neutral, palms forward, T-pose",
  p: "arms 20 degrees from the body, palms back, weight on one hip, relaxed A-pose",
};
if (A.length !== 8) { console.log("FAIL anchors", A.length); process.exit(1); }
let n = 0;
for (const a of A) {
  const pose = POSE[a.p.toLowerCase()];
  if (!pose) { console.log("FAIL pose", a.p); process.exit(1); }
  const dir = path.join(ROOT, "master", "anchors", a.id);
  fs.mkdirSync(dir, { recursive: true });
  for (const [view, vd] of Object.entries(VIEW)) {
    const text = [
      `${a.s} adult mid-twenties, ${V[a.v]}.`,
      `${pose}. ${vd}.`,
      `${BASE}.`,
      `negative: ${NEG}`,
    ].join("\n") + "\n";
    fs.writeFileSync(path.join(dir, `${view}.txt`), text);
    n++;
  }
}
console.log("wrote", n, "dirs", fs.readdirSync(path.join(ROOT, "master", "anchors")).length);
