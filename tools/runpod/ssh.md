# Pod access

The exec API is 403 with this key: "cannot run commands on pods".
SSH is the route. One pod only: rotn-pilot.

ip and port are per-pod and change every start. Never reuse the values
below; resolve them.

1. id:      runpodctl pod list
2. ip/port: bash sshinfo.sh ID
3. ssh:     ssh -i ~/.ssh/id_ed25519 -p PORT root@IP

sshinfo.sh reads runtime.ports for private 22 and prints "IP PUBLIC".
Runtime is null while EXITED, so resolve only after RUNNING.

The proxy form ssh.runpod.io rejects this key. The 100.65.x addresses are
pod-internal and do not route. key: ~/.ssh/id_ed25519

comfy is the public port published as 8188/http on the same ip, not a
fixed number: http://IP:PORT from that same ports entry.
