#!/usr/bin/env python3
"""Iteration loop: compose, render, gate, judge, apply delta. Cap six, accept 3.8."""
import sys, os, json, time, shutil, subprocess, pathlib, hashlib, urllib.request
H = pathlib.Path(__file__).parent; A = pathlib.Path("master/anchors")
POL = json.loads(H.joinpath("judge/policy.json").read_text())
COMFY = os.environ.get("COMFY_URL", "http://127.0.0.1:8188").rstrip("/")
GUARD = "lowres, extra finger, fused finger, watermark, text, signature"

def row(c):
    t = A.joinpath("companions-table.md").read_text().split("\n")
    return t[0] + "\n" + [l for l in t if l.startswith(f"| {c} |")][0]

def compose(body, add, w):
    return ", ".join([body] + [f"({a}:{w[a]})" if a in w else a for a in add])

def apply(add, w, d):
    rem = {x.lower() for x in d.get("remove", [])}
    add = [a for a in add if a.lower() not in rem]
    for a in d.get("add", []):
        if a.lower() not in {x.lower() for x in add}: add.append(a)
    for k, v in d.get("strengthen", {}).items():
        if k in add: w[k] = v
    return add, w

def render(prompt, neg, seed):
    raw = pathlib.Path("tools/loop-workflow.json").read_text()
    raw = raw.replace("__PROMPT__", prompt).replace("__NEG__", neg).replace("__SEED__", str(seed))
    req = urllib.request.Request(COMFY + "/prompt", data=json.dumps({"prompt": json.loads(raw)}).encode(), headers={"Content-Type": "application/json"})
    pid = json.loads(urllib.request.urlopen(req, timeout=30).read())["prompt_id"]
    for _ in range(180):
        time.sleep(2)
        h = json.loads(urllib.request.urlopen(f"{COMFY}/history/{pid}", timeout=30).read())
        if pid in h:
            for n in h[pid]["outputs"].values():
                for im in n.get("images", []): return pathlib.Path("comfy-out", im["filename"])
    raise SystemExit("render timeout")

def main():
    c = int(sys.argv[1]); pose = sys.argv[2] if len(sys.argv) > 2 else "p"
    J = json.loads(A.joinpath("companions-1-8.json").read_text())[str(c)]
    add = list(J["add"]); neg = list(J["neg"]) + [GUARD]; w = {}
    var = J["variant"].lower(); body = A.joinpath(f"anchor-v{var}-female-t/front.txt").read_text().split("\n")[3]
    dst = A / f"companion-{c:02d}-{pose}"; dst.mkdir(parents=True, exist_ok=True)
    seed0 = int(hashlib.sha256(f"{c}{pose}".encode()).hexdigest()[:8], 16); hist = []
    for i in range(POL["max_iter"]):
        seed = seed0 + i; pr = compose(body, add, w)
        dst.joinpath(f"iter{i}.prompt.txt").write_text(pr)
        img = render(pr, ", ".join(neg), seed); shutil.copy(img, dst / f"iter{i}.png")
        chk = subprocess.run([sys.executable, "tools/check_anchor.py", "check", str(dst / f"iter{i}.png")], capture_output=True, text=True)
        ask = subprocess.run([sys.executable, "tools/judge/ask.py", str(dst / f"iter{i}.png"), str(c)], capture_output=True, text=True)
        h = {"iter": i, "seed": seed, "chk_rc": chk.returncode}
        if ask.returncode or not ask.stdout.strip(): hist.append(h | {"err": ask.stderr[-200:]}); print("judge_fail", i); continue
        v = subprocess.run([sys.executable, "tools/judge/validate.py", ask.stdout.strip()], capture_output=True, text=True)
        vj = json.loads(v.stdout); h |= {"total": vj["total"], "hard_fail": vj["hard_fail"], "low": vj["low"]}
        hist.append(h); print(i, vj["total"], vj["hard_fail"], vj["low"])
        if v.returncode == 0 and chk.returncode == 0:
            dst.joinpath("lock.json").write_text(json.dumps({"companion": c, "name": J["name"], "pose": pose, "variant": var, "anchor": f"anchor-v{var}-female-{pose}", "seed": seed, "model": os.environ.get("MODEL", "noobai-xl"), "sampler": "euler_ancestral", "prompt_sha": hashlib.sha256(pr.encode()).hexdigest()[:16], "history": hist}, indent=1))
            print("ACCEPT", i); return
        add, w = apply(add, w, vj["delta"])
    print("PLATEAU"); dst.joinpath("plateau.json").write_text(json.dumps(hist, indent=1))

if __name__ == "__main__":
    main()
