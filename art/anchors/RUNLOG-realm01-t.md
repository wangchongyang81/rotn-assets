# realm-01 anchor T run log r1t25-r1t37
Target skin 150/105/85. euler_ancestral, seed 7, 832x1216, cfg 4.0 unless noted.
CFG sweep 6.0/4.5/4.0 = 253/237/220, monotone. 3.4 re-noises. 4.0 is the floor.
| run | change | leg sides | torso | bg frac | bytes | verdict |
| r1t25 | cfg 4.0 | 220/158/119 | 219/157/119 | 1.0 | 191517 | baseline |
| r1t26 | cfg 3.4 dark 1.8 | 234/174/137 | 233/172/137 | 0.35 | 684266 | noise |
| r1t27 | dark 1.8 | 220/160/119 | 220/158/119 | 1.0 | 191036 | weight flat |
| r1t28 | dim 1.2 white 1.5 | 209/139/93 | 209/139/94 | 0.01 | 731940 | value moves, bg greys |
| r1t29 | white 2.0 dim 1.1 | 210/151/111 | 209/149/111 | 1.0 | 202839 | bg decoupled |
| r1t30 | dim 1.4 | 209/154/103 | 171/104/75 | 0.03 | 594886 | torso moves, legs lag |
| r1t31 | white 2.4 | 201/162/119 | 200/150/114 | 0.7 | 472152 | white overrode dim |
| r1t32 | dim 1.8 | 171/125/93 | 178/129/105 | 0.05 | 1110449 | flattest body |
| r1t33 | white 3.2 solid bg | 214/218/202 | hair hit | 0.02 | 751798 | grey regression |
| r1t34 | r1t32 @36 steps | 153/112/75 | 154/109/85 | 0.06 | 1167217 | TONE LANDED |
| r1t35 | img2img 0.25 dim 1.1 | 146/96/53 | 150/87/62 | 0.01 | 1457730 | overshoot |
| r1t36 | dpmpp_2m karras | 184/148/119 | 176/142/112 | 0.11 | 1174283 | tone lifted |
| r1t37 | flat bg tags | bg bleed | 128/97/75 | 0.03 | 728472 | tone cost 22 |

## Winning config = r1t34, 36 steps
P: (t-pose:1.5), masterpiece, best quality, very aesthetic, absurdres, solo, 1girl,
(brown skin:1.3), (dark skin:1.4), anime style, cel shading, nude, completely nude,
breasts, nipples, navel, vagina, labia, bare feet, detailed face, detailed eyes,
arms straight out horizontal, straight elbows, hands open, five fingers, standing straight,
legs straight, feet visible, straight-on front view, head level, (full body:1.4), wide shot,
entire figure visible, female adult mid-twenties, medium build, head to body ratio 1 to 7,
simple background, (white background:2.4), (dim lighting:1.8), even flat light,
long black hair, red bindi
N: (orange skin:1.5), tan skin, saturated, mannequin, 3d render, faceless, four arms,
extra arms, malformed hands, extra fingers, distorted face, chibi, painterly, western comic,
(ground shadow:1.5), watermark, clothing, arms down, a-pose, arms angled down, cropped feet,
out of frame, (halo:1.4), gradient shading, small head, long torso, profile view,
oversized breasts, blue tint, black background, kitten, cat, close-up, portrait, zoomed in,
blue background, pink background, pale skin, light skin, fair skin, cream skin, porcelain skin,
blonde hair, bright lighting, high key, grey background, gradient background, vignette

## Open on resume
1. Profiler: mtop 0 persists. Threshold 40 -> 80, per-row median bg, keeps contiguous wash out.
2. Border grain is decode noise, not weight. Not chased further.
3. Leg74 right sample off-skin (168/132/123), use leg58/66 only.

## ACCEPTED 2026-11-21
Anchor T = r1t34. Tone verified at fixed x, three passes:
torso 30% 154/109/85, leg 58% 153/111/75, x380 and x450 both on-skin.
Target 150/105/85. Red +4, green +4, blue 0. Accepted.
Band detector unreliable: figure is full-bleed (top 0, bot 1215) and a soft
bottom wash widens the run so leg66 samples fall off-skin. Use fixed x for
tone on this anchor. Border grain = decode noise, cosmetic, not chased.
