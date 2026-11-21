import pathlib
from PIL import Image, ImageDraw
W,H=832,1216
im=Image.new('L',(W,H),0); d=ImageDraw.Draw(im)
L=[ [(416,236),(416,300)], [(340,322),(492,300)],
 [(340,322),(322,455),(312,595)], [(492,300),(512,450),(526,588)],
 [(416,300),(419,649)], [(372,632),(466,668)],
 [(372,632),(366,880),(362,1128)], [(362,1128),(334,1146)],
 [(466,668),(450,870),(500,1092)], [(500,1092),(530,1108)] ]
d.ellipse([370,144,462,236],outline=255,width=9)
for p in L: d.line(p,fill=255,width=9,joint='curve')
im.save('art/skeletons/skel-ppose.png')
print('wrote', im.size)
