import pathlib
p=pathlib.Path('tools/runpod/loop.sh'); L=p.read_text().splitlines(); n=0
def f(k,a=None,b=None,t=None):
    global n
    for i,l in enumerate(L):
        if k in l:
            L[i]=t if t else l.replace(a,b,1); n+=1; return
    raise SystemExit('miss '+k)
f('MAX=${MAX:-8}','MAX=${MAX:-8}','MAX=${MAX:-8};SS=${SS:-17}')
f('$POSE $T $((SEED+i*17))','$((SEED+i*17))','$((SEED+(i-1)*SS))')
f('$POSE $T $((SEED+i+50))','$((SEED+i+50))','$((SEED+i*17))')
f('for i in $(seq','for i in $(seq','best=0;bestmn=999\nfor i in $(seq')
f('echo "a$i edge=$em',t='  if [ "$bot" -ge 1200 ]; then echo "a$i edge=$em dark=$dk bot=$bot fill=$fil CROP"; continue; fi\n  echo "a$i edge=$em dark=$dk bot=$bot fill=$fil ok"')
f('$em>$best',t='  if [ "$(python -c "print(1 if $em>$best or ($em==$best and $mn<$bestmn) else 0)")" = "1" ]; then best=$em;bestmn=$mn;keep=$FN;fi')
f('[ -n "$keep" ] &&',t='if [ -n "$keep" ]; then [ "$DRY" = "1" ] || ssh $S -p "$P" root@"$H" "cp $keep /workspace/comfy/output/$TAG-best.png"; echo "kept $keep edge=$best"; fi\necho done')
p.write_text('\n'.join(L)+'\n'); print('patched',n)
q=pathlib.Path('tools/runpod/log.sh'); t=q.read_text()
o='  ps=$(h "$P/$POSE.txt"); ns=$(h "$P/neg-$POSE.txt")'
assert o in t
q.write_text(t.replace(o,'  ps=$(h "$P/$POSE.txt"); nf="$P/neg-$POSE.txt"; if [ ! -f "$nf" ]; then nf=/tmp/neg.$$; sed -n \'s/^N: //p\' "$P/$POSE.txt" > "$nf"; fi; ns=$(h "$nf")').replace('[ -n "$ns" ] && cp "$P/neg-$POSE.txt"','[ -n "$ns" ] && cp "$nf"'))
print('neg_fix')
