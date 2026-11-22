import pathlib
p=pathlib.Path('tools/runpod/loop.sh'); s=p.read_text()
def r(a,b):
    global s
    assert a in s, a[:40]
    s=s.replace(a,b,1)
r('MAX=${MAX:-8}','MAX=${MAX:-8};SS=${SS:-17}')
r('$((SEED+i*17))','$((SEED+(i-1)*SS))')
r('$((SEED+i+50))','$((SEED+i*17))')
r('  echo "a$i edge=$em dark=$dk bot=$bot fill=$fil $([ "$bot" -ge 1200 ] && echo CROP || echo ok)"','  if [ "$bot" -ge 1200 ]; then echo "a$i edge=$em dark=$dk bot=$bot fill=$fil CROP"; continue; fi\necho "a$i edge=$em dark=$dk bot=$bot fill=$fil ok"')
r('for i in $(seq 1 $MAX); do','best=0;bestmn=999\nfor i in $(seq 1 $MAX); do')
r('if $em>$best and $bot<1200 and $bot>300 and $fil<95 and $mn<226','if ($em>$best or ($em==$best and $mn<$bestmn))')
r('then best=$em;keep=$FN;fi','then best=$em;bestmn=$mn;keep=$FN;fi')
r('[ -n "$keep" ] && { [ "$DRY" = "1" ] || ssh $S -p "$P" root@"$H" "cp $keep /workspace/comfy/output/$TAG-best.png"; echo "kept $keep edge=$best"; }','if [ -n "$keep" ]; then [ "$DRY" = "1" ] || ssh $S -p "$P" root@"$H" "cp $keep /workspace/comfy/output/$TAG-best.png"; echo "kept $keep edge=$best"; fi\necho done')
p.write_text(s); print('patched')
