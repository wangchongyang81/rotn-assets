# 2026-11-22 — boot repair, bindi uncovered, resolution test

## Done
- PEP 668 boot failure on the 24.04 image: --break-system-packages on both pip lines; server up on the 4500, 5 links verified, commit 8f40b43 intact.
- hair between eyes removed from wild.dat [hair] and TAXONOMY (it covered the bindi); all four combos regenerated.
- Committed .txt were STALE against wild.dat: the quality slot moved to flat colour/flat shading/cel shading at 4d9320c and never regenerated. Every prior gate figure was measured on the old lineart style.
- feet in frame, full figure restored into [frame]; the generator parts list has no feet clause, so today's regens silently dropped it.
- Shading negatives moved out of bg.neg into shade.neg; bg.neg keeps blurry/soft focus/bokeh.
- red bindi weight 1.0 -> 1.3 (drew on 1 of 2 at 1.0).
- score.py: y1 normalised to a 1216 basis, identity at 832, regression-clean on 8 frames.
- gen.sh/loop.sh: RW/RH env, defaults 832x1216. H is the host, hence RW/RH.

## Numbers
- 832 tpose, 8 attempts: bot>1127 on 7/8, 3 ok, 1 CROP, 4 weak. Crop rate 40% -> 12.5%.
- red_px proxy confounded by brightness (a4 15013px at mn 89.2).

## Open
- b1664 at 1152x1664: the bindi count is the question; <4/4 means the dot is at the pixel floor.
- V=("") and N=("") are length 1 while v=$(( (i-1)%4 )) runs 1-4, so no variant ever appends. All attempts are one prompt.
- Gates calibrated on the stale lineart style; recalibrate on flat colour.
- a4 (dark 33.3, mn 89.2) and a8 (mn 235.6) are brightness outliers.

## Pod
- 4500 up, $0.72/hr, /tmp/pod.env.

## Bindi verdict (832, weight 1.3)
- nw5-a6 and nw5-a7 ACCEPTABLE by eye. 2 of 8. Draws but marginal at 1.3, so 1.3 is a floor not a fix.
- b1664 four frames still unscored for the bindi; resolution effect unknown.
- a6 and a7 both passed the gate, so the gate and the eye agree on the acceptable pair.

## Pod state at close
- pod 8m62wybg8zan1j (rotn-pilot-3, RTX PRO 4500) STOPPED, status EXITED.
- volume holds the 90 outputs; storage bills at the small rate.
- restart with runpodctl pod start 8m62wybg8zan1j, then re-run remote-boot.sh.
- the deprecated form is 'runpodctl pod stop <id>', not 'runpodctl stop pod'.
