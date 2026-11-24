#!/usr/bin/env bash
python3 - <<'PY'
import json,subprocess
d=json.loads(subprocess.run(["runpodctl","pod","list"],capture_output=True,text=True).stdout)
c=[p for p in d if p.get("name")!="rotn-render"]
c.sort(key=lambda p:(p.get("name")!="rotn-judge", p.get("name") or ""))
if c: print(c[0]["id"])
PY
