#!/usr/bin/env python3
import glob, json, pathlib, sys
A = pathlib.Path(__file__).resolve().parent.parent / "master/anchors"
schema = json.loads((A / "anchor.schema.json").read_text())
try:
    import jsonschema
except ImportError:
    jsonschema = None
bad = 0
for f in sorted(glob.glob(str(A / "anchor-*/lock.json"))):
    d = json.loads(pathlib.Path(f).read_text())
    want = "skel-%s.png" % ("tpose" if d.get("pose") == "T" else "ppose")
    if jsonschema:
        try:
            jsonschema.validate(d, schema)
        except Exception as e:
            bad += 1; print("FAIL", f, str(e).splitlines()[0][:70]); continue
    else:
        miss = [k for k in schema["required"] if k not in d]
        if miss:
            bad += 1; print("FAIL", f, miss); continue
    if d.get("skeleton") != want:
        bad += 1; print("FAIL", f, "skeleton/pose"); continue
    if d.get("seed") != 7:
        print("WARN", f, "seed", d.get("seed"))
print("locks bad", bad)
sys.exit(1 if bad else 0)
