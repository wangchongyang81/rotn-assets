#!/usr/bin/env python3
"""Score a judge reply. Exit 0 accept, 1 reject."""
import sys, json, pathlib
P = json.loads(pathlib.Path(__file__).with_name("policy.json").read_text())
r = json.loads(pathlib.Path(sys.argv[1]).read_text())
s = r["scores"]; total = round(sum(s[k] * w for k, w in P["weights"].items()), 3)
hf = [h for h in r.get("hard_fail", []) if h in P["hard_fail"]]
low = [k for k, v in s.items() if v < 3]
if abs(total - r["total"]) > 0.05: print(f"total corrected {r['total']} -> {total}")
ok = total >= P["accept"] and not hf and not low
print(json.dumps({"total": total, "accept": ok, "hard_fail": hf, "low": low,
                  "delta": r.get("delta", {})}, indent=1))
sys.exit(0 if ok else 1)
