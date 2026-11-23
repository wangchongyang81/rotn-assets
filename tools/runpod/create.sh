#!/usr/bin/env bash
set -uo pipefail
cd "$(dirname "$0")"
V=${VOLUME:-39dhm3ia6u}
DC=${DC:-EU-RO-1}
CLOUD=${CLOUD:-SECURE}
N=${TRIES:-4}
S=${SLEEP:-30}
G=${GPU:-NVIDIA A100 PCIe}
for i in $(seq 1 "$N"); do
  b=$(python3 - "$V" "$DC" "$G" "$CLOUD" <<'PY'
import json,sys
v,dc,g,c=sys.argv[1:5]
q=('mutation{ podFindAndDeployOnDemand(input:{ cloudType:%s, gpuCount:1,'
   ' gpuTypeId:"%s", dataCenterId:"%s", name:"rotn-pilot-2",'
   ' imageName:"runpod/pytorch:2.4.0-py3.11-cuda12.4.1-devel-ubuntu22.04",'
   ' containerDiskInGb:50, minMemoryInGb:15, volumeInGb:150,'
   ' networkVolumeId:"%s", volumeMountPath:"/workspace",'
   ' ports:"8188/http,22/tcp", startSsh:true }){ id desiredStatus } }')%(c,g,dc,v)
print(json.dumps({"query":q}))
PY
)
  if [[ ${DRY:-0} == 1 ]]; then printf '%s\n' "$b" | grep -o 'cloudType:[A-Z]*\|gpuTypeId:[^,^]*' | cut -c1-52; continue; fi
  r=$(bash gql.sh "$b")
  id=$(printf '%s' "$r" | python3 -c 'import json,sys;d=json.load(sys.stdin);p=(d.get("data") or {}).get("podFindAndDeployOnDemand");print(p["id"] if p else "")' 2>/dev/null)
  [[ -n $id ]] && { echo "POD $id $G"; echo "$id" > /tmp/pod.id; exit 0; }
  echo "try $i $G: $(printf '%s' "$r" | head -c 110)"; sleep "$S"
done
echo "no capacity at $DC" >&2; exit 1
