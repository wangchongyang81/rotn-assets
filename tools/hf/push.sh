#!/usr/bin/env bash
set -euo pipefail
D=${1:?render|judge}
case "$D" in
  judge) R=rotn-judge-env; T=/workspace/models/judge ;;
  render) R=rotn-render-env; T=/workspace/models/render ;;
esac
hf upload "$R" "$T" . --repo-type model
echo "pushed $T -> $R"
