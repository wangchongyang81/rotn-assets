# Anchor render order

32 prompts. Do not render in id order — a bad body caught early saves six.

## Stage A — proportion probe (2 renders)
`anchor-v1-female-t/front` then `anchor-v2-female-t/front`. Nothing else until
both are approved on build, silhouette, hand and face.

## Stage B — views (6 renders)
The remaining three views for those two anchors. Check the side profile and the
back before the pose is trusted.

## Stage C — poses (8 renders)
T and P for both, same seeds. P must be the same body as T or the lock is wrong.

## Stage D — male (16 renders)
Both variants, all views, both poses, same order as A to C.

## Landing
Approved image lands beside its prompt as `<view>.png`, plus `<view>-gen.png`
for the raw model output. Rejected renders go to `reject/<view>-<n>.png`, never
overwritten. `lock.json` gets `approved: true` and the accepted seed only when
the whole anchor passes.

## Never
Never mix anchors in one batch. Never change a seed mid-anchor. Never approve
from the three-quarter alone.
