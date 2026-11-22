#!/usr/bin/env bash
set -uo pipefail
D=${1:?src}; X=${2:?prefix}; M=${3:-art/labels/manifest.jsonl}
S=${SRC:-art/labels/src}; T=${THUMB:-art/labels/thumbs}
mkdir -p "$S" "$T"; touch "$M"
n=$(grep -c "\"pre\":\"$X\"" "$M" 2>/dev/null); n=${n:-0}
for f in "$D"/*.png; do
  [ -e "$f" ] || continue; b=$(basename "$f")
  grep -q "\"src\":\"$b\"" "$M" 2>/dev/null && continue
  n=$((n+1)); id=$(printf '%s-%03d' "$X" "$n")
  cp "$f" "$S/$id.png"
  python -c "from PIL import Image;im=Image.open('$S/$id.png');im.thumbnail((256,256));im.convert('RGB').save('$T/$id.webp','WEBP',quality=80)"
  printf '{"id":"%s","pre":"%s","src":"%s","sha":"%s"}\n' "$id" "$X" "$b" "$(sha256sum "$f"|cut -c1-16)" >> "$M"
done
echo "total=$(wc -l < "$M")"
