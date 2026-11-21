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
    ;;
  models)
    hf buckets cp /workspace/comfy/models "$B/models" --recursive --include '*.safetensors'
    ;;
  snapshots)
    hf buckets cp /workspace/images "$B/snapshots" --recursive --include '*.tar.gz'
    ;;
  *) echo "usage: $0 text|models|snapshots"; exit 1;;
esac
echo "mirrored $M"
