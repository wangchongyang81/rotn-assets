#!/usr/bin/env bash
set -euo pipefail
R=wangchongyang81/rotn-pilot
M=${1:-text}
case "$M" in
  text)
    hf upload "$R" art/manifests manifests --include '*.jsonl' --include '*.md'
    hf upload "$R" docs docs --include '*.md'
    ;;
  models)
    hf upload "$R" /workspace/comfy/models models --include '*.safetensors'
    ;;
  snapshots)
    hf upload "$R" /workspace/images snapshots --include '*.tar.gz'
    ;;
  *) echo "usage: $0 text|models|snapshots"; exit 1 ;;
esac
echo "mirrored $M"
