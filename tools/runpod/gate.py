#!/usr/bin/env python3
import json, os, subprocess, sys
D = os.path.dirname(os.path.abspath(__file__))
R = subprocess.run(["git","-C",D,"rev-parse","--show-toplevel"],capture_output=True,text=True).stdout.strip()
if len(sys.argv) != 2: sys.exit("usage: gate.py IMAGE")
g = json.load(open(os.path.join(D, "judge-manifest.json")))["gates"]
p = subprocess.run([sys.executable, os.path.join(R,"tools","score.py"), sys.argv[1]], capture_output=True, text=True)
if p.returncode or not p.stdout.strip(): sys.exit("score failed: " + p.stderr[:200])
em, dk, bot, fil, mn = [float(x) for x in p.stdout.split()]
bad = []
def chk(n, v, lo, hi):
    if v < lo: bad.append(f"{n} {v} < {lo}")
    if hi is not None and v > hi: bad.append(f"{n} {v} > {hi}")
chk("edge", em, g["edge"], None)
chk("dark", dk, g["dark"], g["dark_max"])
chk("bot", bot, g["bot"][0], g["bot"][1])
chk("fill", fil, g["fill"][0], g["fill"][1])
chk("mean", mn, g["mean"][0], g["mean"][1])
print(f"edge {em} dark {dk} bot {bot} fill {fil} mean {mn}")
if bad: print("GATE FAIL: " + "; ".join(bad)); sys.exit(1)
print("GATE PASS")
