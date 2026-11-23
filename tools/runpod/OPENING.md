# Next session, first box
No live pod; id, ip and SSH port change each start.
1. bash tools/runpod/create.sh then cat /tmp/pod.id
2. Poll bash gql.sh '{"query":"query{ pod(input:{podId:\"<id>\"}){ runtime{ ports{ ip public private } } } }"}'
   until an ip and a 22xx public port print.
3. Verify before any render:
   readlink -f all five /opt/ComfyUI links, must be /workspace/comfy
   grep -c 'CFG=\|SMP=' /workspace/gen.sh, must be 2
   git show HEAD:tools/runpod/prompt-tpose.txt > /workspace/prompt-tpose.txt
   skel-tpose.png goes in input/, sha256 must equal sha-tpose.txt
   bash /workspace/boot.sh, poll http 200
4. MAX=4 bash tools/runpod/loop.sh H P tpose o1 7 — seed 7, strength 0.9, steps 28.
   CFGPIN 5.0 was the failing end; sweep the band.
