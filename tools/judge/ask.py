#!/usr/bin/env python3
"""One judge call per render. Writes <render>.judge.json. --dry skips the post."""
import sys, os, json, base64, pathlib, urllib.request
H = pathlib.Path(__file__).parent
R = pathlib.Path(sys.argv[1]); C = int(sys.argv[2])
T = pathlib.Path("master/anchors/companions-table.md").read_text().split("\n")
sec = T[0] + "\n" + [l for l in T if l.startswith(f"| {C} |")][0]
chk = pathlib.Path(sys.argv[3]).read_text() if len(sys.argv) > 3 and pathlib.Path(sys.argv[3]).exists() else "{}"
sysp = H.joinpath("contract.md").read_text().split("## System prompt")[1].split("## Axes")[0].strip()
mime = "image/webp" if R.suffix == ".webp" else "image/png"
url = "data:%s;base64,%s" % (mime, base64.b64encode(R.read_bytes()).decode())
msg = [{"role": "system", "content": sysp},
       {"role": "user", "content": [
         {"type": "text", "text": f"Companion entry:\n{sec}\n\nCode check:\n{chk}\n\nScore it."},
         {"type": "image_url", "image_url": {"url": url}}]}]
body = {"model": "judge", "temperature": 0, "max_tokens": 700, "messages": msg,
        "guided_json": json.loads(H.joinpath("schema.json").read_text())}
if "--dry" in sys.argv:
    body["messages"][0]["content"] = sysp[:44] + "..."
    body["messages"][1]["content"][1]["image_url"]["url"] = "<b64 %d bytes>" % R.stat().st_size
    print(json.dumps(body, indent=1)[:900]); sys.exit(0)
req = urllib.request.Request(os.environ["JUDGE_URL"].rstrip("/") + "/v1/chat/completions",
    data=json.dumps(body).encode(), headers={"Content-Type": "application/json"})
r = json.loads(urllib.request.urlopen(req, timeout=180).read())["choices"][0]["message"]["content"]
out = R.with_suffix(".judge.json"); out.write_text(r); print(out)
