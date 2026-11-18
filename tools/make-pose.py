from PIL import Image, ImageDraw
W, H = 832, 1216
C = W // 2
COL = [(255,0,0),(255,85,0),(255,170,0),(255,255,0),(170,255,0),(85,255,0),(0,255,0),
       (0,255,85),(0,255,170),(0,255,255),(0,170,255),(0,85,255),(0,0,255),(85,0,255),
       (170,0,255),(255,0,170)]
J = ["nose","neck","rsh","rel","rwr","lsh","lel","lwr","rhip","rkne","rank",
     "lhip","lkne","lank","reye","leye"]
CI = {k: i for i, k in enumerate(J)}
LIMB = [("neck","nose"),("neck","rsh"),("rsh","rel"),("rel","rwr"),("neck","lsh"),
        ("lsh","lel"),("lel","lwr"),("neck","rhip"),("rhip","rkne"),("rkne","rank"),
        ("neck","lhip"),("lhip","lkne"),("lkne","lank"),("nose","reye"),("nose","leye")]
def build(t):
    p = {"nose": (C,200), "neck": (C,270), "reye": (C+26,180), "leye": (C-26,180)}
    if t:
        p["rsh"]=(C+110,300); p["rel"]=(C+230,300); p["rwr"]=(C+350,300)
        p["lsh"]=(C-110,300); p["lel"]=(C-230,300); p["lwr"]=(C-350,300)
        p["rhip"]=(C+70,620); p["rkne"]=(C+80,880); p["rank"]=(C+90,1120)
        p["lhip"]=(C-70,620); p["lkne"]=(C-80,880); p["lank"]=(C-90,1120)
    else:
        p["rsh"]=(C+88,300); p["rel"]=(C+124,432); p["rwr"]=(C+150,545)
        p["lsh"]=(C-88,300); p["lel"]=(C-124,432); p["lwr"]=(C-150,545)
        p["rhip"]=(C+89,620); p["rkne"]=(C+90,880); p["rank"]=(C+90,1120)
        p["lhip"]=(C-41,620); p["lkne"]=(C-34,882); p["lank"]=(C-50,1120)
    return p
def draw(p, path):
    im = Image.new("RGB", (W,H), (0,0,0))
    d = ImageDraw.Draw(im)
    for a, b in LIMB:
        d.line([p[a], p[b]], fill=COL[CI[b]], width=10)
    for k in J:
        x, y = p[k]
        d.ellipse([x-7,y-7,x+7,y+7], fill=COL[CI[k]])
    im.save(path); print(path, im.size)
draw(build(True), "master/anchors/pose/tpose-832x1216.png")
draw(build(False), "master/anchors/pose/ppose-832x1216.png")
