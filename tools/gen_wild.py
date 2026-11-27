import pathlib,sys
D=pathlib.Path('art/prompts/base/wild.dat').read_text()
def get(k):
    out=[];on=False
    for l in D.split('\n'):
        if l.startswith('['): on=l.strip()[1:-1]==k; continue
        if on and l.strip(): out.append(l.strip())
    return ', '.join(out)
ENV=['v1','v2','v3','v4','v5','v6','v7','v8','v9','v10']
M=sys.argv[1]; SK=sys.argv[2]; HR=sys.argv[3]
ok=0
for e in ENV:
    parts=[get('quality'),get('anatomy'),get('pose'),get('frame'),get('body.nude')]
    if SK!='none': parts.append(get('skin.'+SK))
    if HR=='on': parts.append(get('hair'))
    parts+=[get('face'),get('light'),get('env.'+e)]
    pos=', '.join(x for x in parts if x).rstrip(', ')
    NK=['artifact.neg','style.neg','layout.neg','bg.neg','shade.neg','body.neg','fit.neg','censor.neg']
    neg=', '.join(get(k) for k in NK if get(k))
    if not get('env.'+e): print(e,'NO ENV'); continue
    if len(get('pose').split(','))>4: print(e,'POSE>4'); continue
    d=pathlib.Path('art/prompts/base/%s/%s-%s'%(M,SK,HR)); d.mkdir(parents=True,exist_ok=True)
    (d/(e+'.txt')).write_text('P: '+pos+'\nN: '+neg+'\n'); ok+=1
print(M,SK,HR,'written',ok)
