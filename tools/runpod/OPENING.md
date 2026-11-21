# Next session, first box
Pod hu71k90wajsl8o is stopped; IP and SSH port change every start.
1. Start and poll:
   runpodctl pod start hu71k90wajsl8o
   repeat `runpodctl pod get hu71k90wajsl8o | grep runtimeStatus` until running
   read publicIp and the 22xx key of portMappings
2. Connect and verify before any render:
   - readlink -f on all five /opt/ComfyUI links, must be /workspace/comfy
   - grep -c 'CFG=\|SMP=' /root/gen.sh, must be 2
   - ship base from git HEAD to prompt-tpose.txt, never a .bak
   - sha256 skel-tpose.png must equal sha-tpose.txt
   - bash /root/restart.sh, poll http 200
3. First sweep: MAX=4 CFGPIN=5.0 bash tools/runpod/loop.sh H P tpose o1 7
   Sampler changes moved edge 1.4 in total; cfg is the only live lever.
