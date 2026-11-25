#!/usr/bin/env python3
import json,pathlib
A=pathlib.Path("/workspaces/rotn-assets")
C=json.loads((A/"master/anchors/companions.json").read_text())
rows=[l.split("|") for l in (A/"ref/SLUGS.md").read_text().split("\n") if l.startswith("| ") and "ref/" in l]
HDR="(t-pose:1.5), masterpiece, best quality, very aesthetic, absurdres, solo, 1girl, anime style, anime coloring, cel shading, hardcore, nude, completely nude, uncensored"
FACE="detailed face, detailed eyes, eyelashes, face unobstructed"
POSE="arms straight out horizontal level with shoulders, straight elbows, hands open at arm ends, five fingers"
STAND="standing straight, legs together parallel, feet visible, straight-on front view, head level"
BG="(neutral grey seamless backdrop:1.6), no floor shadow, even soft key light at 45 degrees, 25 percent fill"
NEG=open(A/"master/anchors/anchor-v1-female-t/front.txt").read().split("negative:")[1].strip().replace("dark grey background, ","")
out=A/"art/prompts/anchors"; out.mkdir(parents=True,exist_ok=True)
idx={}
for r in rows:
    slug=r[1].strip(); ch=r[4].strip()
    if ch not in C: print("SKIP",slug,ch); continue
    e=C[ch]; add=", ".join(e["add"])
    pos=f"{HDR}\n{FACE}\n{POSE}\n{STAND}\n{add}\n{BG}"
    (out/f"{slug}-t.txt").write_text("positive:\n"+pos+"\nnegative:\n"+NEG+", "+", ".join(e["neg"])+"\n")
    idx[slug]={"char":ch,"variant":e["variant"],"name":e["name"]}
(out/"_index.json").write_text(json.dumps(idx,indent=1))
print("slugs",len(idx)); print((out/"dhara-t.txt").read_text())
