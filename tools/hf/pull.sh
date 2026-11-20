#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/../.."
hf download wangchongyang81/rotn-pilot --repo-type model --local-dir .
