import base64,zlib,struct,json,urllib.request
def ch(t,d):
    c=struct.pack(">I",len(d))+t+d
    return c+struct.pack(">I",zlib.crc32(t+d)&0xffffffff)
def mk(w,h,f):
    raw=b"".join(b"\x00"+b"".join(bytes(f(x,y)) for x in range(w)) for y in range(h))
    return b"\x89PNG\r\n\x1a\n"+ch(b"IHDR",struct.pack(">IIBBBBB",w,h,8,2,0,0,0))+ch(b"IDAT",zlib.compress(raw))+ch(b"IEND",b"")
R=lambda x,y:(255,0,0); B=lambda x,y:(0,0,255)
cases={"solid_red_448":mk(448,448,R),
 "split_rb_448":mk(448,448,lambda x,y: R(x,y) if x<224 else B(x,y)),
 "solid_red_64":mk(64,64,R)}
sch={"type":"object","properties":{"verdict":{"type":"string","enum":["pass","fail"]},"colours":{"type":"string"}},"required":["verdict","colours"],"additionalProperties":False}
for n,p in cases.items():
    img=[{"type":"text","text":"Is this image one single solid colour? pass if yes, fail if not. Name every colour seen."},
         {"type":"image_url","image_url":{"url":"data:image/png;base64,"+base64.b64encode(p).decode()}}]
    b={"model":"judge","max_tokens":80,"messages":[{"role":"user","content":img}],
       "response_format":{"type":"json_schema","json_schema":{"name":"v","strict":True,"schema":sch}}}
    r=urllib.request.Request("http://127.0.0.1:8000/v1/chat/completions",data=json.dumps(b).encode(),headers={"content-type":"application/json"})
    c=json.loads(urllib.request.urlopen(r,timeout=120).read())["choices"][0]["message"]["content"]
    print(n, "->", c.strip()[:110])
