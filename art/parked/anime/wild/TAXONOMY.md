# Wildcard taxonomy
Basis: photoreal explicit SDXL checkpoints, read 2026-11-26. No pose axis.
Sections are machine-concatenated later. Not prose.

## LAW 0 - the environment owns the frame
No skeleton, no pose carrier. One natural stance is fixed in the dat and never
varies. The realm environment section supplies ground, light and air. The card
warns that critical composition tags conflict; keep pose to four tags maximum.

## quality.pos
masterpiece, best quality, absurdres, photorealistic, raw photo
Five words is the ceiling. More stacks into mush.

## frame.pos - one only
full body, standing, feet in frame, full figure

## body.pos - ladder, stop at the rung reached
0 clothed 1 topless 2 nude 3 completely nude 4 spread legs 5 act
4 and 5 require rung 3 present. Never 2 and 3 together.

## censor.neg - suppression is negative, never positive
bar censor, mosaic censoring, pixelated, censored, light censor
uncensored as a positive is weak. The negatives do the work.

## style.neg - the photoreal gate
illustration, anime, anime style, cel shading, lineart, flat colour, flat shading,
painting, sketch, cgi, 3d render, plastic skin, doll skin, waxy skin
Every one is a way the model drifts back to anime. Never drop the block.

## layout.neg - vital for a single-figure anchor
comic, multiple views, 2koma, 4koma, split screen, reference sheet, character sheet

## lighting.pos - real light on real skin
natural light, soft key, sharp focus, real skin texture, visible pores, sheen of sweat
Light comes from the environment section, not from a studio rig.

## env.pos - one only, realm-matched
Ten sections, env.v1 to env.v10, one per variant in 07. Ground, air and light in
one line. Never pair an environment with a studio backdrop.

## background.neg - scenery is wanted now
gradient background, blurry, soft focus, oversaturated
scenery, props and background clutter left the negative when the realm became
the setting. Bokeh and depth of field left too; photoreal wants them.

## skin.pos - realm axis, one ladder only
brown skin 1.3 / dark skin 1.4 are the same axis. Pick one, never both.
tan skin 1.3 is the neighbouring rung and goes in the negative if not wanted.
orange skin is a hue error, always negative at 1.5.

## hair.pos - keep to two
long black hair
One length, one colour, one optional detail. Three hair tags smear the head.

## anatomy.pos - fixed, never varies
1girl, solo, female adult mid-twenties, medium build, head to body ratio 1 to 7
solo is mandatory. No pair tags on a single-figure anchor.

## CONTRADICTIONS - never in the same string
full body + close-up
brown skin + dark skin
topless + completely nude
3 quality words
cowboy shot + full body
two environments
scenery negated while an env section is present
