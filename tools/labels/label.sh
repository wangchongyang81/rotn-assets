#!/usr/bin/env bash
# Schema, one JSON line per image:
#  id pose(t=tpose h=hard x=other) verdict(p/f) hands(o/b)
#  limbs(o/e/m) face(o/b) nudity(f/p/c) crop(n/f/h/s) style(l/m/g) notes
# Mix target: >=30% hard or other, >=30% fail, >=10 known-bad per defect.
set -uo pipefail
D=${1:?dir}; O=${2:?out}
mkdir -p "$(dirname "$O")"; touch "$O"
have(){ sed -n 's/.*"id":"$$[^"]*$$".*/\1/p' "$O"; }
mapfile -t A < <(ls "$D"/*.png 2>/dev/null | xargs -rn1 basename | sort)
mapfile -t H < <(have)
a(){ read -r -p "$1 ($2): " v; case " $2 " in *" $v "*) printf '%s' "$v";; *) printf '?%s' "$v";; esac; }
n=0
for f in "${A[@]}"; do
  printf '%s\n' "${H[@]:-}" | grep -qxF "$f" && continue
  n=$((n+1)); echo "=== $n | $f"; echo "file: $D/$f"
  p=$(a pose "t h x"); v=$(a verdict "p f"); h=$(a hands "o b"); l=$(a limbs "o e m")
  fa=$(a face "o b"); nu=$(a nudity "f p c"); cr=$(a crop "n f h s"); st=$(a style "l m g")
  read -r -p "notes: " nt
  printf '{"id":"%s","pose":"%s","verdict":"%s","hands":"%s","limbs":"%s","face":"%s","nudity":"%s","crop":"%s","style":"%s","notes":"%s"}\n' "$f" "$p" "$v" "$h" "$l" "$fa" "$nu" "$cr" "$st" "${nt//\"/\'}" >> "$O"
done
echo "total=$(wc -l < "$O")"
