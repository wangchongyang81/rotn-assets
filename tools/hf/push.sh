#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/../.."
[[ -n ${1:-} ]] || { echo 'usage: push.sh lora/NAME' >&2; exit 1; }
hf upload wangchongyang81/rotn-pilot "$1" "$1" --repo-type model
