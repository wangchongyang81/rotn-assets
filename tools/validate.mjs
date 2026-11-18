import fs from "node:fs";
process.chdir("/workspaces/rotn-assets");
const { rows } = JSON.parse(fs.readFileSync("registry.json", "utf8"));
const CLASS = new Set(["cg", "npc", "bust", "player", "mob", "boss", "expr", "env", "prop", "ui", "fx"]);
const VAR = /^(holy|dark|nude|expr-[a-z0-9]+|size-\d+|layer-(fg|mg|bg))$/;
const SIZE = {
  cg: [3840, 1280, 1920, 2560], npc: [2048, 512, 1024], bust: [2048, 512, 1024],
  player: [2048, 512, 1024], mob: [1024, 512], boss: [1536, 512, 768],
  expr: [1024, 512], env: [2048, 1024], prop: [1024, 512], ui: [2048, 1024],
  fx: [1024, 512],
};
const errs = [];
const seen = new Set();
for (const r of rows) {
  const p = `row ${r.id}`;
  const t = SIZE[r.class];
  if (!CLASS.has(r.class)) { errs.push(`${p}: class ${r.class}`); continue; }
  if (r.variant && !VAR.test(r.variant)) errs.push(`${p}: variant ${r.variant}`);
  if (!["avif", "webp"].includes(r.ext)) errs.push(`${p}: ext ${r.ext}`);
  const k = `${r.id}@${r.w}`;
  if (seen.has(k)) errs.push(`${p}: duplicate at ${r.w}`);
  seen.add(k);
  if (!t.includes(r.w)) errs.push(`${p}: width ${r.w} off ladder`);
  if (r.master && r.w !== t[0]) errs.push(`${p}: master at ${r.w}, want ${t[0]}`);
  if (!r.master && r.w === t[0]) errs.push(`${p}: delivery at master size`);
}
console.log(`${rows.length} rows, ${errs.length} errors`);
console.log(errs.slice(0, 12).join("\n"));
