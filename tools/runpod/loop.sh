#!/usr/bin/env bash
set -uo pipefail
ROOT=/workspaces/rotn-assets; cd "$ROOT"; mkdir -p /tmp/anc
H=${1:?};P=${2:?};POSE=${3:?};TAG=${4:-tst};SEED=${5:-8};DRY=${DRY:-0}
CFGPIN=${CFGPIN:-0};SMPIN=${SMPIN:-0};MAX=${MAX:-8};SS=${SS:-17}
MODEL=${MODEL:-lustify};SKIN=${SKIN:-brown};HAIR=${HAIR:-off}
SRC=${SRC:-art/prompts/anchors}
S="-i $HOME/.ssh/id_ed25519 -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=ERROR"
R=root@"$H";E=/tmp/err-${POSE}.log
G(){ ssh $S -p "$P" "$R" "$@"; }
C(){ scp -q $S -P "$P" "$@"; }
B=/tmp/anc/base.txt
  cat $SRC/$POSE.txt > "$B" || { echo NOBASE; exit 1; }
best=0; keep=""
[ "$DRY" = "1" ] || G "rm -f /workspace/comfy/output/$TAG-a*" >/dev/null 2>&1
best=0;bestmn=999
GS=""
[ "$DRY" = "1" ] || { C "$R:/workspace/comfy/input/skel-$POSE.png" /tmp/anc/skel.png >/dev/null 2>&1 && GS=/tmp/anc/skel.png; }
[ -n "$GS" ] || echo "WARN no skel mask, unmasked gate"
for i in $(seq 1 "$MAX"); do
  cfg=4.0;smp=dpmpp_2m
  [ "$CFGPIN" != "0" ] && cfg=$CFGPIN
  [ "$SMPIN" != "0" ] && smp=$SMPIN
  X="STP=${STP:-40} CFG=$cfg SMP=$smp SCH=${SCH:-normal} CNS=${CNS:-0.97} W=${RW:-832} H=${RH:-1216} bash /workspace/gen.sh $POSE"
  T="$TAG-a$i"; echo "--- a$i cfg=$cfg smp=$smp"
awk '/^P: /{sub(/^P: /,"");print;exit}/^positive:/{f=1;next}/^negative:/{f=0}f' "$B" > /tmp/anc/p.txt
awk '/^N: /{sub(/^N: /,"");print;exit}/^negative:/{f=1;next}f' "$B" > /tmp/anc/n.txt
  if [ "$DRY" = "1" ]; then FN=/tmp/anc/b.png; python3 -c "from PIL import Image; Image.new('RGB',(832,1216),(60,60,60)).save('/tmp/anc/b.png')" 2>/dev/null; else
    C /tmp/anc/p.txt "$R":/workspace/comfy/input/prompt-$POSE.txt >/dev/null 2>&1
    C /tmp/anc/n.txt "$R":/workspace/comfy/input/neg-$POSE.txt >/dev/null 2>&1
    G "$X $T $((SEED+(i-1)*SS))" >/dev/null 2>$E
    FN=""; for t in $(seq 1 15); do
    FN=$(G "ls -t /workspace/comfy/output/$T* 2>/dev/null|head -1")
    [ -n "$FN" ] && break; sleep 4; done
  fi
  [ -n "$FN" ] || { echo "a$i nofile $(G "tail -1 $E" 2>/dev/null | cut -c1-60)"; continue; }
  if [ "$DRY" = "1" ]; then cp /tmp/anc/b.png /tmp/anc/try.png; else C "$R:$FN" /tmp/anc/try.png >/dev/null 2>&1; fi
  read em dk bot fil mn < <(python tools/score.py /tmp/anc/try.png $GS)
  if [ "$em" = "0" ]; then
    echo "a$i WASH retry"
    G "$X $T $((SEED+1000+i))" >/dev/null 2>$E
    FN=""; for t in $(seq 1 15); do
    FN=$(G "ls -t /workspace/comfy/output/$T* 2>/dev/null|head -1")
    [ -n "$FN" ] && break; sleep 4; done
    [ -n "$FN" ] && C "$R:$FN" /tmp/anc/try.png >/dev/null 2>&1
    read em dk bot fil mn < <(python tools/score.py /tmp/anc/try.png $GS)
    [ "$em" = "0" ] && { echo "a$i WASH again"; continue; }
  fi
  out=$(python tools/runpod/gate.py /tmp/anc/try.png $GS 2>&1); grc=$?
  echo "a$i $(printf %s "$out" | tr '\n' ' ')"
  [ "$grc" = "0" ] || continue
  echo "a$i edge=$em dark=$dk bot=$bot fill=$fil ok"
  PS=$(python -c "print(1 if $em>$best or ($em==$best and $mn<$bestmn) else 0)")
  [ "$PS" = "1" ] && { best=$em;bestmn=$mn;keep=$FN; }
  echo "PASS a$i"; [ "${NOSTOP:-0}" = "1" ] || break
done
if [ -n "$keep" ]; then
  O=/workspace/comfy/output/$TAG-best.png
  [ "$DRY" = "1" ] || G "cp $keep $O"
  echo "kept $keep edge=$best"; fi
echo done
