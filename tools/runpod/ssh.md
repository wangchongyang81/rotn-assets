# Pod access

The exec API is 403 with this key: "cannot run commands on pods".
SSH is the route.

direct: ssh root@213.173.108.144 -p 19620
proxy:  ssh d3vgbw5tt32pu3-644111f9@ssh.runpod.io
comfy:  http://213.173.108.144:60141
key:    ~/.ssh/id_ed25519

Public ip and port are per-pod: read .runtime.ports[] where private is 22.
The 100.65.x addresses are pod-internal and do not route.
