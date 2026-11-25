#!/usr/bin/env bash
set -uo pipefail
cd "$(dirname "$0")"
[ -s "${PROBE:-pod-probe.json}" ] || { echo NOPROBE >&2; exit 1; }
N=${TRIES:-4}; S=${SLEEP:-30}
for i in $(seq 1 "$N"); do
  out=$(python3 - <<'PY'
import json,os
d=json.load(open(os.environ.get("PROBE") or "pod-probe.json")); e=os.environ
g=e.get("GPU") or d["gpu"]["id"]; c=e.get("CLOUD") or d["cloud"]
dc=e.get("DC") or d["dataCenterIds"][0]; v=e.get("VOLUME") or d["mounts"]["network"][0]["volumeId"]
mp=e.get("MOUNT") or d["mounts"]["network"][0]["path"]; tok=e.get("HF_TOKEN") or ""
env="," + 'env:[{key:"HF_TOKEN",value:"%s"}]' % tok if tok else ""
q=('mutation{ podFindAndDeployOnDemand(input:{ cloudType:%s, gpuCount:%s,'
   ' gpuTypeId:"%s", dataCenterId:"%s", name:"%s", imageName:"%s",'
   ' containerDiskInGb:%s, networkVolumeId:"%s", volumeMountPath:"%s",'
   ' ports:"%s", startSsh:true%s }){ id desiredStatus } }') % (
   c, d["gpu"]["count"], g, dc, d["name"], d["image"], d["disk"],
   v, mp, ",".join(d["ports"]), env)
print("POD %s %s %s" % (g, dc, c))
print(json.dumps({"query":q}))
PY
  )
  lab=$(printf '%s' "$out" | sed -n 1p)
  b=$(printf '%s' "$out" | sed -n '2,$p')
  if [[ ${DRY:-0} == 1 ]]; then echo "$lab"; printf '%s\n' "$b"; continue; fi
  r=$(bash gql.sh "$b")
  id=$(printf '%s' "$r" | python3 -c 'import json,sys
d=json.load(sys.stdin);p=(d.get("data") or {}).get("podFindAndDeployOnDemand")
print(p["id"] if p else "")' 2>/dev/null)
  [[ -n $id ]] && { echo "$lab"; echo "id $id"; echo "$id" > /tmp/pod.id; exit 0; }
  echo "try $i $lab: $(printf '%s' "$r" | head -c 110)"; sleep "$S"
done
echo "no capacity" >&2
[[ ${DRY:-0} == 1 ]] && { echo "(dry) mutations only"; exit 0; }
exit 1
