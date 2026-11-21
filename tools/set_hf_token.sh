#!/usr/bin/env bash
set -euo pipefail
T=${1:-$(cat)}
T=$(printf '%s' "$T" | tr -d '[:space:]')
case "$T" in
  hf_oauth*) echo "that is the OAuth token, not a classic one"; exit 1;;
  hf_*) ;;
  *) echo "not an hf_ token"; exit 1;;
esac
cd "$(git rev-parse --show-toplevel)"
OLD=$(hf auth token --format quiet)
printf '%s' "$T" | gh secret set HF_TOKEN && echo "secret set"
printf '%s' "$OLD" | gh secret set HF_TOKEN_OAUTH && echo "oauth kept as HF_TOKEN_OAUTH"
gh workflow run mirror-hf.yml >/dev/null 2>&1
sleep 30
R=$(gh run list --workflow=mirror-hf.yml --limit 1 --json databaseId,conclusion 2>/dev/null)
echo "$R"
case "$R" in
  *success*) echo "CLASSIC TOKEN WORKS" ;;
  *) echo "FAILED - rolling back"
     printf '%s' "$OLD" | gh secret set HF_TOKEN
     echo "HF_TOKEN restored to oauth"; exit 1;;
esac
