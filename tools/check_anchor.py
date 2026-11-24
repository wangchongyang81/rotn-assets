#!/usr/bin/env python3
"""Objective gate for anchor renders: crop, feet, lineart, hands. No model calls."""
import sys, json, pathlib
import numpy as np
from PIL import Image
try:
    import cv2
except ImportError:
    cv2 = None
try:
    import mediapipe as mp
except ImportError:
    mp = None
TH = pathlib.Path("master/anchors/check-thresholds.json")
REQ = ("top", "bottom", "left", "right", "lap", "area")

def mask_of(a):
    c = np.concatenate([a[:8, :8].reshape(-1, 3), a[:8, -8:].reshape(-1, 3),
                        a[-8:, :8].reshape(-1, 3), a[-8:, -8:].reshape(-1, 3)])
    return np.abs(a.astype(np.int16) - np.median(c, axis=0)).sum(2) > 26

def metrics(p):
    im = Image.open(p).convert("RGB"); a = np.asarray(im); h, w, _ = a.shape
    m = mask_of(a)
    if m.sum() < 500: return {"file": p, "error": "empty mask"}
    ys, xs = np.where(m); g = np.asarray(im.convert("L"), float)
    lap = float(cv2.Laplacian(g, cv2.CV_64F).var()) if cv2 else float(g.var())
    o = {"file": p, "w": w, "h": h, "top": round(ys.min() / h, 4),
         "bottom": round((h - 1 - ys.max()) / h, 4), "left": round(xs.min() / w, 4),
         "right": round((w - 1 - xs.max()) / w, 4), "area": round(float(m.mean()), 4),
         "lap": round(lap, 1), "hands": 0, "fingers": []}
    if mp:
        r = mp.solutions.hands.Hands(static_image_mode=True, max_num_hands=2).process(a)
        hl = r.multi_hand_landmarks or []
        o["hands"] = len(hl)
        o["fingers"] = [sum(1 for t, b in zip(x.landmark[4::4], x.landmark[3::4]) if t.y < b.y) for x in hl]
    return o

def verdict(m, t):
    f = []
    for k in REQ:
        if m[k] < t.get(k, 0):
            f.append(f"{k} {m[k]} < {t[k]}" if k in ("lap", "area") else f"{k} margin {m[k]} < {t[k]}")
    for i, n in enumerate(m.get("fingers", [])):
        if n not in (4, 5): f.append(f"hand{i} {n} fingers")
    if t.get("min_hands") and m.get("hands", 0) < t["min_hands"]:
        f.append(f"hands {m['hands']} < {t['min_hands']}")
    return f

def main():
    mode = sys.argv[1]; paths = sys.argv[2:]
    t = json.loads(TH.read_text()) if TH.exists() else {}
    bad = 0
    for p in paths:
        m = metrics(p)
        if "error" in m: print(json.dumps(m)); bad += 1; continue
        if mode == "calibrate": print(json.dumps(m)); continue
        m["fail"] = verdict(m, t); bad += bool(m["fail"]); print(json.dumps(m))
    if mode == "calibrate" and paths:
        TH.write_text(json.dumps({k: min(metrics(p).get(k, 0) for p in paths) for k in REQ} | {"min_hands": 2}, indent=1))
    sys.exit(1 if bad else 0)

if __name__ == "__main__":
    main()
