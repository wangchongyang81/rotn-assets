import pathlib,sys,re
D=pathlib.Path('art/prompts/base/wild.dat').read_text().split('\n')
def get(k):
    out=[];on=False
    for l in D:
        if l.startswith('['): on=l.strip()[1:-1]==k; continue
        if on and l.strip(): out.append(l.strip())
    return ', '.join(out)
import json
C=json.load(open('art/prompts/base/companions.json'))
M=sys.argv[1]; SK=sys.argv[2]; HR=sys.argv[3]
def slug(n): return re.sub(r'-+','-',re.sub(r"[^a-z0-9]+",'-',n.lower())).strip('-')
NK=['artifact.neg','style.neg','layout.neg','bg.neg','shade.neg','body.neg','fit.neg','censor.neg']
neg=', '.join(get(k) for k in NK if get(k))
d=pathlib.Path('art/prompts/base/%s/%s-%s'%(M,SK,HR)); d.mkdir(parents=True,exist_ok=True)
ok=0; seen=set()
for i in sorted(C,key=int):
    e=C[i]; v=e['variant']; s=slug(e['name'])
    if s in seen: print('DUP',s); continue
    seen.add(s)
    if not get('pose.'+i): print(i,s,'NO POSE'); continue
    if not get('env.'+v.lower()): print(i,s,'NO ENV'); continue
    parts=[get('quality'),get('anatomy'),get('pose.'+i),get('frame'),get('body.nude'),
           ', '.join(e['add'])]
    if SK!='none': parts.append(get('skin.'+SK))
    if HR=='on': parts.append(get('hair'))
    parts+=[get('face'),get('light'),get('env.'+v.lower()),get('env.'+v.lower()+'.key')]
    pos=', '.join(x for x in parts if x).rstrip(', ')
    (d/('prompt-'+s+'.txt')).write_text(pos+'\n')
    (d/('neg-'+s+'.txt')).write_text(neg+', '+', '.join(e['neg'])+'\n')
    ok+=1
print(M,SK,HR,'written',ok,'of',len(C))
