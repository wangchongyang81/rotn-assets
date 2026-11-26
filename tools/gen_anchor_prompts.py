import json,pathlib
A=pathlib.Path("/workspaces/rotn-assets")
C=json.loads((A/"master/anchors/companions.json").read_text())
N=json.loads((A/"ref/NAMES.json").read_text())
B="masterpiece, best quality, absurdres, anime style, flat colour, flat shading, cel shading, 1girl, solo, single figure, female adult mid-twenties, medium build, head to body ratio 1 to 7"
P="arms straight out horizontal level with shoulders, straight elbows, palms forward, hands open, five fingers, (thigh gap:1.1)"
T="front view, full body, standing, feet in frame, full figure, wide shot, completely nude, uncensored, hardcore, breasts, nipples, navel, vagina, labia"
E="sharp focus, crisp lineart, clean silhouette, (solid white background:1.6)"
G="worst quality, bad quality, low quality, lowres, bad anatomy, bad hands, extra digits, fewer digits, signature, watermark, text, multiple views, reference sheet, scenery, props, background clutter, gradient background, visible light rays, light cone, green tint, olive background, bokeh, blurry, soft focus, halo, vignette, heavy shading, purple shadow, (ground shadow:1.5), soft airbrush, 2girls, multiple girls, twin, mannequin, 3d render, faceless, four arms, extra arms, malformed hands, extra fingers, fused fingers, distorted face, chibi, painterly, western comic, small head, long torso, profile view, side view, (oversized breasts:0.7), clothing, cropped feet, out of frame, bar censor, censored"
o=A/"art/prompts/anchors"; o.mkdir(parents=True,exist_ok=True)
for f in o.glob("*.txt"): f.unlink()
for ch,e in sorted(C.items(),key=lambda x:int(x[0])):
    s=N.get(ch)
    if not s: continue
    (o/f"{s}-t.txt").write_text("positive:\n"+f"{B}\n{P}\n"+", ".join(e["add"])+f"\n{T}\n{E}\nnegative:\n"+G+", "+", ".join(e["neg"])+"\n")
print("n",len(list(o.glob("*.txt"))))
