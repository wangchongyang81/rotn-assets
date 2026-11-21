import json, sys, pathlib
bad=0
for f in pathlib.Path('art/manifests').rglob('*.jsonl'):
    rows=[json.loads(l) for l in f.read_text().split('\n') if l.strip()]
    acc=[r for r in rows if r.get('accepted')]
    if len(acc)!=1:
        print(f'{f}: {len(acc)} accepted rows'); bad+=1
    for r in rows:
        p=pathlib.Path('art')/r['file']
        if not p.exists():
            print(f'{f}: missing {r["file"]}'); bad+=1
        if r.get('accepted') and not p.name.startswith('anchor-'+r['pose']+'_'):
            print(f'{f}: accepted name mismatch {p.name}'); bad+=1
print('bad',bad); sys.exit(1 if bad else 0)
