import sys
from PIL import Image,ImageFilter
g=Image.open(sys.argv[1]).convert('L');W,H=g.size;px=g.load();e=g.filter(ImageFilter.FIND_EDGES).load()
c=[x for x in range(W) if any(px[x,y]<235 for y in range(0,H,3))];r=[y for y in range(H) if any(px[x,y]<235 for x in range(0,W,3))]
if not c or not r: print('0 0 0 0');raise SystemExit
x0,y0,x1,y1=min(c),min(r),max(c),max(r)
em=sum(e[x,y] for y in range(y0,y1,2) for x in range(x0,x1,2))/((y1-y0)//2*(x1-x0)//2)
v=[px[x,y] for y in range(y0,y1,4) for x in range(x0,x1,4)]
print(round(em,1),round(100*sum(1 for q in v if q<90)/len(v),1),y1,round(100*(x1-x0)*(y1-y0)/(W*H),1))
