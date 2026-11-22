#!/usr/bin/env bash
# one line: pose(t h x) verdict(p f) hands(o b) limbs(o e m) face(o b)
#   nudity(f p c) crop(n f h s) style(l m g) then notes
# mix: >=30% hard/other, >=30% fail, >=10 known-bad per defect
set -uo pipefail
D=${1:?dir}; O=${2:?out}; touch "$O"
mapfile -t H < <(grep -o '"id":"[^"]*"' "$O" 2>/dev/null | cut -d'"' -f4)
mapfile -t A < <(ls "$D"/*.png 2>/dev/null | xargs -rn1 basename | sort)
n=0
for f in "${A[@]}"; do
  grep -qxF "${f%.png}" <(printf '%s\n' "${H[@]:-}") && continue
  n=$((n+1)); echo "=== $n | $f"; echo "file: $D/$f"
  read -r -p "pose verdict hands limbs face nudity crop style notes: " p v h l fa nu cr st nt
  printf '{"id":"%s","pose":"%s","verdict":"%s","hands":"%s","limbs":"%s","face":"%s","nudity":"%s","crop":"%s","style":"%s","notes":"%s"}\n' "$f" "$p" "$v" "$h" "$l" "$fa" "$nu" "$cr" "$st" "${nt:-}" >> "$O"
done
echo "total=$(wc -l < "$O")"
