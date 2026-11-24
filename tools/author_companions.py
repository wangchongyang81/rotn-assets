import pathlib,json
A=pathlib.Path('master/anchors'); p=A/'companions-1-8.json'; d={}
for l in p.read_text().split('\n'):
for l in p.read_text().split("\n"):
    l=l.strip().rstrip(",")
    if l: d.update({int(k):v for k,v in json.loads(l).items()})
T={l.split('|')[2].strip():l.split('|')[3].strip() for l in (A/'companions-table.md').read_text().split('\n')[2:] if l.count('|')>10}
N={'V1':'pale skin|slender frame','V2':'warm skin|broad build','V3':'heavy build|warm damp skin','V4':'dry skin|narrow hip','V5':'slender|pale skin','V6':'pale clean skin|slim arms','V7':'slender frame|warm tone','V8':'warm tone|soft curve','V9':'cool shadow|matte skin','V10':'slouch|narrow shoulder'}
for k in N: N[k]=N[k].split('|')
B={'V1':'warm-neutral skin, medium build, heavy work posture','V2':'lean, long limb, dry skin','V3':'short limb, deep chest, weathered face, chapped lip','V4':'softer, heavier, strong calf','V5':'compact, broad, thick forearm','V6':'sinewy, ash-grey undertone, scarred hand','V7':'blue-grey undertone, pale cloud banding, broad stance','V8':'bleached pale skin on the lit side, hard terminator, still face','V9':'sun-bleached, white-gold highlight on upward planes, narrow eye','V10':'square-set, thick neck, planted feet, vertical stance'}
for l in (A/'companions-9-33.tsv').read_text().strip().split('\n'):
    i,v,n,a=l.split('|'); d[int(i)]={'variant':v,'name':n,'add':a.split(';'),'neg':N[v]}
b=pathlib.Path('art-bible/02-anime-character.md'); t=b.read_text().split('## Companion descriptors')[0]
o=['## Companion descriptors (realms 1-33)\n','Anchors are bodies; these are ref-pack layers that cite one. Explicit by default:\nuncensored, nude, full body, wet skin, blush, heavy detail.\n']
for k in sorted(d):
    v=d[k]; a=f"anchor-{v['variant'].lower()}-female"; ok=(A/a+'-t').is_dir()
    o.append(f"\n### {k} {v['name']} — {v['variant']}\n- anchor: `master/anchors/{a}-t/` rig, `{a}-p/` portrait\n- state: {'built' if ok else 'VARIANT NOT BUILT'}\n- base: {B[v['variant']]}\n- derivation: {T.get(v['name'],'')}\n- add: {', '.join(v['add'])}\n- neg: {', '.join(v['neg'])}\n")
b.write_text(t+''.join(o)); p.write_text(json.dumps({str(k):d[k] for k in sorted(d)},indent=1))
print('json_ok',len(d))
V={'v3':'high cold','v4':'wet lowland','v5':'forest','v6':'kiln','v7':'earth','v8':'moon','v9':'day','v10':'pole'}
for k in V:
    body=B[k.upper()]
    for pose in 'tp':
        src=A/f'anchor-v1-female-{pose}'; dst=A/f'anchor-{k}-female-{pose}'; dst.mkdir(exist_ok=True)
        for f in src.glob('*.txt'):
            L=f.read_text().split('\n')
            if len(L)>3: L[3]=f'female adult mid-twenties, {body}, (medium breasts:1.1), (small nipples:1.2), (tiny areola:1.4), head to body ratio 1 to 7'
            dst.joinpath(f.name).write_text('\n'.join(L))
        dst.joinpath('lock.json').write_text(json.dumps({'variant':V[k],'status':'draft','seed':None},indent=1))
print('variants',len(V),'newtxt',len(list(A.glob('anchor-v[3-9]-female-*/*.txt')))+len(list(A.glob('anchor-v10-female-*/*.txt'))))
