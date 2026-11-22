#!/usr/bin/env bash
set -uo pipefail
ROOT=/workspaces/rotn-assets; cd "$ROOT"; mkdir -p /tmp/anc
H=${1:?};P=${2:?};POSE=${3:?};TAG=${4:-tst};SEED=${5:-7};DRY=${DRY:-0};GE=${GE:-3.0};GD=${GD:-3.0};CFGPIN=${CFGPIN:-0};SMPIN=${SMPIN:-0};MAX=${MAX:-8};SS=${SS:-17}
S="-i $HOME/.ssh/id_ed25519 -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=ERROR"
B=/tmp/anc/base.txt
V=("")
N=("")
git show HEAD:art/prompts/wild/noobai/brown-on/$POSE.txt > "$B" || { echo NOBASE; exit 1; }
best=0; keep=""
[ "$DRY" = "1" ] || ssh $S -p "$P" root@"$H" "rm -f /workspace/comfy/output/$TAG-a*" >/dev/null 2>&1
best=0;bestmn=999
for i in $(seq 1 "$MAX"); do
  v=$(( (i-1)%4 ))
  case $i in 1|2|3|4) cfg=5.0;smp=dpmpp_2m;;5|6|7) cfg=6.5;smp=euler_ancestral;;*) cfg=7.5;smp=dpmpp_2m;;esac
  [ "$CFGPIN" != "0" ] && cfg=$CFGPIN
  [ "$SMPIN" != "0" ] && smp=$SMPIN
  T="$TAG-a$i"; echo "--- a$i cfg=$cfg smp=$smp"
sed -n 's/^P: //p' "$B" > /tmp/anc/p.txt; if [ -n "${V[$v]:-}" ]; then printf ', %s\n' "${V[$v]}" >> /tmp/anc/p.txt; fi
sed -n 's/^N: //p' "$B" > /tmp/anc/n.txt; if [ -n "${N[$v]:-}" ]; then printf ', %s\n' "${N[$v]}" >> /tmp/anc/n.txt; fi
  if [ "$DRY" = "1" ]; then FN=/tmp/anc/b.png; else
    scp $S -P "$P" /tmp/anc/p.txt root@"$H":/workspace/comfy/input/prompt-$POSE.txt >/dev/null 2>&1
    scp $S -P "$P" /tmp/anc/n.txt root@"$H":/workspace/comfy/input/neg-$POSE.txt >/dev/null 2>&1
    ssh $S -p "$P" root@"$H" "CFG=$cfg SMP=$smp bash /workspace/gen.sh $POSE $T $((SEED+(i-1)*SS))" >/dev/null 2>/tmp/err-${POSE}.log
    FN=""; for t in $(seq 1 15); do FN=$(ssh $S -p "$P" root@"$H" "ls -t /workspace/comfy/output/$T* 2>/dev/null|head -1"); [ -n "$FN" ] && break; sleep 4; done
  fi
  [ -n "$FN" ] || { echo "a$i nofile $(ssh $S -p "$P" root@"$H" "tail -1 /tmp/err-$POSE.log" 2>/dev/null | cut -c1-60)"; continue; }
  if [ "$DRY" = "1" ]; then cp /tmp/anc/b.png /tmp/anc/try.png; else scp $S -P "$P" "root@$H:$FN" /tmp/anc/try.png >/dev/null 2>&1; fi
  read em dk bot fil mn < <(python tools/score.py /tmp/anc/try.png)
  if [ "$em" = "0" ]; then
    echo "a$i WASH retry"
    ssh $S -p "$P" root@"$H" "CFG=$cfg SMP=$smp bash /workspace/gen.sh $POSE $T $((SEED+1000+i))" >/dev/null 2>/tmp/err-${POSE}.log
    FN=""; for t in $(seq 1 15); do FN=$(ssh $S -p "$P" root@"$H" "ls -t /workspace/comfy/output/$T* 2>/dev/null|head -1"); [ -n "$FN" ] && break; sleep 4; done
    [ -n "$FN" ] && scp $S -P "$P" "root@$H:$FN" /tmp/anc/try.png >/dev/null 2>&1
    read em dk bot fil mn < <(python tools/score.py /tmp/anc/try.png)
    [ "$em" = "0" ] && { echo "a$i WASH again"; continue; }
  fi
  if [ "$bot" -ge 1216 ] || [ "$bot" -le 1100 ]; then echo "a$i edge=$em dark=$dk bot=$bot fill=$fil CROP"; continue; fi
  g=$(python -c "print(1 if $em>=$GE and $dk>=$GD and $bot<1216 and $bot>1100 and $fil<98 and $mn<235 and $dk<=50 and $mn>=150 else 0)")
  if [ "$g" = "1" ]; then echo "a$i edge=$em dark=$dk bot=$bot fill=$fil ok"; else echo "a$i edge=$em dark=$dk bot=$bot fill=$fil weak"; fi
  [ "$g" = "1" ] && [ "$(python -c "print(1 if $em>$best or ($em==$best and $mn<$bestmn) else 0)")" = "1" ] && { best=$em;bestmn=$mn;keep=$FN; }
  [ "$g" = "1" ] && { echo "PASS a$i"; [ "${NOSTOP:-0}" = "1" ] || break; }
done
if [ -n "$keep" ]; then [ "$DRY" = "1" ] || ssh $S -p "$P" root@"$H" "cp $keep /workspace/comfy/output/$TAG-best.png"; echo "kept $keep edge=$best"; fi
echo done
