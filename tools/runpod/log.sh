#!/usr/bin/env bash
set -uo pipefail
M=${M:-art/labels/attempts.jsonl}; L=${L:-art/labels/labels.jsonl}
P=${PS:-art/prompts/wild/noobai/brown-on}
h(){ sha256sum "$1" 2>/dev/null | cut -c1-16; }
case ${1:?} in
attempt)
  ps=$(h "$P/$POSE.txt"); ns=$(h "$P/neg-$POSE.txt")
  [ -n "$ps" ] && cp "$P/$POSE.txt" "art/labels/prompts/$ps.txt"
  [ -n "$ns" ] && cp "$P/neg-$POSE.txt" "art/labels/prompts/$ns.txt"
  printf '{"id":"%s","tag":"%s","pose":"%s","attempt":%s,"seed":%s,"cfg":%s,"smp":"%s","steps":28,"sched":"karras","model":"NoobAI-XL-v1.1.safetensors","cn":"openpose-xinsir-sdxl.safetensors","cn_str":0.85,"w":832,"h":1216,"prompt_sha":"%s","neg_sha":"%s","gen_sha":"%s","ts":"%s","gate":{"GE":%s,"GD":%s,"mean_max":226,"fill_max":95,"bot_max":1200},"score":{"edge":%s,"dark":%s,"bot":%s,"fill":%s,"mean":%s},"verdict":"%s"}\n' "$ID" "$TAG" "$POSE" "$ATTEMPT" "$SEED" "$CFG" "$SMP" "$ps" "$ns" "$(h tools/runpod/gen.sh)" "$(date -u +%FT%TZ)" "${GE:-4.0}" "${GD:-1.5}" "${EM:-0}" "${DK:-0}" "${BOT:-0}" "${FIL:-0}" "${MN:-255}" "${VERDICT:-none}" >> "$M"
  ;;
label)
  printf '{"id":"%s","human":"%s","notes":"%s","ts":"%s"}\n' "${ID:?}" "${H:-}" "${NT:-}" "$(date -u +%FT%TZ)" >> "$L"
  ;;
lock)
  printf '{"id":"%s","prompt_sha":"%s","seed":%s,"ts":"%s"}\n' "${ID:?}" "$(h "$P/$POSE.txt")" "${SEED:?}" "$(date -u +%FT%TZ)" >> art/labels/lock.jsonl
  ;;
esac
