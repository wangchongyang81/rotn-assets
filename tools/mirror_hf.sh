#!/usr/bin/env bash
set -euo pipefail
R=wangchongyang81/rotn-pilot
B=hf://buckets/wangchongyang81/rotn-bin
M=${1:-text}
case "$M" in
  text)
    while IFS= read -r f; do
      hf upload "$R" "$f" "${f#art/}"
    done < <(find art/manifests art/realms art/labels docs tools/runpod -type f)
    echo "mirrored text"
    ;;
  models)
    hf buckets sync /workspace/comfy/models "$B/models" --include '*.safetensors' --plan /root/models.plan
    echo "planned models - apply: hf buckets sync --apply /root/models.plan"
    ;;
  snapshots)
    hf buckets sync /workspace/images "$B/snapshots" --include '*.tar.gz' --plan /root/snaps.plan
    echo "planned snapshots - apply: hf buckets sync --apply /root/snaps.plan"
    ;;
  *) echo "usage: $0 text|models|snapshots"; exit 1;;
esac
