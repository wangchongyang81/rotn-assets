import json, os
D = os.path.dirname(os.path.abspath(__file__))
d = json.load(open(os.path.join(D, os.environ.get("PROBE") or "pod-probe.json")))
e = os.environ
b = {
 "name": d["name"],
 "image": d["image"],
 "gpuTypeIds": [e.get("GPU") or d["gpu"]["id"]],
 "gpuCount": d["gpu"]["count"],
 "cloudType": e.get("CLOUD") or d["cloud"],
 "dataCenterIds": [e.get("DC") or d["dataCenterIds"][0]],
 "networkVolumeId": e.get("VOLUME") or d["mounts"]["network"][0]["volumeId"],
 "volumeMountPath": e.get("MOUNT") or d["mounts"]["network"][0]["path"],
 "containerDiskInGb": d["disk"],
 "ports": d["ports"],
 "startSsh": d["startSsh"],
}
if e.get("HF_TOKEN"):
    b["env"] = {"HF_TOKEN": e["HF_TOKEN"]}
print(json.dumps(b))
