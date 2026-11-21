#!/usr/bin/env bash
set -uo pipefail
ROOT=/workspaces/rotn-assets; cd "$ROOT"; mkdir -p /tmp/anc
H=${1:?};P=${2:?};POSE=${3:?};TAG=${4:-tst};SEED=${5:-7};DRY=${DRY:-0};GE=${GE:-6};GD=${GD:-4}
S="-i $HOME/.ssh/id_ed25519 -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=ERROR"
B=art/prompts/wild/noobai/brown-on/$POSE.txt
V=("(lineart:1.4), sharp outlines, no flat shading"
   "flat shading, (lineart:1.6), thick outlines"
   "(heavy lineart:1.7), dark outlines, (dim lighting:1.5)"
   "(lineart:1.5), high contrast, no cel shading")
N=("soft shading, blurry, pastel, flat shading"
   "faint lines, blurry, cel shading"
   "washed out, low contrast, soft shading"
   "blurry, gradient shading, flat shading")
best=0; keep=""
[ "$DRY" = "1" ] || ssh $S -p "$P" root@"$H" "rm -f /workspace/comfy/output/$TAG-a*" >/dev/null 2>&1
for i in $(seq 1 8); do
  v=$(( (i-1)%4 ))
  case $i in 1|2|3|4) cfg=5.0;smp=euler_ancestral;;5|6|7) cfg=6.5;smp=euler_ancestral;;*) cfg=7.5;smp=dpmpp_2m;;esac
  T="$TAG-a$i"; echo "--- a$i cfg=$cfg smp=$smp var=$v"
  sed -n 's/^P: //p' "$B" > /tmp/anc/p.txt; printf ', %s\n' "${V[$v]}" >> /tmp/anc/p.txt
  sed -n 's/^N: //p' "$B" > /tmp/anc/n.txt; printf ', %s\n' "${N[$v]}" >> /tmp/anc/n.txt
  if [ "$DRY" = "1" ]; then FN=/tmp/anc/b.png; else
    scp $S -P "$P" /tmp/anc/p.txt root@"$H":/workspace/comfy/input/prompt-$POSE.txt >/dev/null 2>&1
    scp $S -P "$P" /tmp/anc/n.txt root@"$H":/workspace/comfy/input/neg-$POSE.txt >/dev/null 2>&1
    ssh $S -p "$P" root@"$H" "bash /root/gen.sh $POSE $SEED $T $cfg $smp" >/dev/null 2>&1
    FN=""; for t in $(seq 1 15); do FN=$(ssh $S -p "$P" root@"$H" "ls -t /workspace/comfy/output/$T* 2>/dev/null|head -1"); [ -n "$FN" ] && break; sleep 4; done
  fi
  [ -n "$FN" ] || { echo "a$i nofile"; continue; }
  if [ "$DRY" = "1" ]; then cp /tmp/anc/b.png /tmp/anc/try.png; else scp $S -P "$P" "root@$H:$FN" /tmp/anc/try.png >/dev/null 2>&1; fi
  read em dk bot fil < <(python tools/score.py /tmp/anc/try.png)
  echo "a$i edge=$em dark=$dk bot=$bot fill=$fil $([ "$bot" -ge 1200 ] && echo CROP || echo ok)"
  if [ "$(python -c "print(1 if $em>$best and $bot<1200 and $fil<95 else 0)")" = "1" ]; then best=$em;keep=$FN;fi
  [ "$(python -c "print(1 if $em>=$GE and $dk>=$GD and $bot<1200 and $fil<95 else 0)")" = "1" ] && { echo "PASS a$i";break; }
done
[ -n "$keep" ] && { [ "$DRY" = "1" ] || ssh $S -p "$P" root@"$H" "cp $keep /workspace/comfy/output/$TAG-best.png"; echo "kept $keep edge=$best"; }
