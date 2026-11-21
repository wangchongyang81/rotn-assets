#!/usr/bin/env bash
set -euo pipefail
R=wangchongyang81/rotn-pilot
B=hf://buckets/wangchongyang81/rotn-bin
M=${1:-text}
case "$M" in
  text)
    while IFS= read -r f; do
      hf upload "$R" "$f" "manifests/${f#art/manifests/}"
    done < <(find art/manifests -name '*.jsonl')
    while IFS= read -r f; do
      hf upload "$R" "$f" "docs/${f#docs/}"
    done < <(find docs -name '*.md')
    hf upload "$R" art/realms realms --include '*.png' --include '*.md' 
    ;;
  models)
    hf buckets sync /workspace/comfy/models "$B/models" --include '*.safetensors' --plan /root/models.plan
    ;;
  snapshots)
    hf buckets sync /workspace/images "$B/snapshots" --include '*.tar.gz' --plan /root/snaps.plan
    ;;
  *) echo "usage: $0 text|models|snapshots"; exit 1;;
esac
echo "planned $M, apply with: hf buckets sync --apply <plan>"
