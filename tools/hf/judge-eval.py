#!/usr/bin/env python3
import base64,json,sys,urllib.request
S=json.load(open("deploy/judge/verdict-schema.json"))
P=json.load(open("deploy/judge/prompts.json"))
b64=base64.b64encode(open(sys.argv[1],"rb").read()).decode()
def call(axis):
    q=P["preamble"]+"\n\n"+P["axes"][axis]
    img=[{"type":"text","text":q},{"type":"image_url","image_url":{"url":"data:image/png;base64,"+b64}}]
    b={"model":"judge","max_tokens":200,"messages":[{"role":"user","content":img}],
       "response_format":{"type":"json_schema","json_schema":{"name":"v","strict":True,"schema":S}}}
    r=urllib.request.Request("http://127.0.0.1:8000/v1/chat/completions",
        data=json.dumps(b).encode(),headers={"content-type":"application/json"})
    return json.loads(urllib.request.urlopen(r,timeout=180).read())["choices"][0]["message"]["content"]
for a in P["axes"]:
    d=json.loads(call(a))
    assert set(d)=={"verdict","scores","reason"}, "keys "+a
    assert set(d["scores"])=={"identity","anatomy","props","style"}, "axes "+a
    assert all(isinstance(v,int) and 0<=v<=10 for v in d["scores"].values()), "range "+a
    print(a, d["verdict"], d["scores"][a], d["reason"][:55])
print("eval_done")
