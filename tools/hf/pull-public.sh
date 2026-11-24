#!/usr/bin/env bash
set -euo pipefail
D=${1:?render|judge}
case "$D" in
  judge) R=Qwen/Qwen2.5-VL-7B-Instruct; T=/workspace/models/judge ;;
  render) R=Laxhar/noobai-XL-1.1; T=/workspace/models/render ;;
esac
command -v hf >/dev/null || python3 -m pip install -q -U "huggingface_hub[cli]"
mkdir -p "$T"
hf download "$R" --local-dir "$T"
echo "pulled public $R -> $T"
