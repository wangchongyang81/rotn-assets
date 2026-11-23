#!/usr/bin/env bash
set -uo pipefail
cd "$(dirname "$0")"
V=${VOLUME:-39dhm3ia6u}
DC=${DC:-EU-RO-1}
N=${TRIES:-5}
for i in $(seq 1 "$N"); do
  b=$(python3 - "$V" "$DC" <<'PY'
import json,sys
v,dc=sys.argv[1],sys.argv[2]
q=('mutation{ podFindAndDeployOnDemand(input:{ cloudType:SECURE, gpuCount:1,'
   ' gpuTypeId:"NVIDIA GeForce RTX 4090", dataCenterId:"%s", name:"rotn-pilot-2",'
   ' imageName:"runpod/pytorch:2.4.0-py3.11-cuda12.4.1-devel-ubuntu22.04",'
   ' containerDiskInGb:50, minMemoryInGb:15, volumeInGb:150,'
   ' networkVolumeId:"%s", volumeMountPath:"/workspace",'
   ' ports:"8188/http,22/tcp", startSsh:true }){ id desiredStatus } }')%(dc,v)
print(json.dumps({"query":q}))
PY
)
  if [[ ${DRY:-0} == 1 ]]; then printf '%s' "$b" | cut -c1-400; echo; exit 0; fi
  r=$(bash gql.sh "$b")
  id=$(printf '%s' "$r" | python3 -c 'import json,sys;d=json.load(sys.stdin);p=(d.get("data") or {}).get("podFindAndDeployOnDemand");print(p["id"] if p else "")' 2>/dev/null)
  [[ -n $id ]] && { echo "POD $id"; echo "$id" > /tmp/pod.id; exit 0; }
  echo "try $i: $(printf '%s' "$r" | head -c 110)"; sleep 20
done
echo "no capacity at $DC" >&2; exit 1
