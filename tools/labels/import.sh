#!/usr/bin/env bash
# Stable copies: art/labels/src/<prefix>-NNN.png + manifest row.
set -uo pipefail
D=${1:?src dir}; X=${2:?prefix}; M=${3:-art/labels/manifest.jsonl}
S=${SRC:-art/labels/src}; mkdir -p "$S"; touch "$M"
n=$(grep -c "\"pre\":\"$X\"" "$M" 2>/dev/null); n=${n:-0}
for f in "$D"/*.png; do
  [ -e "$f" ] || continue; b=$(basename "$f")
  grep -q "\"src\":\"$b\"" "$M" 2>/dev/null && continue
  n=$((n+1)); id=$(printf '%s-%03d' "$X" "$n")
  cp "$f" "$S/$id.png"
  printf '{"id":"%s","pre":"%s","src":"%s","sha":"%s"}\n' "$id" "$X" "$b" "$(sha256sum "$f"|cut -c1-16)" >> "$M"
done
echo "total=$(wc -l < "$M")"
