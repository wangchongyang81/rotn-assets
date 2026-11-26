# wild - generated prompt sets
Source of truth: wild.dat. Generator: tools/gen_wild.py <model> <skin> <hair>
models: illus | noobai. skin: brown | dark | none. hair: on | off.
No pose axis. One file per environment, v1 to v10, matched to the 07 variants.
Never edit the .txt files - regenerate.

## Audit 2026-11-26
60 files, 10 per model/skin, all v-named. Photoreal quality, one natural stance,
realm environment, style.neg present, no pose names left.

## Open
Skeletons deleted 2026-11-26 with the lock method. No ControlNet pose reference
is pushed; push-ppose.sh sends prompt, negative and hash only.
The dat now has one shared [quality], so illus and noobai emit identical text.
Either split the quality section again or collapse the model axis.
