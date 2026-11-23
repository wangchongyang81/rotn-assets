#!/usr/bin/env bash
set -uo pipefail
cd "$(dirname "$0")/.."
python3 tools/validate_manifests.py || exit 1
python3 tools/validate_locks.py || exit 1
