#!/usr/bin/env bash
set -uo pipefail
cd "$(dirname "$0")"
[ -s "${PROBE:-pod-probe.json}" ] || { echo NOPROBE >&2; exit 1; }
N=${TRIES:-4}; S=${SLEEP:-30}
mapfile -d '' A < <(python3 - <<'PY'
import json,os
d=json.load(open(os.environ.get("PROBE") or "pod-probe.json")); e=os.environ
g=e.get("GPU") or d["gpu"]["id"]; c=e.get("CLOUD") or d["cloud"]
dc=e.get("DC") or d["dataCenterIds"][0]
v=e.get("VOLUME") or d["mounts"]["network"][0]["volumeId"]
mp=e.get("MOUNT") or d["mounts"]["network"][0]["path"]
a=["--image",d["image"],"--gpu-id",g,"--gpu-count",str(d["gpu"]["count"]),
   "--data-center-ids",dc,"--cloud-type",c,"--container-disk-in-gb",str(d["disk"]),
   "--network-volume-id",v,"--volume-mount-path",mp,"--ports",",".join(d["ports"]),
   "--ssh","--name",d["name"],"--wait","--wait-timeout","8m","-o","json"]
t=e.get("HF_TOKEN")
if t: a+=["--env",json.dumps({"HF_TOKEN":t})]
print("POD %s %s %s" % (g,dc,c),end="\0")
print("\0".join(a),end="\0")
PY
)
lab=${A[0]}; A=("${A[@]:1}")
if [[ ${DRY:-0} == 1 ]]; then printf 'runpodctl pod create'; printf ' %q' "${A[@]}"; echo; exit 0; fi
for i in $(seq 1 "$N"); do
  r=$(runpodctl pod create "${A[@]}" 2>&1) && rc=0 || rc=$?
  id=$(printf '%s' "$r" | python3 -c 'import json,sys,re
s=sys.stdin.read()
try: print(json.loads(s).get("id") or "")
except Exception:
    m=re.search(r"\b([a-z0-9]{8,20})\b",s); print(m.group(1) if m else "")' 2>/dev/null)
  [[ -n $id ]] && { echo "$lab"; echo "id $id"; echo "$id" > /tmp/pod.id; exit 0; }
  echo "try $i $lab: $(printf '%s' "$r" | tr '\n' ' ' | head -c 110)"
  [ "$rc" = 0 ] && break
  sleep "$S"
done
echo "no capacity" >&2
exit 1
