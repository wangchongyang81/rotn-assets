import json, os
D = os.path.dirname(os.path.abspath(__file__))
d = json.load(open(os.path.join(D, os.environ.get("PROBE") or "pod-probe.json")))
e = os.environ
a = {
 "--name": d["name"], "--image": d["image"],
 "--gpu-id": e.get("GPU") or d["gpu"]["id"],
 "--gpu-count": str(d["gpu"]["count"]),
 "--cloud-type": e.get("CLOUD") or d["cloud"],
 "--data-center-ids": e.get("DC") or d["dataCenterIds"][0],
 "--network-volume-id": e.get("VOLUME") or d["mounts"]["network"][0]["volumeId"],
 "--volume-mount-path": e.get("MOUNT") or d["mounts"]["network"][0]["path"],
 "--container-disk-in-gb": str(d["disk"]),
 "--ports": ",".join(d["ports"]),
}
for k, v in a.items():
    print(f"{k}={v}")
if e.get("HF_TOKEN"):
    print("--env=" + json.dumps({"HF_TOKEN": e["HF_TOKEN"]}))
print("--ssh")
