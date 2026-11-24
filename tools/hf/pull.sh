#!/usr/bin/env bash
set -euo pipefail
D=${1:?render|judge}
case "$D" in
  judge) R=rotn-judge-env; T=/workspace/models/judge ;;
  render) R=rotn-render-env; T=/workspace/models/render ;;
esac
mkdir -p "$T"
hf download "$R" --repo-type model --local-dir "$T"
echo "pulled $R -> $T"
