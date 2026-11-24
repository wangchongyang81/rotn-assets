import json, pathlib
A = pathlib.Path("master/anchors"); T = A / "companions-table.md"
N = {"V1": "pale skin|slender frame", "V2": "warm skin|broad build",
     "V3": "heavy build|warm damp skin", "V4": "dry skin|narrow hip",
     "V5": "slender|pale skin", "V6": "pale clean skin|slim arms",
     "V7": "slender frame|warm tone", "V8": "warm tone|soft curve",
     "V9": "cool shadow|matte skin", "V10": "slouch|narrow shoulder"}
B = {"V1": "warm-neutral skin, medium build, heavy work posture", "V2": "lean, long limb, dry skin",
     "V3": "short limb, deep chest, weathered face, chapped lip", "V4": "softer, heavier, strong calf",
     "V5": "compact, broad, thick forearm", "V6": "sinewy, ash-grey undertone, scarred hand",
     "V7": "blue-grey undertone, cloud banding, broad stance", "V8": "bleached lit side, hard terminator",
     "V9": "sun-bleached, white-gold highlight, narrow eye", "V10": "square-set, thick neck, planted feet"}
D = {l.split("|")[2].strip(): l.split("|")[3].strip()
     for l in T.read_text().split("\n")[2:] if l.count("|") > 10}
d = {}
for l in (A / "companions.tsv").read_text().strip().split("\n"):
    i, v, n, a = l.split("|")
    d[int(i)] = {"variant": v, "name": n, "add": a.split(";"), "neg": N[v].split("|")}
(A / "companions.json").write_text(json.dumps({str(k): d[k] for k in sorted(d)}, indent=1))
def block(k):
    v = d[k]; a = "anchor-" + v["variant"].lower() + "-female"
    return (f"\n### {k} {v['name']} — {v['variant']}\n- anchor: `{a}-t/` rig, `{a}-p/` portrait\n"
            f"- base: {B[v['variant']]}\n- derivation: {D.get(v['name'], '')}\n"
            f"- add: {', '.join(v['add'])}\n- neg: {', '.join(v['neg'])}\n")
b = pathlib.Path("art-bible/02-anime-character.md")
t = b.read_text().split("## Companion descriptors")[0]
b.write_text(t + "## Companion descriptors (realms 1-33)\n\n" + "".join(block(k) for k in sorted(d)))
print("companions", len(d))
