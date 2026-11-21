import pathlib,sys
D=pathlib.Path('art/prompts/wild/wild.dat').read_text()
def get(k):
    out=[];on=False
    for l in D.split('\n'):
        if l.startswith('['): on=l.strip()[1:-1]==k; continue
        if on and l.strip(): out.append(l.strip())
    return ', '.join(out)
BAD=[('simple background','white background'),('topless','completely nude'),
     ('brown skin','dark skin'),('dim lighting','rim lighting')]
M=sys.argv[1]; SK=sys.argv[2]; HR=sys.argv[3]
POSES=['tpose','ppose','apose-wide','p1','p2','p3','p4','p5','p7','p8']
Q=get('quality.'+M); ok=0
for p in POSES:
    parts=[Q,get('anatomy'),get('pose.'+p),get('frame'),get('body.nude'),
           get('light'),get('bg.pos'),get('face')]
    if SK!='none': parts.append(get('skin.'+SK))
    if HR=='on': parts.append(get('hair'))
    pos=', '.join(parts)
    neg=', '.join([get('artifact.neg'),get('layout.neg'),get('bg.neg'),get('censor.neg')])
    s=pos+neg; bad=[]
    if len(get('pose.'+p).split(','))>4: bad.append('pose>4')
    for a,b in BAD:
        if a in s and b in s: bad.append(a+'+'+b)
    if bad: print(p,'CONTRADICTION',bad); continue
    d=pathlib.Path('art/prompts/wild/%s/%s-%s'%(M,SK,HR)); d.mkdir(parents=True,exist_ok=True)
    (d/(p+'.txt')).write_text('P: '+pos+'\nN: '+neg+'\n'); ok+=1
print(M,SK,HR,'written',ok)
