import base64, zlib, struct, json, urllib.request
w=h=64
raw=b"".join(b"\x00"+b"\xff\x00\x00"*w for _ in range(h))
def chunk(t,d):
    c=struct.pack(">I",len(d))+t+d
    return c+struct.pack(">I",zlib.crc32(t+d)&0xffffffff)
png=(b"\x89PNG\r\n\x1a\n"+chunk(b"IHDR",struct.pack(">IIBBBBB",w,h,8,2,0,0,0))
     +chunk(b"IDAT",zlib.compress(raw))+chunk(b"IEND",b""))
b64=base64.b64encode(png).decode()
msg=[{"type":"text","text":"What colour is this image? One word."},
     {"type":"image_url","image_url":{"url":"data:image/png;base64,"+b64}}]
body=json.dumps({"model":"judge","max_tokens":24,
  "messages":[{"role":"user","content":msg}]}).encode()
r=urllib.request.Request("http://127.0.0.1:8000/v1/chat/completions",
  data=body,headers={"content-type":"application/json"})
print(urllib.request.urlopen(r,timeout=120).read().decode()[:320])
