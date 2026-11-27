import json,pathlib
A=pathlib.Path("/workspaces/rotn-assets")
W=(A/"art/prompts/base/wild.dat").read_text()
def get(k):
    out=[];on=False
    for l in W.split('\n'):
        if l.startswith('['): on=l.strip()[1:-1]==k; continue
        if on and l.strip(): out.append(l.strip())
    return ', '.join(out)
C=json.loads((A/"art/prompts/base/companions.json").read_text())
N=json.loads((A/"ref/NAMES.json").read_text())
o=A/"art/prompts/anchors"; o.mkdir(parents=True,exist_ok=True)
for f in o.glob("*.txt"): f.unlink()
NK=["artifact.neg","style.neg","layout.neg","bg.neg","shade.neg","body.neg","fit.neg","censor.neg"]
ok=0
for ch,e in sorted(C.items(),key=lambda x:int(x[0])):
    s=N.get(ch); env=get("env."+e.get("variant","").lower())
    if not s: print("NONAME",ch); continue
    if not env: print("NOENV",ch,e.get("variant")); continue
    pos=", ".join(x for x in [get("quality"),get("style"),get("anatomy"),(get("pose."+ch) or get("pose")),get("frame"),
        get("body.nude"),", ".join(e["add"]),get("light"),env] if x)
    neg=", ".join(get(k) for k in NK if get(k))+", "+", ".join(e["neg"])
    (o/f"{s}.txt").write_text("positive:\n"+pos+"\nnegative:\n"+neg+"\n")
    ok+=1
print("written",ok)
